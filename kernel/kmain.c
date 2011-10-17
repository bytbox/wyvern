#include "gdt.h"
#include "idt.h"

#include "kio.h"

void kmain() {
	kio_init();

	kdraw(0, 0, "Wyvern", 0x1F);
	kdraw(7,0, VERSION,  0x10);

	/* complete kernel initialization */
	kwrite("Preparing GDT...");
	gdt_load_32((uint32_t)&gdt_ptr_32);
	kwrite("Preparing IDT...");
	idt_init();
	kwrite("Loading IDT...");
	idt_load_32((uint32_t)&idt_ptr_32);

	kdraw(0, 10, "I await your orders...", 0x2F);

	return;
}

