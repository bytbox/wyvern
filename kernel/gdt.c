#include "gdt.h"

/* The actual GDT */

/*
For now, we do this the ugly way - all memory is set to be both code and data.
This may change in the future.
*/

struct GDT_Entry_32 gdt_32[] = {
	{0,0,0,0,0,0}, /* NULL entry - we seem to need this for some reason */
	{0xFFFF, 0, 0, 0x9A, 0xCF, 0}, /* Code */
	{0xFFFF, 0, 0, 0x92, 0xCF, 0}, /* Data */
};

struct GDT_Ptr_32 gdt_ptr_32 = {
	sizeof(gdt_32)-1,   /* limit */
	(uint32_t)(&gdt_32) /* base */
};

