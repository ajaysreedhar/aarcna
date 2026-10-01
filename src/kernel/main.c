#include <hardware/uart.h>

void kernel_start() {
    uart0_init();
    uart0_write("Welcome to AARCNA!");
    uart0_close();
}