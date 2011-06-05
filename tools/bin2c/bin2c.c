#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
	if (argc != 3) {
		printf("usage: %s BINFILE CFILE\n", argv[0]);
	}

	int i;
	char *varname = malloc(strlen(argv[1])+1);
	for (i=0; i<strlen(argv[1]); i++) {

	}

	FILE *fin = fopen(argv[1], "rb");
	FILE *fout = fopen(argv[2], "w");

	fclose(fin);
	fclose(fout);

	return 0;
}

