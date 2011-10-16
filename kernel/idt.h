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
void idt_init();
void idt_set(uint8_t, uint32_t, uint16_t, uint8_t);

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

extern void isr0 (void);
extern void isr1 (void);
extern void isr2 (void);
extern void isr3 (void);
extern void isr4 (void);
extern void isr5 (void);
extern void isr6 (void);
extern void isr7 (void);
extern void isr8 (void);
extern void isr9 (void);
extern void isr10 (void);
extern void isr11 (void);
extern void isr12 (void);
extern void isr13 (void);
extern void isr14 (void);
extern void isr15 (void);
extern void isr16 (void);
extern void isr17 (void);
extern void isr18 (void);
extern void isr19 (void);
extern void isr20 (void);
extern void isr21 (void);
extern void isr22 (void);
extern void isr23 (void);
extern void isr24 (void);
extern void isr25 (void);
extern void isr26 (void);
extern void isr27 (void);
extern void isr28 (void);
extern void isr29 (void);
extern void isr30 (void);
extern void isr31 (void);
extern void isr32 (void);

/* The IDT */
extern struct IDT_Descr_32 idt_32 [];

/* Pointer to the IDT */
extern struct IDT_Ptr_32 idt_ptr_32;

#pragma pack(pop)

#endif /* !IDT_H */

