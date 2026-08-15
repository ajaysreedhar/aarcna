# TODO : Set linker script after parsing the linker template.
set(_linker_script "${CMAKE_SOURCE_DIR}/scripts/init0-static.ld.in")

get_property(AARC_SYSTEM_OBJECTS GLOBAL PROPERTY AARC_SYSTEM_OBJECTS)

SET(system_targets "")
foreach(obj_name ${AARC_SYSTEM_OBJECTS})
    list(APPEND system_targets $<TARGET_OBJECTS:${obj_name}>)
endforeach()

add_executable(kernel8 ${system_targets})

set_target_properties(kernel8 PROPERTIES 
    SUFFIX ".elf"
    LINK_DEPENDS ${_linker_script})

target_link_options(kernel8 PRIVATE -T "${_linker_script}" -nostdlib)

add_custom_command(TARGET kernel8 POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary
            $<TARGET_FILE:kernel8>
            ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/kernel8.img
    COMMENT "Generating dist/kernel8.img")
    