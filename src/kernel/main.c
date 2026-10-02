#include <hardware/uart.h>
#include <video/framebuffer.h>
#include <video/graphics.h>

void kernel_start() {
    uart0_init();
    uart0_write("Hello, World! Welcome to AARCNA.\n");
    uart0_write("If you are reading this, PL011 UART is successfully initialized.\n");

    framebuffer_init(1920, 1080);

    uart0_close();
}