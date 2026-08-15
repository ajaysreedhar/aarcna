.section .text.boot

.global _start

_start:
    MRS     X9, MPIDR_EL1
    AND     X9, X9, 0xFF
    CBZ     X9, core0_start

core_hang:
    WFE
    B       core_hang

core0_start:
    MRS     X9, CurrentEl
    LDR     X0, =__bss_start_addr__
    LDR     X1, =__bss_end_addr__
    BL      clear_bss
    B       core_hang

clear_bss:
    CMP     X0, X1
    B.HS    1f
    STP     XZR, XZR, [X0], #16
    B       clear_bss
1:
    RET


