add_link_options(
    -nostdlib
    -ffreestanding
    -static
)

xadd_system_object(hw_rpi4b hardware/bcm2711)

xadd_system_object(dv_uart  drivers/uart)
xadd_system_object(dv_video drivers/video)

xadd_system_object(stdlib stdlib)
xadd_system_object(shell  shell)

xadd_system_object(kernel kernel)
xadd_system_object(init0 _init_)
