#include <hardware/uart.h>
#include <video/framebuffer.h>
#include <video/graphics.h>

void kernel_start() {
    uart0_init();
    uart0_write("Hello, World! Welcome to AARCNA.\n");
    uart0_write("If you are reading this, PL011 UART is successfully initialized.\n");

    struct video_buffer* buffer = framebuffer_init(1920, 1080);
    paint_box(buffer, 200, 200, 220, 220, 0xFFFFAA);

    uart0_close();
}