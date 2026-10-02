#include "bcm2711.h"

void mmio_write(mmio_reg_t address, unsigned int value) {
    // Write value to address.
    *((mmio_ptr_t)address) = value;
}

unsigned int mmio_read(mmio_reg_t address) {
    // Read value from address.
    return *((mmio_ptr_t)address);
}