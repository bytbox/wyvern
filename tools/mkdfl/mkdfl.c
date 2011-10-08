/*
 * DFL ("Dumb Frame Layout") Generator
 * Copyright (c) 2011 Scott Lawrence <bytbox@gmail.com>
 */

/*
 * The DFL header starts with a 25-byte meta-header that has the following
 * information:
 *
 *   length    Description
 *      4      Magic Number + Flags
 *     20      Name of this volume
 *      1      Header size (in 512-byte hunks, not counting this one)
 *
 * There is then a zero'd gap until the next hunk, which begins the header
 * table. Each header is aligned to a 32-byte boundary, and consists of the
 * following components:
 *
 *  length     Description
 *     4       Frame address (in 512-byte hunks - the meta-header is 0)
 *     1       Flags
 *    20       Frame name
 *
 * All extra space should be zero'd.
 *
 */

#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

const short DFL_MAGIC = 0xfa1b;
const short DFL_FLAGS = 0x0000;

struct fileinfo {
	int size;
	char *name;
};

void seek512(FILE *);

int main(int argc, char *argv[]) {
	if (argc != 4) {
		printf("usage: %s DIR IMG NAME\n", argv[0]);
		return 0;
	}

	char *dirname = argv[1];
	char *imgname = argv[2];
	char *volname = argv[3];

	// fetch list of files, with meta-info
	DIR *dir = opendir(dirname);
	if (!dir) perror("mkdfl: could not read input directory"), exit(0);
	// count the number of files in this directory
	int filecount = 0;
	struct dirent *f;
	while ((f = readdir(dir)))
		if (f->d_type == DT_REG && f->d_name[0] != '.') filecount++;
	rewinddir(dir);
	// read in all file information
	struct fileinfo *files = malloc(sizeof(struct fileinfo) * filecount);
	int i = 0;
	while ((f = readdir(dir)))
		if (f->d_type == DT_REG && f->d_name[0] != '.') {
			struct stat *s = malloc(sizeof(struct stat));
			stat(f->d_name, s);
			struct fileinfo inf;
			inf.name = calloc(strlen(f->d_name)+1, 1);
			strcpy(inf.name, f->d_name);
			inf.size = s->st_size;
			files[i++] = inf;
		}
	closedir(dir);

	// write the image file
	FILE *img = fopen(imgname, "wb");
	if (!img) perror("mkdfl: could not write image file"), exit(0);

	// write the meta-header
	fwrite(&DFL_MAGIC, sizeof(DFL_MAGIC), 1, img); 
	fwrite(&DFL_FLAGS, sizeof(DFL_FLAGS), 1, img);
	char *name = calloc(20, 1);
	strncpy(name, volname, 20);
	fwrite(name, 20, 1, img);
	char hsize = (filecount+15) / 16;
	fwrite(&hsize, 1, 1, img);
	fseek(img, 512, SEEK_SET);

	// write each file's entry
	int layout_ptr = hsize+1;
	char *pad = calloc(7, 1);
	for (i=0; i<filecount; i++) {
		fwrite(&layout_ptr, 4, 1, img);
		char flags = 0x00;
		fwrite(&flags, 1, 1, img);
		char *name = calloc(20, 1);
		strncpy(name, files[i].name, 20);
		fwrite(name, 20, 1, img);
		fwrite(pad, 7, 1, img);
		layout_ptr += (files[i].size+511) / 512;
	}

	printf("%s\n", files[0].name);

	for (i=0; i<filecount; i++) {
		seek512(img);
		FILE *fin = fopen(files[i].name, "rb");
		if (!fin) perror("mkdfl: could not open file for reading"), exit(0);
		while (!feof(fin)) {
			fputc(fgetc(fin), img);
		}
		fclose(fin);
	}
	seek512(img);
	fputc(0, img);
	seek512(img);
	fseek(img, -1, SEEK_CUR);
	fputc(0, img);

	// write the file table
	fclose(img);

	return 0;
}

// seek to a 512-byte boundary
void seek512(FILE *f) {
	fseek(f, (512 - (ftell(f)%512))%512, SEEK_CUR);
}

