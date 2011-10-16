#ifndef INTERRUPT_H
#define INTERRUPT_H

#include "types.h"

/*** Data Structures ***/

struct Register_State {
	uint32_t ds;
	uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax;
	uint32_t int_no, err_code;
	uint32_t eip, cs, eflags, useresp, ss;
};

/*** C Functions ***/

void interrupt_32(struct Register_State);

#endif /* !INTERRUPT_H */

