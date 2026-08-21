.global paint_box
.type paint_box, %function


.section .text
.balign 4

/**
 * ============================================================
 * Subroutine: paint_box
 * Description: Paints a rectangular box on the screen.
 *
 * Memory address of the pixel on the framebuffer is calculated
 * with the formula:
 * 
 * address = base_add + (y * pitch) + (x * bytes_per_pixel)
 *
 * Inputs:
 *   X0 - The framebuffer struct address.
 *   W1 - X1 start coordinate.
 *   W2 - Y1 start coordinate.
 *   W3 - X2 end coordinate.
 *   W4 - Y2 end coordinate.
 *   W5 - ARGB colour hex code.
 * 
 * Results:
 *   Void.
 * ============================================================
 */
paint_box:
    LDR     X9, [X0]      // Load the framebuffer address.
    LDR     W6, [X0, #8]  // Loading horizontal pixel count.
    LDR     W7, [X0, #12] // Loading vertical pixel count.
    LDR     W8, [X0, #16] // Loading the pitch.

1:  MOV     W10, W1 // Current X coordinate index.
    
    /* Painting the pixel. */
2:  MADD    X15, X2, X8, X9        // X15 = (X2 * X8) + X9
    STR     W5, [X15, X10, LSL #2] // W5 => X15 + (X10 * 2^2)

    ADD     W10, W10, #1
    CMP     W10, W3
    BLE     2b

    ADD     W2, W2, #1
    CMP     W2, W4
    BLE     1b

3:  RET
