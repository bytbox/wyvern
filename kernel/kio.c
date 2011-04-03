#include "kio.h"

volatile unsigned char *videoram = (volatile unsigned char *)0xb8000;

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

