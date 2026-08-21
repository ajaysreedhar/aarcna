add_link_options(
    -nostdlib
    -ffreestanding
    -static
)

xadd_system_object(rpi4b hardware/rpi4b)
xadd_system_object(init0 _init_)
xadd_system_object(kernel kernel)
