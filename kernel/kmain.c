char h = 'H';
void kmain() {
	unsigned char *videoram = (unsigned char *)0xb8000;
	videoram[0]=h;
	videoram[2]='i';
}

