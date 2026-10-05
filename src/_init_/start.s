.section .text.boot

.global _start

.extern vtable_el1
.extern kernel_start

_start:
    MRS     X9, MPIDR_EL1
    AND     X9, X9, 0xFF
    CBZ     X9, el1_downgrade

core_hang:
    WFE
    B       core_hang

el1_downgrade:
    MRS     X9, CurrentEl
    TBZ     X9, #3, core0_start
    
    /* Setting EL1 state to AArch64. */
    AND     X9, X9, XZR
    MOVK    X9, #0x8000, LSL #16
    MSR     HCR_EL2, X9

    /* Set target exception level to EL1. */
    MOV     X9, #0x3C5
    MSR     SPSR_EL2, X9

    /* Set target entry point for EL1 to continue. */
    ADR     X9, core0_start
    MSR     ELR_EL2, X9

    ERET    

core0_start:
    LDR     X0, =__bss_start_addr__
    LDR     X1, =__bss_end_addr__
    BL      clear_bss

    //*
    ADRP    X0, vtable_el1
    ADD     X0, X0, :lo12:vtable_el1
    MSR     VBAR_EL1, X0
    ISB

    MSR     DAIFClr, #2 // Unmask and enable IRQ.
    // */

    // Setup a temporary stack.
setup_stack0:
    LDR     X9,  =__stack0_top_addr__
    LDR     X10, =__stack0_bottom_addr__
    MOV     SP, X9      // Initially stack top and frame-pointer are same.
    MOV     X29, X9     // X29 is the frame-pointer register as per AAPCS64.

    BL      kernel_start
    B       core_hang

clear_bss:
    CMP     X0, X1
    B.HS    1f
    STP     XZR, XZR, [X0], #16
    B       clear_bss
1:
    RET
