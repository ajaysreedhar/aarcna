#ifndef __HARDWARE_DEVICETREE_H__
#define __HARDWARE_DEVICETREE_H__ 1

#include <stdint.h>

typedef struct {
    uint32_t magic_bytes;
    uint32_t total_size;
    uint32_t dt_struct_offset;
    uint32_t dt_string_offset;
    uint32_t mem_rsvmap_offset;
    uint32_t current_version;
    uint32_t compat_version;
    uint32_t boot_cpu_id;
    uint32_t dt_string_size;
    uint32_t dt_struct_size;
} fdt_header;

#endif