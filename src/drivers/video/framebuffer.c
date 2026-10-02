#include <hardware/bcm2711.h>

#define MBOX_BUFFER_SIZE 36

enum {
    MBOX_REQUEST_CODE = 0x0,
    MBOX_TAG_SETPHYWH = 0x00048003,  // Set physical width/height
    MBOX_TAG_SETVIRTWH = 0x00048004, // Set virtual width/height
    MBOX_TAG_SETDEPTH = 0x00048005,  // Set depth (bits per pixel)
    MBOX_TAG_ALLOCBUF = 0x00040001,  // Allocate framebuffer
    MBOX_TAG_GETPITCH = 0x00040008,  // Get pitch (bytes per line)
    MBOX_TAG_LAST = 0x00000000       // End tag
};

// MBOX_BUFFER_SIZE = 36
volatile unsigned int __attribute__((aligned(16))) fb_mbox_buffer[MBOX_BUFFER_SIZE];

int framebuffer_init(unsigned int width, unsigned int height, unsigned int depth) {

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
    fb_mbox_buffer[8] = 1 * 4; // 1 word, 4 bytes
    fb_mbox_buffer[9] = 0;     // Request code
    fb_mbox_buffer[10] = width;
    fb_mbox_buffer[11] = height;

    // Tag: Setting depth.
    fb_mbox_buffer[12] = MBOX_TAG_SETDEPTH;
    fb_mbox_buffer[13] = 1 * 4; // 1 word, 1 byte
    fb_mbox_buffer[14] = 0;     // Request code
    fb_mbox_buffer[15] = depth;

    // Tag: Allocate framebuffer.
    fb_mbox_buffer[16] = MBOX_TAG_ALLOCBUF;
    fb_mbox_buffer[17] = 8;  // Alignment + size
    fb_mbox_buffer[18] = 0;  // Request code
    fb_mbox_buffer[19] = 16; // Alignment
    fb_mbox_buffer[20] = 0;  // Response- framebuffer base address

    // Tag: Get pitch.
    fb_mbox_buffer[21] = MBOX_TAG_GETPITCH;
    fb_mbox_buffer[22] = 4; // 2 words, bytes each
    fb_mbox_buffer[23] = 0; // Request code
    fb_mbox_buffer[24] = 0;

    // End tag.
    fb_mbox_buffer[25] = MBOX_TAG_LAST;
}