#include "gdt.h"
#include "idt.h"

#include "kio.h"

void kmain() {
	kio_init();

	/* complete kernel initialization */
	kwrite("Preparing GDT...");
	gdt_load_32((uint32_t)&gdt_ptr_32);
	kwrite("Preparing IDT...");
	idt_init();
	idt_load_32((uint32_t)&idt_ptr_32);

	// Hello world!
	kwrite("Hello");
	kwrite("There");
	return;
}

