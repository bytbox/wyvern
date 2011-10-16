#include "interrupt.h"
#include "kio.h"

void interrupt_32(struct Register_State rs) {
	kwrite("Interrupt!");
}

