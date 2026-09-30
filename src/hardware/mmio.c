#include <hardware/bcm2711.h>

void mmio_write(mmio_reg_t addr, unsigned int value) {
    // Write value to address.
    *addr = value;
}

unsigned int mmio_read(mmio_reg_t addr) {
    // Read value from address.
    return *addr;
}