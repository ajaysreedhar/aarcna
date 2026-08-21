.include "mailbox.inc.s"

.type frame_buffer, %object
.global frame_buffer

.type mailbox_buffer, %object
.global mailbox_buffer

.global framebuffer_init
.type framebuffer_init, %function

.extern mailbox_call

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
 *   X0 - The framebuffer struct address.
 * ============================================================
 */
framebuffer_init:
    STP     X29, X30, [SP, #-32]!
    MOV     X29, SP

    ADRP    X9, mailbox_buffer
    ADD     X9, X9, :lo12:mailbox_buffer

    STR     X9, [SP, #16] // Store the mailbox_buffer address.

    MOVZ    W10, #(35 * 4)                      // Lower 32 bits => Index 0
    MOVK    X10, #MBOX_REQUEST_CODE, LSL #32    // Upper 32 bits => Index 1
    MOVZ    W11, #(MBOX_TAG_SETPHYWH & 0xFFFF)        // Lower 32 bits => Index 2
    MOVK    W11, #(MBOX_TAG_SETPHYWH >> 16), LSL #16
    MOVK    X11, #8, LSL #32                          // Upper 32 bits => Index 3
    STP     X10, X11, [X9]

    MOV     W10, WZR          // Lower 32 bits => Index 4
    BFI     X10, X0, #32, #32 // Upper 32 bits => Index 5
    MOV     W11, W1                                      // Lower 32 bits => Index 6
    MOVK    X11, #(MBOX_TAG_SETVIRTWH & 0xFFFF), LSL #32 // Upper 32 bits => Index 7
    MOVK    X11, #(MBOX_TAG_SETVIRTWH >> 16), LSL #48
    STP     X10, X11, [X9, #16]

    MOVZ    W10, #8             // Lower 32 bits => Index 8
    MOVK    X10, #8, LSL #32    // Upper 32 bits => Index 9
    MOV     W11, W0             // Lower 32 bits => Index 10
    BFI     X11, X1, #32, #32   // Upper 32 bits => Index 11
    STP     X10, X11, [X9, #32]

    MOVZ    W10, #(MBOX_TAG_SETVIRTOFF & 0xFFFF)       // Lower 32 bits => Index 12
    MOVK    X10, #(MBOX_TAG_SETVIRTOFF >> 16), LSL #16
    MOVK    X10, #8, LSL #32                           // Upper 32 bits => Index 13
    MOVZ    W11, #8                                    // Lower 32 bits => Index 14
    // Zero                                               Upper 32 bits => Index 15
    STP     X10, X11, [X9, #48]

    MOV     W10, WZR                                   // Lower 32 bits => Index 16
    MOVK    X10, #(MBOX_TAG_SETDEPTH & 0xFFFF), LSL 32 // Upper 32 bits => Index 17
    MOVK    X10, #(MBOX_TAG_SETDEPTH >> 16), LSL #48
    MOVZ    W11, #4                                    // Lower 32 bits => Index 18
    MOVK    X11, #4, LSL #32                           // Upper 32 bits => Index 19
    STP     X10, X11, [X9, #64]

    MOVZ    W10, #32                                      // Lower 32 bits => Index 20
    MOVK    X10, #(MBOX_TAG_SETPXLORDR & 0xFFFF), LSL #32 // Upper 32 bits => Index 21
    MOVK    X10, #(MBOX_TAG_SETPXLORDR >> 16), LSL #48
    MOVZ    W11, #4             // Lower 32 bits => Index 22
    MOVK    X11, #4, LSL #32    // Upper 32 bits => Index 23
    STP     X10, X11, [X9, #80]

    MOV     W10, WZR                                    // Lower 32 bits => Index 24
    MOVK    X10, #(MBOX_TAG_ALLOCBUF & 0xFFFF), LSL #32 // Upper 32 bits => Index 25
    MOVK    X10, #(MBOX_TAG_ALLOCBUF >> 16), LSL #48
    MOVZ    W11, #8           // Lower 32 bits => Index 26
    MOVK    X11, #8, LSL #32  // Upper 32 bits => Index 27
    STP     X10, X11, [X9, #96]

    MOVZ    X10, #4096                             // Lower 32 bits => Index 28
    // ZERO                                          // Upper 32 bits => Index 29
    MOVZ    W11, #(MBOX_TAG_GETPITCH & 0xFFFF)       // Lower 32 bits => Index 30
    MOVK    W11, #(MBOX_TAG_GETPITCH >> 16), LSL #16
    MOVK    X11, #4, LSL #32                         // Upper 32 bits => Index 31
    STP     X10, X11, [X9, #112]

    MOVZ    W10, #4           // Lower 32 bits => Index 32
    // Zero! #MBOX_TAG_LAST,  // Upper 32 bits => Index 33
    MOV     X11, XZR          // Index 34, 35 zeroed out.
    STP     X10, X11, [X9, #128]

    MOV     W0, #MBOX_CH_PROPS
    MOV     X1, X9
    BL      mailbox_call
    CBZ     W0, 1f

    LDR     X9, [SP, #16] // Load the mailbox_buffer address.

    MOVZ    W10, #32
    LDR     W11, [X9, #80] // mailbox_buffer[20]
    CMP     W10, W11
    BNE     1f

    LDR     W11, [X9, #112] // mailbox_buffer[28]
    CBZ     W11, 1f

    /* To convert GPU address to ARM address, AND with 0x3FFFFFFF */
    MOV     X10, XZR
    MVN     W10, WZR
    BFC     W10, #30, #2
    AND     X1, X10, X11
    STR     X1, [X9, #112] // mailbox_buffer[28]

    ADRP    X0, frame_buffer
    ADD     X0, X0, :lo12:frame_buffer

    STR     X1, [X0]

    LDR     W10, [X9, #40]  // mailbox_buffer[10]
    ORR     X11, XZR, X10

    LDR     W10, [X9, #44]  // mailbox_buffer[11]
    ORR     X11, X11, X10, LSL #32

    LDR     W10, [X9, #132] // mailbox_buffer[33]
    ORR     X12, XZR, X10

    LDR     W10, [X9, #96]  // mailbox_buffer[24]
    ORR     X12, X12, X10, LSL #32

    STP     X11, X12, [X0, #8]

1:  MOV     SP, X29
    LDP     X29, X30, [SP], #32

    RET

/* Uninitialized data segment. */
.section .bss

/* Mailbox buffer array. */
.balign 16
.size mailbox_buffer, 144
mailbox_buffer:
.zero 144

/* Frame buffer properties struct. */
.balign 8
.size frame_buffer, 16
frame_buffer:
.zero 16
