#include "interrupt.h"
#include "io.h"
#include "kio.h"

void interrupt_32(struct Register_State rs) {
	kwrite("Interrupt!");
	kput(rs.int_no+'A');
}

void irq_32(struct Register_State rs) {
	// Send an EOI (end of interrupt) signal to the PICs.
	// If this interrupt involved the slave.
	if (rs.int_no >= 40)
	{
	    // Send reset signal to slave.
	    outb(0xA0, 0x20);
	}
	// Send reset signal to master. (As well as slave, if necessary).
	outb(0x20, 0x20);

//	if (interrupt_handlers[rs.int_no] != 0)
//	{
//	    isr_t handler = interrupt_handlers[rs.int_no];
//	    handler(rs);
//	}

	kwrite("IRQ");
}

