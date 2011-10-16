#include "gdt.h"
#include "idt.h"

#include "kio.h"

void kmain() {
	kwrite("Preparing GDT...");

	/* complete kernel initialization */
	gdt_load_32((uint32_t)&gdt_ptr_32);

	// Hello world!
	kwrite("Hello");
	kwrite("There");
	return;
}

