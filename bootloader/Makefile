all: wl.img

clean:
	rm -f wl.img

wl.img: wl.asm
	nasm -f bin -o wl.img wl.asm
