/**
 * This is an experimental configuration for
 * handling interrupts during the init process.
 * 
 * https://support.arm.com/documentation/102412/0103/Handling-exceptions/Taking-an-exception?lang=en
 */

.global el1_vector_table

.section ".text"

preserve_state:
    STP     X29, X30, [SP, #-272]!
    MOV     X29, SP

    STP     X0,  X1,  [SP, #16]
    STP     X2,  X3,  [SP, #32]
    STP     X4,  X5,  [SP, #48]
    STP     X6,  X7,  [SP, #64]
    STP     X8,  X9,  [SP, #80]
    STP     X10, X11, [SP, #96]
    STP     X12, X13, [SP, #112]
    STP     X14, X15, [SP, #128]
    STP     X16, X17, [SP, #144]
    STP     X18, X19, [SP, #160]
    STP     X20, X21, [SP, #176]
    STP     X22, X23, [SP, #192]
    STP     X24, X25, [SP, #208]
    STP     X26, X27, [SP, #224]
    STP     X28, XZR  [SP, #240]

    MRS     X0, SPSR_EL1
    MRS     X1, ELR_EL1
    STP     X0, X1, [SP, #256]

    RET

restore_state:
    LDP     X0, X1, [SP, #256]
    MSR     SPSR_EL1, X0
    MSR     ELR_EL1, X1

    LDP     X0,  X1,  [SP, #16]
    LDP     X2,  X3,  [SP, #32]
    LDP     X4,  X5,  [SP, #48]
    LDP     X6,  X7,  [SP, #64]
    LDP     X8,  X9,  [SP, #80]
    LDP     X10, X11, [SP, #96]
    LDP     X12, X13, [SP, #112]
    LDP     X14, X15, [SP, #128]
    LDP     X16, X17, [SP, #144]
    LDP     X18, X19, [SP, #160]
    LDP     X20, X21, [SP, #176]
    LDP     X22, X23, [SP, #192]
    LDP     X24, X25, [SP, #208]
    LDP     X26, X27, [SP, #224]
    LDP     X28, XZR  [SP, #240]

    MOV     SP, X29
    LDP     X29, X30, [SP], #272

    RET

el1_sp0_sync_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el1_sp0_irq_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el1_sp0_fiq_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el1_sp0_serror_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el1_sp1_sync_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el1_sp1_irq_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el1_sp1_fiq_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el1_sp2_serror_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el0_a64_sync_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el0_a64_irq_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el0_a64_fiq_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el0_a64_serror_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el0_a32_sync_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el0_a32_irq_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el0_a32_fiq_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

el0_a32_serror_handler:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    BL preserve_state
    BL restore_state

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    ERET

/* Executable instructions. */
.section ".text.vectors"
el1_vector_table:
/* Group 1: Current EL with SP_EL0. */
    B   el1_sp0_sync_handler
.balign 128
    B   el1_sp0_irq_handler
.balign 128
    B   el1_sp0_fiq_handler
.balign 128
    B   el1_sp0_serror_handler

/* Group 2: Current EL with SP_EL1. */
.balign 128
    B   el1_sp1_sync_handler
.balign 128
    B   el1_sp1_irq_handler
.balign 128
    B   el1_sp1_fiq_handler
.balign 128
    B   el1_sp2_serror_handler

/* Group 3: EL0 in AArch64 state. */
    B   el0_a64_sync_handler
.balign 128
    B   el0_a64_irq_handler
.balign 128
    B   el0_a64_fiq_handler
.balign 128
    B   el0_a64_serror_handler

/* Group 4: EL0 in AArch32 state. */
.balign 128
    B   el0_a32_sync_handler
.balign 128
    B   el0_a32_irq_handler
.balign 128
    B   el0_a32_fiq_handler
.balign 128
    B   el0_a32_serror_handler
