= Notes about embedded system development

== Building old versions of U-Boot 

U-Boot can be kind of particular about which versions of GCC you ard building it with.

Ubuntu 17.04 and later have GCC 6 available for ARM

When there are many versions of GCC installed, the naming can sort of get painful.  For most
builds you can specify "CROSS_COMPILE=arm-linux-gnueabi-", but this did not work once the
binary was named arm-linux-gnueabi-gcc-4.9 (cause it has the tool version number at the end).
In this case, I had to spell out to make which CC, AR, etc tool to use.

=== Building U-Boot 2010

Was working on building U-Boot for versatile platform (so I can emulate it on QEMU)

make ARCH=arm CC=arm-linux-gnueabi-gcc-2.9 versatile_config
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- CC=arm-linux-gnueabi-gcc-4.9 AR=arm-linux-gnueabi-gcc-ar-4.9

Had to specify generic cross compile prefix for other GNU binutils like objdump.  On a different machine,
the GCC 4.9 package did not come with ar-4.9, and I was able to use a different version for that tool as
well.

=== Building the Linux Kernel

make arch=arm CROSS_COMPILE=arm-linux-gnueabi- versatile_defconfig
make uImage LOADADDR=0x00210000

Also trying to create my own uImage that uses the uncompressed kernel

mkimage -A arm -O linux -T kernel -C none -a 00500000 -e 00500000 -n Linux -d Image uImageCustom

== Debugging

Run gdbserver on target, or if emulating target, have QEMU host GDB for you.

In QEMU, start GDB by doing the following, from withing QEMU

 Ctrl-A C     # Brings up QEMU console
 gdbserver    # By default, starts GDB on port 1234

In another shell, connect to it from gdb

 gdb-multiarch
 set architecture arm
 target remote 127.0.0.1:1234

