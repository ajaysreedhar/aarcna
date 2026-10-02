#include <hardware/bcm2711.h>

enum {
    GPU_MBOX_BASE_REG = ARM_PERIPHERAL_BASE + 0xb880,
    GPU_MBOX_READ_REG = GPU_MBOX_BASE_REG,
    GPU_MBOX_STATUS_REG = GPU_MBOX_BASE_REG + 0x18,
    GPU_MBOX_WRITE_REG = GPU_MBOX_BASE_REG + 0x20,
    MBOX_FULL_MASK = 0x80000000,  // 31st bit is 1 and the remaining are zeros.
    MBOX_EMPTY_MASK = 0x40000000, // 30th bit is set to 1 and the remaining are zeros.
    MBOX_CHANNEL_PROP_TAGS = 0x8,
    MBOX_PROP_CHANNEL = 8
};

void mailbox_write(unsigned int channel, volatile unsigned int* buffer) {
    unsigned int address = (unsigned int)((unsigned long)buffer);
    unsigned int message = (address & (~0xF)) | (channel & 0xF);

    unsigned int status_value = 0;

    do {
        status_value = mmio_read(GPU_MBOX_STATUS_REG);
    } while (status_value & MBOX_FULL_MASK);

    mmio_write(GPU_MBOX_WRITE_REG, message);
}

unsigned int mailbox_read(unsigned int channel) {
    unsigned int message = 0;

    do {
        // Wait until there is something to read.
        while (mmio_read(GPU_MBOX_STATUS_REG) & MBOX_EMPTY_MASK) {
            // Do nothing.
        }

        message = mmio_read(GPU_MBOX_READ_REG);

    } while ((message & 0xF) != channel);

    return message & (~0xF);
}

int mailbox_call(int channel, unsigned int* buffer) {
    mailbox_write(channel, buffer);

    mailbox_read(channel);

    if (buffer[1] == 0x80000000) {
        return 0;
    }

    return -1;
}