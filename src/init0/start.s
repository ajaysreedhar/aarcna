.section .text.boot

.global _start

.extern uart0_init
.extern uart0_write
.extern uart0_close
.extern framebuffer_init

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

    // Setup a temporary stack.
    LDR     X9, =__stack0_top_addr__
    MOV     SP, X9      // Initially stack top and frame-pointer are same.
    MOV     X29, X9     // X29 is the frame-pointer register as per AAPCS64.

    BL      uart0_init
    LDR     X0, =msg_hello
    BL      uart0_write
    LDR     X0, =msg_yaay
    BL      uart0_write
    BL      uart0_close

    MOV     W0, #1920
    MOV     W1, #1080
    BL      framebuffer_init

    B       core_hang

clear_bss:
    CMP     X0, X1
    B.HS    1f
    STP     XZR, XZR, [X0], #16
    B       clear_bss
1:
    RET

.section .rodata

msg_hello: .string "Hello, World! Welcome to ARM64 Assembly Workshop.\n"
msg_yaay: .string "If you are reading this, PL011 UART is successfully configured."
