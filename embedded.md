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

This has 2 outputs.  Both will confusingly work OK with QEMU.  The file u-boot is an ELF.  I have no
idea how it is opened by QEMU, but it seems to be fine with running this file:

  qemu-system-arm -M versatilepb -m 128M -nographic -kernel u-boot

The second file is u-boot.bin, and this is what the processor would jump into directly at startup.
It gets loaded at address 0x00010000

  qemu-system-arm -M verstailepb -m 128M -nographic -kernel u-boot.bin
  md 0x00010000


=== Building the Linux Kernel

# Also some sites recommend building by setting these environment variables by themselves
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- versatile_defconfig
make uImage LOADADDR=0x00210000

Also trying to create my own uImage that uses the uncompressed kernel

mkimage -A arm -O linux -T kernel -C none -a 04008000 -e 04008000 -n Linux -d Image uImageCustom

== Building BusyBox / Root Filesystem ==

The best instructions I found so far were on https://github.com/surajx/qemu-arm-linux

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-
make defconfig
make menuconfig
 * Do stuff like make a staticly linked binary
make -j8 install
cd _install

# Create an init script
mkdir proc sys dev etc etc/init.d
echo "#!/bin/bash" > etc/init.d/rcS
echo "mount -t proc none /proc" >> etc/init.d/rcS
echo "mount -t sysfs none /sys" >> etc/init.d/rcS
chmod +x etc/init.d/rcS

# Now create the initrd / root file system
find . | cpio -o --format=newc > ../rootfs.img
cd ..
gzip -c rootfs.img > rootfs.img.gz

# For his Linux kernel, he compile Linux v3.10 with vexpress_defconfig configuration

# For QEMU
qemu-system-arm -M vexpress-a9 -m 256M -kernel linux-3.10/arch/arm/boot/zImage -initrd busybox-1.21.1/rootfs.img -append "root=/dev/ram rdinit=/sbin/init"

Note: Notice that one kernel parameter is rdinit, not initrd, yeah, I wasted a lot of time because of that dumb crap

== Running with QEMU 

Note: Having trouble getting some of these steps to work correctly

=== Stiching flash together

Make a script that will drop u-boot.bin at address 0x00000000 of a file, then drop Linux kernel at
some point after that.

qemu-system-arm -machine versatilepb -m 128M -kernel flashImageFile.bin -nographic

bootm 0x00210000

== Debugging

Run gdbserver on target, or if emulating target, have QEMU host GDB for you.

In QEMU, start GDB by doing the following, from withing QEMU

 Ctrl-A C     # Brings up QEMU console
 gdbserver    # By default, starts GDB on port 1234

In another shell, connect to it from gdb

 gdb-multiarch
 set architecture arm
 target remote 127.0.0.1:1234

=== Kernel paging issues ===

My kernel I compiled what not XIP (execute in place), and there is some code in there that wants
a particular offset for the kernel in RAM.  I think it needs to be at an offset of

 16MB * n + 0x8000

Where I think n can be any number.  But I had an issue where I used 0x01008000 and ran into an
issue where u-boot was clobbering itself.




