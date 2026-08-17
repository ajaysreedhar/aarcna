.include "bcm2711.inc.s"

.equ GPU_MBOX_BASE_REG, ARM_PERIPHERAL_BASE + 0xb880,
.equ GPU_MBOX_READ_REG, GPU_MBOX_BASE_REG,
.equ GPU_MBOX_STATUS_REG, GPU_MBOX_BASE_REG + 0x18,
.equ GPU_MBOX_WRITE_REG, GPU_MBOX_BASE_REG + 0x20,

.global mailbox_read
.type mailbox_read, %function

.global mailbox_write
.type mailbox_write, %function

.global mailbox_call
.type mailbox_call, %function

/* Executable instructions. */
.section .text
.balign 4       // Instructions are 4-byte aligned.

/**
 * ============================================================
 * Subroutine: mailbox_read
 * Description: Reads the data from the init0 mailbox for GPU.
 *
 * Inputs:
 *   W0 - Channel descriptor.
 * 
 * Results:
 *   W0 - The 32-bit value read.
 * ============================================================
 */
mailbox_read:
    MOV     X9, #GPU_MBOX_STATUS_REG
    MOV     X10, #GPU_MBOX_READ_REG 
1:
    LDR     W11, [X9]       // MMIO read.
    TBNZ    W11, #30, 1b

    LDR     W11, [X10]      // MMIO read.

    MOV     W12, W11
    AND     W12, W12, 0xF
    CMP     W12, W0
    B.NE    1b

    BIC     W0, W11, 0xF
    RET

/**
 * ============================================================
 * Subroutine: mailbox_write
 * Description: Writes the data to the mailbox for GPU.
 *
 * Inputs:
 *   W0 - Channel descriptor.
 *   X1 - Address of mailbox buffer.
 * 
 * Results:
 *   Void.
 * ============================================================
 */
mailbox_write:
    AND     W0, W0, 0xF
    BIC     W1, W1, 0xF
    ORR     W1, W0, W1

    MOV     X9, #GPU_MBOX_STATUS_REG
    MOV     X10, #GPU_MBOX_WRITE_REG 
1:
    LDR     W11, [X9]       // MMIO read.
    TBNZ    W11, #31, 1b

    STR     W1, [X10]       // MMIO Write.
    RET

/**
 * ============================================================
 * Subroutine: mailbox_call
 * Description: Writes the data and polls for response.
 *
 * Inputs:
 *   W0 - Channel descriptor.
 *   X1 - Address of mailbox buffer.
 * 
 * Results:
 *   Void.
 * ============================================================
 */
mailbox_call:
    STP     X29, X30, [SP, #-32]!
    MOV     X29, SP
    
    STP     X0, X1, [SP, #16] // Preserve the parameters.

    BL      mailbox_write

    LDP     X0, X1, [SP, #16] // Load original parameters again. Don't trust mailbox_write.
    BL      mailbox_read

    LDR     X1, [SP, #24]    // Load X1 parameter value again. Don't trust mailbox_read.
    LDR     W9, [X1, #4]     // Get buffer[1]
         
    MOV     SP, X29
    LDP     X29, X30, [SP], #32

    MOV     W0, WZR
    MOVZ    W10, #0x8000, LSL #16
    CMP     W9, W10
    BEQ     1f
    MOV     W0, #-1

1:  RET
