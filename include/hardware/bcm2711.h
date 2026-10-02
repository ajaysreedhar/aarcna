#ifndef __HARDWARE_BCM2711_H__
#define __HARDWARE_BCM2711_H__ 1

#define ARM_PERIPHERAL_BASE 0xFE000000

enum gpio {
    GPIO_BASE = ARM_PERIPHERAL_BASE + 0x200000,
    GPIO_FUNC_SEL0_REG = GPIO_BASE,         // Function select for pins 1 - 10
    GPIO_FUNC_SEL1_REG = GPIO_BASE + 0x4,   // Function select for pins 10 - 19
    GPIO_FUNC_SEL2_REG = GPIO_BASE + 0x8,   // Function select for pins 20 - 29
    GPIO_FUNC_SEL3_REG = GPIO_BASE + 0xc,   // Function select for pins 30 - 39
    GPIO_FUNC_SEL4_REG = GPIO_BASE + 0x10,  // Function select for pins 40 - 49
    GPIO_FUNC_SEL5_REG = GPIO_BASE + 0x14,  // Function select for pins from 50
    GPIO_PULL_CTRL0_REG = GPIO_BASE + 0xe4, // Pull up/down control register 0
    GPIO_PULL_CTRL1_REG = GPIO_BASE + 0xe8, // Pull up/down control register 0
    GPIO_PULL_CTRL2_REG = GPIO_BASE + 0xec, // Pull up/down control register 0
    GPIO_PULL_CTRL3_REG = GPIO_BASE + 0xf0, // Pull up/down control register 0
};

enum uart_0 {
    UART0_CLOCK_FREQ = 48000000, // Clock frequency is 48 MHz
    UART0_BASE_ADDR = ARM_PERIPHERAL_BASE + 0x201000,
    UART0_DATA_REG = UART0_BASE_ADDR + 0x0,
    UART0_RSEC_REG = UART0_BASE_ADDR + 0x4,
    UART0_FLAG_REG = UART0_BASE_ADDR + 0x18,
    UART0_IBRD_REG = UART0_BASE_ADDR + 0x24,
    UART0_FBRD_REG = UART0_BASE_ADDR + 0x28,
    UART0_LCRH_REG = UART0_BASE_ADDR + 0x2c,
    UART0_CTRL_REG = UART0_BASE_ADDR + 0x30,
    UART0_IFLS_REG = UART0_BASE_ADDR + 0x34,
    UART0_IMSC_REG = UART0_BASE_ADDR + 0x38,
    UART0_RIS_REG = UART0_BASE_ADDR + 0x3c,
    UART0_MIS_REG = UART0_BASE_ADDR + 0x40,
    UART0_ICL_REG = UART0_BASE_ADDR + 0x44,
    UART0_DMAC_REG = UART0_BASE_ADDR + 0x48,
    UART0_ITC_REG = UART0_BASE_ADDR + 0x80,
    UART0_ITIP_REG = UART0_BASE_ADDR + 0x84,
    UART0_ITOP_REG = UART0_BASE_ADDR + 0x88,
    UART0_TDATA_REG = UART0_BASE_ADDR + 0x8c,
};

typedef volatile unsigned long mmio_reg_t;
typedef volatile unsigned int* mmio_ptr_t;

void mmio_write(mmio_reg_t addr, unsigned int value);
unsigned int mmio_read(mmio_reg_t addr);

#endif // #ifndef __HARDWARE_BCM2711_H__