.include "bcm2711.inc.s"

.equ GPU_MBOX_BASE_REG, ARM_PERIPHERAL_BASE + 0xb880,
.equ GPU_MBOX_READ_REG, GPU_MBOX_BASE_REG,
.equ GPU_MBOX_STATUS_REG, GPU_MBOX_BASE_REG + 0x18,
.equ GPU_MBOX_WRITE_REG, GPU_MBOX_BASE_REG + 0x20,

.type mailbox_buffer, %object
.global mailbox_buffer

.global mailbox_read
.type mailbox_read, %function

.global mailbox_write
.type mailbox_write, %function

.global mailbox_call
.type mailbox_call, %function

/* Executable instructions. */
.section .text
.balign 4       // Instructions are 4-byte aligned.

mailbox_read:
    // Implementation

mailbox_write:
    // Implementation

mailbox_call:
    // Implementation

/* Uninitialized data segment. */
.section .bss

.balign 16      // Mailbox buffers should be 16-byte aligned.
.size mailbox_buffer, 144
mailbox_buffer:
.zero 144
