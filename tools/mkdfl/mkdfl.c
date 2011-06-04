/*
 * DFL Generator
 */

#include <stdio.h>

int main(int argc, char *argv[]) {
	if (argc != 3) {
		printf("usage: %s DIR IMG\n", argv[0]);
		return 0;
	}

	char *dirname = argv[1];
	char *imgname = argv[2];

	return 0;
}

