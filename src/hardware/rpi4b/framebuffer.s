.type mailbox_buffer, %object
.global mailbox_buffer

.global framebuffer_init
.type framebuffer_init, %function

.equ MBOX_REQUEST_CODE, 0x0

.equ MBOX_TAG_SETPHYWH,  0x00048003 // Set physical width/height
.equ MBOX_TAG_SETVIRTWH, 0x00048004 // Set virtual width/height
.equ MBOX_TAG_SETDEPTH,  0x00048005 // Set depth (bits per pixel)
.equ MBOX_TAG_ALLOCBUF,  0x00040001 // Allocate framebuffer
.equ MBOX_TAG_GETPITCH,  0x00040008 // Get pitch (bytes per line)
.equ MBOX_TAG_LAST,      0x00000000 // End tag

/* Executable instructions. */
.section .text
.balign 4       // Instructions are 4-byte aligned.

/**
 * ============================================================
 * Subroutine: framebuffer_init
 * Description: Initializes the framebuffer.
 *
 * Inputs:
 *   W0 - screen width.
 *   W1 - screen height.
 *   W2 - depth.
 * 
 * Results:
 *   W0 - Just zero.
 * ============================================================
 */
framebuffer_init:
    STP     X29, X30, [SP, #-32]!
    MOV     X29, SP

    ADRP    X9, mailbox_buffer
    ADD     X9, X9, :lo12:mailbox_buffer

    MOVZ    W10, #(35 * 4)                      // Lower 32 bits => Index 0
    MOVK    X10, #MBOX_REQUEST_CODE, LSL #32    // Upper 32 bits => Index 1
    MOVZ    W11, #(2 * 4)                               // Lower 32 bits => Index 2
    MOVK    X11, #(MBOX_TAG_SETPHYWH | 0xFFFF), LSL #32 // Upper 32 bits => Index 3
    MOVK    X11, #(MBOX_TAG_SETPHYWH >> 16), LSL #48
    STP     X10, X11, [X9]

    MOV     W10, WZR          // Lower 32 bits => Index 4
    MOVK    X10, X0, LSL #32  // Upper 32 bits => Index 5
    MOVZ    W11, W1                                      // Lower 32 bits => Index 6
    MOVK    X11, #(MBOX_TAG_SETVIRTWH | 0xFFFF), LSL #32 // Upper 32 bits => Index 7
    MOVK    X11, #(MBOX_TAG_SETVIRTWH >> 16), LSL #48
    STP     X10, X11, [X9, #16]

    MOVZ    W10, #(1 * 4)     // Lower 32 bits => Index 8
    MOVK    X10, XZR, LSL #32 // Upper 32 bits => Index 9
    MOVZ    W11, W0           // Lower 32 bits => Index 10
    MOVK    X11, X1, LSL #32  // Upper 32 bits => Index 11
    STP     X10, X11, [X9, #32]

    MOVZ    X10, #(MBOX_TAG_SETDEPTH | 0xFFFF)        // Lower 32 bits => Index 12
    MOVK    X10, #(MBOX_TAG_SETPHYWH >> 16), LSL #16
    MOVK    X10, 1 * 4, LSL #32                       // Upper 32 bits => Index 13
    MOVZ    W11, WZR                                  // Lower 32 bits => Index 14
    MOVK    X11, X2, LSL #32                          // Upper 32 bits => Index 15
    STP     X10, X11, [X9, #48]

    MOVZ    X10, #(MBOX_TAG_ALLOCBUF | 0xFFFF)        // Lower 32 bits => Index 16
    MOVK    X10, #(MBOX_TAG_ALLOCBUF >> 16), LSL #16
    MOVK    X10, #8, LSL #32                          // Upper 32 bits => Index 17
    MOVZ    W11, WZR                                  // Lower 32 bits => Index 18
    MOVK    X11, #16, LSL #32                         // Upper 32 bits => Index 19
    MOVK    X11, #(MBOX_TAG_SETPHYWH >> 16), LSL #48
    STP     X10, X11, [X9, #64]

    MOVZ    X10, #(35 * 4)                      // Lower 32 bits => Index 20
    MOVK    X10, #MBOX_REQUEST_CODE, LSL #32    // Upper 32 bits => Index 21
    MOVZ    X11, #(2 * 4)                               // Lower 32 bits => Index 22
    MOVK    X11, #(MBOX_TAG_SETPHYWH | 0xFFFF), LSL #32 // Upper 32 bits => Index 23
    MOVK    X11, #(MBOX_TAG_SETPHYWH >> 16), LSL #48
    STP     X10, X11, [X9, #80]

    MOVZ    X10, #(35 * 4)                      // Lower 32 bits => Index 24
    MOVK    X10, #MBOX_REQUEST_CODE, LSL #32    // Upper 32 bits => Index 25
    MOVZ    X11, #(2 * 4)                               // Lower 32 bits => Index 26
    MOVK    X11, #(MBOX_TAG_SETPHYWH | 0xFFFF), LSL #32 // Upper 32 bits => Index 27
    MOVK    X11, #(MBOX_TAG_SETPHYWH >> 16), LSL #48
    STP     X10, X11, [X9, #96]

    MOVZ    W10, #4096                             // Lower 32 bits => Index 28
    // ZERO                                          // Upper 32 bits => Index 29
    MOVK    X11, #(MBOX_TAG_SETPHYWH | 0xFFFF)       // Upper 32 bits => Index 30
    MOVK    X11, #(MBOX_TAG_SETPHYWH >> 16), LSL #16
    MOVK    X11, #4, LSL #32                         // Upper 32 bits => Index 31
    STP     X10, X11, [X9, #112]

    MOVZ    X10, #4           // Lower 32 bits => Index 32
    // Zero! #MBOX_TAG_LAST,  // Upper 32 bits => Index 33
    MOV     X11, XZR          // Index 34, 35 zeroed out.
    STP     X10, X11, [X9, #128]

    MOV     SP, X29
    LDP     X29, X30, [SP], #32

    RET

/* Uninitialized data segment. */
.section .bss

.balign 16      // Mailbox buffers should be 16-byte aligned.
.size mailbox_buffer, 144
mailbox_buffer:
.zero 144

