cmake_minimum_required(VERSION 3.20)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(ARM_TC_PATH /opt/arm-toolchain-elf64)

set(CMAKE_C_COMPILER            ${ARM_TC_PATH}/bin/aarch64-none-elf-gcc)
set(CMAKE_C_STANDARD            11)
set(CMAKE_C_STANDARD_REQUIRED   ON)

set(CMAKE_ASM_COMPILER ${ARM_TC_PATH}/bin/aarch64-none-elf-as)
set(CMAKE_OBJCOPY      ${ARM_TC_PATH}/bin/aarch64-none-elf-objcopy CACHE FILEPATH "")
set(CMAKE_OBJDUMP      ${ARM_TC_PATH}/bin/aarch64-none-elf-objdump CACHE FILEPATH "")

set(CMAKE_TRY_COMPILE_TARGET_TYPE   STATIC_LIBRARY)

project(aarcna ASM C)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/dist")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/dist/lib")

set(HARDWARE "rpi4b" CACHE STRING "Target board (rpi4b, rpi3, orangepi_zero3, ...)")
set(hardware_file ${CMAKE_SOURCE_DIR}/scripts/hw-${HARDWARE}.cmake)

if(NOT EXISTS ${hardware_file})
    message(FATAL_ERROR "Unknown hardware '${HARDWARE}' — no ${hardware_file}")
endif()

include(scripts/shared-utils.cmake)

add_subdirectory(src)
include(${hardware_file})