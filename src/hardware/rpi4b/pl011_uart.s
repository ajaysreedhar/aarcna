.include "bcm2711.inc"

.section .text

.global uart0_init
.global uart0_write
.global uart0_close

uart0_init:
    STP     X29, X30, [SP, #-16]!
    MOV     X29, SP

    // Read the current value of function select for pins.
    LDR     X9, =GPIO_FUNC_SEL1_REG
    LDR     W10, [X9] // MMIO read.

    // Create a reset mask for pins 14 and 15.
    // Each pin starting from 10 uses 3 bits.
    // Therefore bit positions [14, 13, 12] are for pin 14 and
    // positions [17, 16, 15] are for pin 15.
    // Clear the bits for pin 14 and 15.
    // Inverting the mask as ~mask flips 0s to 1s and 1s to 0s.
    // Performing bitwise AND on the current value with an
    // inverted mask clears the function bits for the pins 14 and 15
    // and leaves bit values of other pins untouched.
    MOV     W11, 0x3F
    BIC     W10, W10, W11, LSL #12     // Bit clear. W10 = W10 & ~(3F << 12)

    // Overwrite the mask with the new values for setting alternate funcion
    // of pins 14 and 15 to UART0. UART0 uses the alternate function 0.
    // The bit value for enabling ALT_FN0 is 0b100 which translates to 4.
    MOVZ    W11, #0x4000        // 0x24000 = (4 << 12) | (4 << 15)
    MOVK    W11, 0x2, LSL #16
    ORR     W10, W10, W11       // Bit enable. W10 = W10 | W11

    // Update the current value with the new mask.
    STR     W10, [X9]   // MMIO write.

    // Disable pull up or pull down on the UART0 pins.
    // Bit positions [31, 30] are for GPIO pin 15 and
    // [29, 28] are for GPIO pin 14.
    // Setting these bit positions to 0 disables resistors.
    LDR     X9, =GPIO_PULL_CTRL0_REG
    LDR     W10, [X9]       // MMIO read.

    MOVZ    W11, 0xF000, LSL #16    // 0xF0000000 = (3 << 28) | (3 << 30)
    BIC     W10, W10, W11
    STR     W10, [X9]               // MMIO write.

    // Turn off UART0 before making changes.
    LDR     X9, =UART0_CTRL_REG
    STR     WZR, [X9]   // MMIO write.

    // Wait for busy flag in UART0_FLAG_REG to clear.
    // Busy bit is at position 3 and 8 in binary is 0b1000.
    LDR     X9, =UART0_FLAG_REG
1:  LDR     W10, [X9]   // MMIO read.
    TBNZ    W10, #3, 1b
    
    // Clear pending interrupts.
    LDR     X9, =UART0_ICL_REG
    MOV     W10, #0x7FF
    STR     W10, [X9]   // MMIO write.

    // Set the integer and fractional bits of baud rate.
    // Desired baud rate is 115200.
    //
    // Baud rate divisor = UART0_CLOCK_FREQ / (16 * baud_rate)
    //
    // Using the above formula:
    //     48000000 / (16 * 115200) = 26.0416666
    //
    // Multiply fractional part by 64:
    //     0.416666 * 64 = 3 (approx)
    LDR     X9, =UART0_IBRD_REG
    MOV     W10, #26
    STR     W10, [X9]   // MMIO write.
    LDR     X9, =UART0_FBRD_REG
    MOV     W10, #3
    STR     W10, [X9]   // MMIO write.

    // Enable 8-bit mode.
    LDR     X9, =UART0_LCRH_REG
    MOV     W10, #0x70  // 0x70 = (1 << 4) | (3 << 5)
    STR     W10, [X9]   // MMIO write.

    // Enable UART0, RX and TX.
    LDR     X9, =UART0_CTRL_REG
    MOV     W10, #0x301 // 0x301 = (1 << 8) | (1 << 9) | 1
    STR     W10, [X9]   // MMIO write.

    MOV     SP, X29
    LDP     X29, X30, [SP], #16
    RET

/**
 * ============================================================
 * Subroutine: uart0_write
 * Description: Writes a stream of characters to the UART0 interface.
 *
 * Inputs:
 *   X0 - Memory address to the character stream.
 * 
 * Results:
 *   Void
 * ============================================================
 */
uart0_write:
    STP     X29, X30, [SP, #-32]!
    MOV     X29, SP

    STP     X19, X20, [X29, #16]    // Save the callee-saved registers and use them.
    MOV     X19, X0                 // Copy current char-index in string.
    
1:  LDRB    W0, [X19], #1   // Read string one char at a time to W0.
    CBZ     W0, 3f          // If null-terminator, exit loop.

    CMP     W0, #0x0A       // Check if number is a newline character.
    B.NE    2f              // Skip forward to label 2 if not a newline character.

    // If the current value is a newline character, write carriage-return.
    MOV     W20, W0     // Save current value to W20.
    MOV     W0, #0x0D   // Load W0 with carriage-return as argument to uart0_putc.
    BL      uart0_putc
    MOV     W0, W20     // Restore previous character from W20 to W0.

2:  BL      uart0_putc
    B       1b

// Subroutine epilogue.
3:  LDP     X19, X20, [X29, #16]
    MOV     SP, X29
    LDP     X29, X30, [SP], #32
    RET

/**
 * ============================================================
 * Subroutine: uart0_putc
 * Description: Writes a character to the UART0 interface.
 *
 * Inputs:
 *   W0 - The character to be written.
 * 
 * Results:
 *   Void
 * ============================================================
 */
uart0_putc:
    LDR     X9, =UART0_FLAG_REG

1:  LDR     W10, [X9] // MMIO read.
    TBNZ    W10, #5, 1b

    LDR     X9, =UART0_DATA_REG
    STR     W0, [X9] // MMIO write.

    RET

/**
 * ============================================================
 * Subroutine: uart0_close
 * Description: Flushes the data and closes the interface.
 * ============================================================
 */
uart0_close:
    LDR     X9, =UART0_FLAG_REG
    
1:  LDR     W10, [X9] // MMIO read.
    TBNZ    W10, #3, 1b

    LDR     X9, =UART0_CTRL_REG
    STR     WZR, [X9] // MMIO write zeros.

    RET
