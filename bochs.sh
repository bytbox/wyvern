#!/bin/sh

# Set up the floppy
dd if=/dev/zero of=pad bs=1 count=750 > /dev/null 2> /dev/null
cp tools/grub/boot/grub/stage1 .
cp tools/grub/boot/grub/stage2 .
cat stage1 stage2 pad wyvern-0.0.1.img > floppy.img 

# Get the kernel onto the floppy
#mkdir -p /tmp/mnt
#sudo losetup /dev/loop0 floppy.img
#sudo mount /dev/loop0 /tmp/mnt
#sudo cp wyvern-0.0.1.img /tmp/mnt/kernel
#sudo umount /dev/loop0
#sudo losetup -d /dev/loop0 

#sudo /sbin/losetup /dev/loop0 floppy.img
#sudo bochs -f bochsrc.txt
#sudo /sbin/losetup -d /dev/loop0 

rm pad stage1 stage2

