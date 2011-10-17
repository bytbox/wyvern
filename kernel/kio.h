#ifndef KIO_H
#define KIO_H

#include "types.h"

extern volatile unsigned char *videoram;

void kio_init();

void kdraw(uint8_t, uint8_t, char *, uint8_t);

/* 
 * kwrite is a hack to allow direct, emergency writing to the screen. It
 * operates independently from all other kernel I/O, and should not be used in
 * a production kernel.
 */
void kwrite(char *);

void kput(char);

#endif /* !KIO_H */
