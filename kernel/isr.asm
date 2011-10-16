[EXTERN interrupt_32]

%macro ISR_NOERRCODE 1
[GLOBAL isr%1]
isr%1:
	cli
	push	byte 0	; fake error code
	push	byte %1
	jmp isr_common
%endmacro

%macro ISR_ERRCODE 1
[GLOBAL isr%1]
isr%1:
	cli
	push	byte %1
	jmp isr_common
%endmacro

isr_common:
	pusha

	mov	ax, ds
	push	eax

	mov	ax, 0x10
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax

	; Call a handler
	call interrupt_32

	pop	eax
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax

	popa
	add	esp, 8

	sti
	iret

ISR_NOERRCODE	0
ISR_NOERRCODE	1
ISR_NOERRCODE	2
ISR_NOERRCODE	3
ISR_NOERRCODE	4
ISR_NOERRCODE	5
ISR_NOERRCODE	6
ISR_NOERRCODE	7
ISR_ERRCODE	8
ISR_NOERRCODE	9
ISR_ERRCODE	10
ISR_ERRCODE	11
ISR_ERRCODE	12
ISR_ERRCODE	13
ISR_ERRCODE	14
ISR_NOERRCODE	15
ISR_NOERRCODE	16
ISR_NOERRCODE	17
ISR_NOERRCODE	18
ISR_NOERRCODE	19
ISR_NOERRCODE	20
ISR_NOERRCODE	21
ISR_NOERRCODE	22
ISR_NOERRCODE	23
ISR_NOERRCODE	24
ISR_NOERRCODE	25
ISR_NOERRCODE	26
ISR_NOERRCODE	27
ISR_NOERRCODE	28
ISR_NOERRCODE	29
ISR_NOERRCODE	30
ISR_NOERRCODE	31
ISR_NOERRCODE	32

