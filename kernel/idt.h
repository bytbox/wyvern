/*
	idt.h
	Describes the Interrupt Descriptor Table (IDT)
*/

#ifndef IDT_H
#define IDT_H

#include "types.h"

#pragma pack(push)
#pragma pack(1)

/*** C Functions ***/

/*** Assembly Functions ***/
void idt_load_32 (uint32_t);

/*** Data Structures ***/

/* A single row of the IDT in 32-bit mode */
struct IDT_Descr_32 {
	uint16_t offset_1;
	uint16_t selector;
	uint8_t zero;
	uint8_t type_attr;
	uint16_t offset_2;
};

struct IDT_Ptr_32 {
	uint16_t limit;
	uint32_t base;
};

/*** Externs ***/

/* The IDT */
extern struct IDT_Descr_32 idt_32 [];

/* Pointer to the IDT */
extern struct IDT_Ptr_32 idt_ptr_32;

#pragma pack(pop)

#endif /* !IDT_H */

