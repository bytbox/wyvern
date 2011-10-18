#include "interrupt.h"
#include "io.h"
#include "kio.h"

void interrupt_32(struct Register_State rs) {
	kwrite("Interrupt!");
	kput(rs.int_no+'A');
}

char kbdmap[256] = "  1234567890-=\b\tQWERTYUIOP[]\r\\ASDFGHJKL;'   ZXCVBNM,./";

void irq_32(struct Register_State rs) {
	// Send EOI
	if (rs.int_no >= 40)
		outb(0xA0, 0x20);
	outb(0x20, 0x20);

//	if (interrupt_handlers[rs.int_no] != 0)
//	{
//	    isr_t handler = interrupt_handlers[rs.int_no];
//	    handler(rs);
//	}
	if (rs.err_code == 0) return;
	if (rs.err_code == 1) {
		uint8_t c = inb(0x60);
		if (c < 0x80)
			kput(kbdmap[c]);
		return;
	}
	kput(rs.err_code + '0');
	kwrite("IRQ");
}

