.type mailbox_buffer, %object
.global mailbox_buffer

.global framebuffer_init
.type framebuffer_init, %function

.equ MBOX_REQUEST_CODE, 0x0

.equ MBOX_TAG_SETPHYWH, 0x00048003,  // Set physical width/height
.equ MBOX_TAG_SETVIRTWH, 0x00048004, // Set virtual width/height
.equ MBOX_TAG_SETDEPTH, 0x00048005,  // Set depth (bits per pixel)
.equ MBOX_TAG_ALLOCBUF, 0x00040001,  // Allocate framebuffer
.equ MBOX_TAG_GETPITCH, 0x00040008,  // Get pitch (bytes per line)
.equ MBOX_TAG_LAST, 0x00000000       // End tag

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

    MOVZ    X10, #(35 * 4), LSL 32              // Index: 0
    MOVK    X10, #MBOX_REQUEST_CODE             // Index: 1
    MOVZ    X11, #:upper16:MBOX_TAG_SETPHYWH, LSL #48   // Index: 2:split 1
    MOVK    X11, #:lower16:MBOX_TAG_SETPHYWH, LSL #32   // Index: 2:split 2
    MOVK    X11, #(2 * 4)                       // Index: 3
    STP     X10, X11, [X9]

    MOV     SP, X29
    LDP     X29, X30, [SP], #32

    RET


/* Uninitialized data segment. */
.section .bss

.balign 16      // Mailbox buffers should be 16-byte aligned.
.size mailbox_buffer, 144
mailbox_buffer:
.zero 144

