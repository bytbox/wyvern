char d = 'r';
char h = 'H';
void kmain() {
	unsigned char *videoram = (unsigned char *)0xb8000;
	videoram[0]=h;
	int loc = (int)&h;
	videoram[2]=loc;
	char out[12];
	int i;
	for (i=0; i<12; i++) {
		int x = loc%8;
		out[i] = '0'+x;
		loc /= 8;
	}

	for (i=0; i<12; i++)
		videoram[i*2] = out[i];
}

