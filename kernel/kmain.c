volatile unsigned char *videoram = (volatile unsigned char *)0xb8000;
void kmain() {
	videoram[0]='H';
}

