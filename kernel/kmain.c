void kmain() {
	unsigned char *videoram = (unsigned char *)0xb8000;
	videoram[0]='H';
	videoram[2]='i';
}

