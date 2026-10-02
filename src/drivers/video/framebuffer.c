#include "mailbox.h"

enum {
    MBOX_TAG_SETPHYWH = 0x00048003,  // Set physical width/height
    MBOX_TAG_SETVIRTWH = 0x00048004, // Set virtual width/height
    MBOX_TAG_SETDEPTH = 0x00048005,  // Set depth (bits per pixel)
    MBOX_TAG_ALLOCBUF = 0x00040001,  // Allocate framebuffer
    MBOX_TAG_GETPITCH = 0x00040008,  // Get pitch (bytes per line)
    MBOX_TAG_LAST = 0x00000000       // End tag
};

int framebuffer_init(unsigned int width, unsigned int height,
                     unsigned int depth) {

    mailbox_buffer[0] =
        35 * 4; // Size of the mailbox buffer - 35 words, 4 bytes each
    mailbox_buffer[1] = MBOX_REQUEST_CODE;

    // Tag: Setting physical width and height.
    mailbox_buffer[2] = MBOX_TAG_SETPHYWH;
    mailbox_buffer[3] = 2 * 4; // 2 words, 4 bytes each
    mailbox_buffer[4] = 0;     // Request code
    mailbox_buffer[5] = width;
    mailbox_buffer[6] = height;

    // Tag: Setting virtual width and height.
    mailbox_buffer[7] = MBOX_TAG_SETVIRTWH;
    mailbox_buffer[8] = 1 * 4; // 1 word, 4 bytes
    mailbox_buffer[9] = 0;     // Request code
    mailbox_buffer[10] = width;
    mailbox_buffer[11] = height;

    // Tag: Setting depth.
    mailbox_buffer[12] = MBOX_TAG_SETDEPTH;
    mailbox_buffer[13] = 1 * 4; // 1 word, 1 byte
    mailbox_buffer[14] = 0;     // Request code
    mailbox_buffer[15] = depth;

    // Tag: Allocate framebuffer.
    mailbox_buffer[16] = MBOX_TAG_ALLOCBUF;
    mailbox_buffer[17] = 8;  // Alignment + size
    mailbox_buffer[18] = 0;  // Request code
    mailbox_buffer[19] = 16; // Alignment
    mailbox_buffer[20] = 0;  // Response- framebuffer base address

    // Tag: Get pitch.
    mailbox_buffer[21] = MBOX_TAG_GETPITCH;
    mailbox_buffer[22] = 4; // 2 words, bytes each
    mailbox_buffer[23] = 0; // Request code
    mailbox_buffer[24] = 0;

    // End tag.
    mailbox_buffer[25] = MBOX_TAG_LAST;
}