#include "idt.h"
#include "types.h"

/* IDT */
struct IDT_Descr_32 idt_32 [256];

struct IDT_Ptr_32 idt_ptr_32 = {
	sizeof(idt_32)-1,   /* limit */
	(uint32_t)(&idt_32) /* base */
};

void idt_init() {
	idt_set(0, (uint32_t)isr0, 0x08, 0x8E);
	idt_set(1, (uint32_t)isr1, 0x08, 0x8E);
	idt_set(2, (uint32_t)isr2, 0x08, 0x8E);
	idt_set(3, (uint32_t)isr3, 0x08, 0x8E);
	idt_set(4, (uint32_t)isr4, 0x08, 0x8E);
	idt_set(5, (uint32_t)isr5, 0x08, 0x8E);
	idt_set(6, (uint32_t)isr6, 0x08, 0x8E);
	idt_set(7, (uint32_t)isr7, 0x08, 0x8E);
	idt_set(8, (uint32_t)isr8, 0x08, 0x8E);
	idt_set(9, (uint32_t)isr9, 0x08, 0x8E);
	idt_set(10, (uint32_t)isr10, 0x08, 0x8E);
	idt_set(11, (uint32_t)isr11, 0x08, 0x8E);
	idt_set(12, (uint32_t)isr12, 0x08, 0x8E);
	idt_set(13, (uint32_t)isr13, 0x08, 0x8E);
	idt_set(14, (uint32_t)isr14, 0x08, 0x8E);
	idt_set(15, (uint32_t)isr15, 0x08, 0x8E);
	idt_set(16, (uint32_t)isr16, 0x08, 0x8E);
	idt_set(17, (uint32_t)isr17, 0x08, 0x8E);
	idt_set(18, (uint32_t)isr18, 0x08, 0x8E);
	idt_set(19, (uint32_t)isr19, 0x08, 0x8E);
	idt_set(20, (uint32_t)isr20, 0x08, 0x8E);
	idt_set(21, (uint32_t)isr21, 0x08, 0x8E);
	idt_set(22, (uint32_t)isr22, 0x08, 0x8E);
	idt_set(23, (uint32_t)isr23, 0x08, 0x8E);
	idt_set(24, (uint32_t)isr24, 0x08, 0x8E);
	idt_set(25, (uint32_t)isr25, 0x08, 0x8E);
	idt_set(26, (uint32_t)isr26, 0x08, 0x8E);
	idt_set(27, (uint32_t)isr27, 0x08, 0x8E);
	idt_set(28, (uint32_t)isr28, 0x08, 0x8E);
	idt_set(29, (uint32_t)isr29, 0x08, 0x8E);
	idt_set(30, (uint32_t)isr30, 0x08, 0x8E);
	idt_set(31, (uint32_t)isr31, 0x08, 0x8E);
	idt_set(32, (uint32_t)isr32, 0x08, 0x8E);
}

void idt_set(uint8_t inum, uint32_t fptr, uint16_t sel, uint8_t flags) {
	idt_32[inum].offset_1 = fptr & 0xFFFF;
	idt_32[inum].offset_2 = (fptr >> 16) & 0xFFFF;
	idt_32[inum].selector = sel;
	idt_32[inum].type_attr = flags;
	idt_32[inum].zero = 0;
}


