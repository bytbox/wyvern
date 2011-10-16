#include "kio.h"

volatile unsigned char *videoram = (volatile unsigned char *)0xb8000;

void kio_init() {
	int x, y;
	for (x=0; x<80; x++) {
		for (y=0; y<20; y++) {
			videoram[x*2+y*160] = 0;
		}
	}
}

int _kwrite_line = 0;
void kwrite(char *str) {
	char *c = str;
	while (*c != '\0') {
		videoram[(_kwrite_line*160) + (c-str) * 2] = *c;
		c++;
	}
	_kwrite_line++;
	return;
}

char *putstr = "   ";
void kput(char c) {
	putstr[2] = c;
	kwrite(putstr);
}

