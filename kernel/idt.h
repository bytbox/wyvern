#ifndef IDT_H
#define IDT_H

#include "types.h"

/*** C Functions ***/

/* Set a row of the IDT to the currently prepared row */
inline void idt_32_set_row (uint8_t);

/*** Assembly Functions ***/

/*** Data Structures ***/

/* A single row of the IDT in 32-bit mode */
struct IDT_Descr_32 {
	uint16_t offset_1;
	uint16_t selector;
	uint8_t zero;
	uint8_t type_attr;
	uint16_t offset_2;
};

/*** Externs ***/

/* The IDT Table */
extern struct IDT_Descr_32 idt_32 [];

/* Temporary storage */
extern struct IDT_Descr_32 idt_row_32;

#endif /* !IDT_H */

