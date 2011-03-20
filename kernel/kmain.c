volatile unsigned char *videoram = (unsigned char *)0xb8000;

void kmain() {
	videoram[0]='A';
}

