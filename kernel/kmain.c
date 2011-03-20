volatile unsigned char *videoram = 0xb8000;

void kmain() {
	videoram[0]='A';
}

