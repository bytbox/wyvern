#include "kio.h"
#include "types.h"

volatile unsigned char *videoram = (volatile unsigned char *)0xb8000;

void kio_init() {
	int x, y;
	for (x=0; x<80; x++) {
		for (y=0; y<20; y++) {
			videoram[x*2+y*160] = 0x00;
			videoram[x*2+y*160+1] = 0x1F;
		}
	}
}

void kdraw(uint8_t x, uint8_t y, char *str, uint8_t mask) {
	char *c = str;
	while (*c != '\0') {
		videoram[(y*160) + (c-str+x)*2] = *c;
		videoram[(y*160) + (c-str+x)*2 + 1] = mask;
		c++;
	}
	return;
}

int _kwrite_line = 20;
void kwrite(char *str) {
	char *c = str;
	while (*c != '\0') {
		videoram[(_kwrite_line*160) + (c-str) * 2] = *c;
		videoram[(_kwrite_line*160) + (c-str) * 2 + 1] = 0x0F;
		c++;
	}
	_kwrite_line++;
	if (_kwrite_line >= 25) _kwrite_line = 20;
	return;
}

char *putstr = "   ";
void kput(char c) {
	putstr[2] = c;
	kwrite(putstr);
}

