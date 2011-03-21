#ifndef KIO_H
#define KIO_H

extern volatile unsigned char *videoram;

/* 
 * kwrite is a hack to allow direct, emergency writing to the screen. It
 * operates independently from all other kernel I/O, and should not be used in
 * a production kernel.
 */
void kwrite(char *);

#endif /* !KIO_H */
