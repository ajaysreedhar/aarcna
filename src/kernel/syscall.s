.section .text

.global transition_el0
.extern shell_main

transition_el0:
    LDR X9,  =__unsafe_el0_base_addr__
    LDR X10, =shell_main

    MSR SP_EL0, X9
    MSR ELR_EL1, X10

    ERET
