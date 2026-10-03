#include <hardware/bcm2711.h>
#include <video/framebuffer.h>

#define MBOX_BUFFER_SIZE 36

enum {
    MBOX_REQUEST_CODE = 0x0,
    MBOX_TAG_SETPHYWH = 0x00048003,  // Set physical width/height
    MBOX_TAG_SETVIRTWH = 0x00048004, // Set virtual width/height
    MBOX_TAG_SETDEPTH = 0x00048005,  // Set depth (bits per pixel)
    MBOX_TAG_SETPXLORDR = 0x48006,
    MBOX_TAG_GETFB = 0x40001,
    MBOX_TAG_SETVIRTOFF = 0x48009,
    MBOX_TAG_ALLOCBUF = 0x00040001, // Allocate framebuffer
    MBOX_TAG_GETPITCH = 0x00040008, // Get pitch (bytes per line)
    MBOX_TAG_LAST = 0x00000000      // End tag
};

enum {
    MBOX_CH_POWER = 0,
    MBOX_CH_FB = 1,
    MBOX_CH_VUART = 2,
    MBOX_CH_VCHIQ = 3,
    MBOX_CH_LEDS = 4,
    MBOX_CH_BTNS = 5,
    MBOX_CH_TOUCH = 6,
    MBOX_CH_COUNT = 7,
    MBOX_CH_PROP = 8 // Request from ARM for response by VideoCore
};

// MBOX_BUFFER_SIZE = 36
volatile unsigned int __attribute__((aligned(16))) fb_mbox_buffer[MBOX_BUFFER_SIZE];

struct video_buffer vbuffer;

struct video_buffer* framebuffer_init(unsigned int width, unsigned int height) {

    fb_mbox_buffer[0] = 35 * 4; // Size of the mailbox buffer - 35 words, 4 bytes each
    fb_mbox_buffer[1] = MBOX_REQUEST_CODE;

    // Tag: Setting physical width and height.
    fb_mbox_buffer[2] = MBOX_TAG_SETPHYWH;
    fb_mbox_buffer[3] = 2 * 4; // 2 words, 4 bytes each
    fb_mbox_buffer[4] = 0;     // Request code
    fb_mbox_buffer[5] = width;
    fb_mbox_buffer[6] = height;

    // Tag: Setting virtual width and height.
    fb_mbox_buffer[7] = MBOX_TAG_SETVIRTWH;
    fb_mbox_buffer[8] = 8;
    fb_mbox_buffer[9] = 8;
    fb_mbox_buffer[10] = width;
    fb_mbox_buffer[11] = height;

    // Tag: Setting depth.
    fb_mbox_buffer[12] = MBOX_TAG_SETVIRTOFF;
    fb_mbox_buffer[13] = 8;
    fb_mbox_buffer[14] = 8;
    fb_mbox_buffer[15] = 0;
    fb_mbox_buffer[16] = 0;

    fb_mbox_buffer[17] = MBOX_TAG_SETDEPTH;
    fb_mbox_buffer[18] = 4;
    fb_mbox_buffer[19] = 4;
    fb_mbox_buffer[20] = 32; // Bits per-pixel.

    fb_mbox_buffer[21] = MBOX_TAG_SETPXLORDR;
    fb_mbox_buffer[22] = 4; // 2 words, bytes each
    fb_mbox_buffer[23] = 4; // Request code
    fb_mbox_buffer[24] = 0;

    fb_mbox_buffer[25] = MBOX_TAG_GETFB;
    fb_mbox_buffer[26] = 8; // 2 words, bytes each
    fb_mbox_buffer[27] = 8; // Request code
    fb_mbox_buffer[28] = 4096;
    fb_mbox_buffer[29] = 0;

    fb_mbox_buffer[30] = MBOX_TAG_GETPITCH;
    fb_mbox_buffer[31] = 4;
    fb_mbox_buffer[32] = 4;

    fb_mbox_buffer[33] = 0;
    fb_mbox_buffer[34] = MBOX_TAG_LAST;

    if (mailbox_call(MBOX_CH_PROP, fb_mbox_buffer) == 0 && fb_mbox_buffer[20] == 32 && fb_mbox_buffer[28] != 0) {
        fb_mbox_buffer[28] = fb_mbox_buffer[28] & 0x3FFFFFFF;

        vbuffer.address = (fb_ptr_t)((unsigned long)fb_mbox_buffer[28]);
        vbuffer.width = fb_mbox_buffer[10];
        vbuffer.height = fb_mbox_buffer[11];
        vbuffer.pitch = fb_mbox_buffer[33];
    }

    return &vbuffer;
}