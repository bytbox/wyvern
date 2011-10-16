[GLOBAL gdt_load_32]
[GLOBAL idt_load_32]

[GLOBAL remap_irq]
[GLOBAL outb]
;[GLOBAL inb]

gdt_load_32:
	mov	eax, [esp+4]
	lgdt	[eax]

	mov	ax, 0x10
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax
	mov	ss, ax

	jmp	0x08:.1
.1:
	ret

idt_load_32:
	mov	eax, [esp+4]
	lidt	[eax]
	ret

remap_irq:
	mov	ax, 0x11
	out	0x20, ax
	out	0xA0, ax
	mov	ax, 0x20
	out	0x21, ax
	mov	ax, 0x28
	out	0xA1, ax
	mov	ax, 0x04
	out	0x21, ax
	mov	ax, 0x02
	out	0xA1, ax
	mov	ax, 0x01
	out	0x21, ax
	out	0xA1, ax
	xor	ax, ax
	mov	ax, 0xFF
	out	0x21, ax
	out	0xA1, ax
	
	sti
	ret

outb:
	xor	dx, dx
	xor	al, al
	mov	dl, [esp+4]
	mov	byte al, byte [esp+8]
	out	dx, al
	ret

