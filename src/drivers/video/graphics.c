#include <video/graphics.h>

void paint_box(struct video_buffer* buffer, unsigned int x1, unsigned int y1, unsigned int x2, unsigned int y2,
               unsigned int argb) {

    unsigned int iy = y1;
    unsigned int ix = x1;

    fb_ptr_t address = buffer->address;

    while (iy <= y2) {
        ix = x1;

        while (ix <= x2) {
            address = buffer->address + (iy * buffer->pitch) + (ix * 4);
            *address = argb;

            ix++;
        }

        iy++;
    }
}