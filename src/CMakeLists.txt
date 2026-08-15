add_link_options(
    -nostdlib
    -ffreestanding
    -static
)

xadd_system_object(init0)
xadd_system_object(kernel)
