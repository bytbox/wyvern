/*
	gdt.h
	Describes the Global Descriptor Table (GDT)
*/

#ifndef GDT_H
#define GDT_H

#include "types.h"

#pragma pack(push)
#pragma pack(1)

/*** C Functions ***/

/*** Assembly Functions ***/
void gdt_load_32 (uint32_t);

/*** Data Structures ***/

/* An entry in the GDT */
struct GDT_Entry_32 {
	uint16_t limit_low;
	uint16_t base_low;
	uint8_t base_middle;
	uint8_t access;
	uint8_t granularity;
	uint8_t base_high;
};

/* A `pointer' to the GDT */
struct GDT_Ptr_32 {
	uint16_t limit;
	uint32_t base;
};

/*** Externs ***/

/* The actual GDT */
extern struct GDT_Entry_32 gdt_32 [];

extern struct GDT_Ptr_32 gdt_ptr_32;

#pragma pack(pop)

#endif /* !GDT_H */

