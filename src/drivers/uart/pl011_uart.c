#include <hardware/bcm2711.h>

static void uart0_putc(char c) {
    unsigned int flags = mmio_read(UART0_FLAG_REG);

    while (flags & (1 << 5)) {
        flags = mmio_read(UART0_FLAG_REG);
    }

    mmio_write(UART0_DATA_REG, c);
}

void uart0_init() {
    // Read the current value of function select for pins
    unsigned int current = mmio_read(GPIO_FUNC_SEL1_REG);

    // Create a reset mask for pins 14 and 15.
    // Each pin starting from 10 uses 3 bits.
    // Therefore bit positions [14, 13, 12] are for pin 14 and
    // positions [17, 16, 15] are for pin 15.
    unsigned int mask = (7 << 12) | (7 << 15);

    // Clear the bits for pin 14 and 15.
    // Inverting the mask as ~mask flips 0s to 1s and 1s to 0s.
    // Performing bitwise AND on the current value with an
    // inverted mask clears the function bits for the pins 14 and 15
    // and leaves bit values of other pins untouched.
    current = current & (~mask);

    // Overwrite the mask with the new values for setting alternate funcion
    // of pins 14 and 15 to UART0. UART0 uses the alternate function 0.
    // The bit value for enabling ALT_FN0 is 0b100 which translates to 4.
    mask = (4 << 12) | (4 << 15);

    // Update the current value with the new mask.
    current = current | mask;

    mmio_write(GPIO_FUNC_SEL1_REG, current);

    // Disable pull up or pull down on the UART0 pins.
    // Bit positions [31, 30] are for GPIO pin 15 and
    // [29, 28] are for GPIO pin 14.
    // Setting these bit positions to 0 disables resistors.
    current = mmio_read(GPIO_PULL_CTRL0_REG);
    mask = (3 << 28) | (3 << 30);
    current = current & (~mask);
    mmio_write(GPIO_PULL_CTRL0_REG, current);

    // UART0 operations.

    // Turn off UART0 before making changes.
    mmio_write(UART0_CTRL_REG, 0x00000000);

    // Wait for busy flag in UART0_FLAG_REG to clear.
    // Busy bit is at position 3 and 8 in binary is 0b1000.
    while (1) {
        current = mmio_read(UART0_FLAG_REG);
        if ((current & 8) == 0) {
            break;
        }
    }

    // Clear pending interrupts.
    mmio_write(UART0_ICL_REG, 0x7FF);

    // Set the integer and fractional bits of baud rate.
    // Desired baud rate is 115200.
    //
    // Baud rate divisor = UART0_CLOCK_FREQ / (16 * baud_rate)
    //
    // Using the above formula:
    //     48000000 / (16 * 115200) = 26.0416666
    //
    // Multiply fractional part by 64:
    //     0.416666 * 64 = 3 (approx)
    mmio_write(UART0_IBRD_REG, 26);
    mmio_write(UART0_FBRD_REG, 3);

    // Enable 8-bit mode.
    mmio_write(UART0_LCRH_REG, (1 << 4) | (3 << 5));

    // Enable UART0, RX and TX.
    mmio_write(UART0_CTRL_REG, 1 | (1 << 8) | (1 << 9));
}

void uart0_write(const char* const text) {
    for (int index = 0; text[index] != '\0'; index++) {
        if (text[index] == '\n') {
            uart0_putc('\r');
        }

        uart0_putc(text[index]);
    }
}

void uart0_close() {
    unsigned int flags = 0x0;
    // Wait for busy flag in UART0_FLAG_REG to clear.
    while (1) {
        flags = mmio_read(UART0_FLAG_REG);

        if ((flags & 8) == 0) {
            break;
        }
    }

    mmio_write(UART0_CTRL_REG, 0x00000000);
}