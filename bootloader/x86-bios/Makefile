all: wl.img

clean:
	rm -f *.img *.bin

wl.img: stage1.bin stage2.bin dummy.bin
	cat stage1.bin stage2.bin dummy.bin > $@

stage1.bin: stage1.asm
	nasm -f bin -o $@ $<

stage2.bin: stage2.asm
	nasm -f bin -o $@ $<

dummy.bin: dummy.asm
	nasm -f bin -o $@ $<

