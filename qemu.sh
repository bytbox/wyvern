#!/bin/sh

# Set up the floppy
dd if=/dev/zero of=pad bs=1 count=750 > /dev/null 2> /dev/null
cp tools/grub/boot/grub/stage1 .
cp tools/grub/boot/grub/stage2 .
cat stage1 stage2 pad wyvern.img > floppy.img 

rm pad stage1 stage2

qemu -fda floppy.img

