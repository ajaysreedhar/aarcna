# What is this?

Aarcna is an attempt to build a minimal yet functional operating system for AArch64-based processors.

The goal here is to experiment and learn rather than building another operating system.

## :computer: Supported Hardware

Currently the builds are exclusively for **Raspberry Pi 4b** computers. In the future, more platforms might be supported.

## :building_construction: Compiling and Building

To compile the project, the **ARM cross-compiler** toolchain is required.

The toolchain can be downloaded from the official [ARM developers](https://developer.arm.com/tools-and-software/gnu-toolchain) website.

After extracting the archive, update the `set(ARM_TC_PATH /opt/arm-toolchain-elf64)` line in CMakeLists.txt file to point to the toolchain location.

```bash
$ cmake -S . -B build
$ cmake --build build
```

The binaries will be placed to `dist/` directory.

## :bug: Testing and Debugging

Before running on a real hardware, the builds can be tested with QEMU.

```bash
$ sudo apt install qemu-system-arm
$ qemu-system-aarch64 -M raspi4b -nographic -kernel dist/kernel8.img -s -S
```

The `-s -S` flag starts loads the kernel but halts the virtual CPU until a debugger is connected.

In this case, the debugger provided in the ARM toolchain is handy.

```bash
$ aarch64-none-elf-gdb dist/kernel8.elf
(gdb) target remote localhost:1234
(gdb) layout asm
(gdb) layout regs
```

Once the debugger is connected, issue `stepi` command to execute instructions.