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
	mov	al, 0x11
	out	0x20, al
	out	0xA0, al
	mov	al, 0x20
	out	0x21, al
	mov	al, 0x28
	out	0xA1, al
	mov	al, 0x04
	out	0x21, al
	mov	al, 0x02
	out	0xA1, al
	mov	al, 0x01
	out	0x21, al
	out	0xA1, al
	xor	al, al
	mov	al, 0xFC
	out	0x21, al
	mov	al, 0xFF
	out	0xA1, al

	mov	al, 0x36
	out	0x43, al
	mov	ax, 0x1010
	out	0x40, al
	out	0x40, al

	sti
	ret

outb:
	xor	dx, dx
	xor	al, al
	mov	dl, [esp+4]
	mov	byte al, byte [esp+8]
	out	dx, al
	ret

