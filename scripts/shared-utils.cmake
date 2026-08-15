# xadd_system_object(<name>)
#
# Turns every .c/.s file in the calling directory into an OBJECT
# library called <name>, and registers it in the global AARC_SYSTEM_OBJECTS
# list so the top-level build picks it up automatically.
function(xadd_system_object obj_name)
    file(GLOB_RECURSE obj_sources CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_SOURCE_DIR}/${obj_name}/*.c"
        "${CMAKE_CURRENT_SOURCE_DIR}/${obj_name}/*.s"
    )

    if(NOT obj_sources)
        message(FATAL_ERROR "Object '${obj_name}' has no source files in ${CMAKE_CURRENT_SOURCE_DIR}/${obj_name}")
    endif()

    add_library(${obj_name} OBJECT ${obj_sources})

    target_compile_options(${obj_name} PRIVATE 
        $<$<COMPILE_LANGUAGE:C>:-Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles>)

    target_include_directories(${obj_name} PUBLIC 
        ${CMAKE_CURRENT_SOURCE_DIR} 
        ${CMAKE_SOURCE_DIR}/src/include)

    set_property(GLOBAL APPEND PROPERTY AARC_SYSTEM_OBJECTS ${obj_name})
endfunction()
