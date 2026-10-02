.section .text

.global mmio_read
.global mmio_write

mmio_read:
    LDR W0, [X0]
    RET

mmio_write:
    STR W1, [X0]
    RET
