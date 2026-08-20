.ifndef _MAILBOX_INC_S_

.equ MBOX_CH_POWER, 0
.equ MBOX_CH_FBUFF, 1
.equ MBOX_CH_VUART, 2
.equ MBOX_CH_VCHIQ, 3
.equ MBOX_CH_LEDS,  4
.equ MBOX_CH_BTNS,  5
.equ MBOX_CH_TOUCH, 6
.equ MBOX_CH_COUNT, 7
.equ MBOX_CH_PROP,  8

.equ MBOX_REQUEST_CODE, 0x0

.equ MBOX_TAG_ALLOCBUF,   0x40001 // Allocate framebuffer
.equ MBOX_TAG_GETPITCH,   0x40008 // Get pitch (bytes per line)
.equ MBOX_TAG_SETPHYWH,   0x48003 // Set physical width/height
.equ MBOX_TAG_SETVIRTWH,  0x48004 // Set virtual width/height
.equ MBOX_TAG_SETDEPTH,   0x48005 // Set depth (bits per pixel)
.equ MBOX_TAG_SETPXLORDR, 0x48006
.equ MBOX_TAG_SETVIRTOFF, 0x48009
.equ MBOX_TAG_LAST,       0x00000 // End tag

.endif
