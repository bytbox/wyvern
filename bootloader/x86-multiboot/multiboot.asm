; Multiboot boot loader for wyvern
;
; This "boot loader" may be loaded by any multiboot-compliant boot loader (such
; as GRUB), and will in turn load the wyvern kernel.

; This is the only stage

[bits	32]
HEADER_MAGIC	equ	0x1BADB002
HEADER_FLAGS	equ	0x00010004
CHECKSUM	equ	-(HEADER_MAGIC + HEADER_FLAGS)
LOADBASE	equ	0x00100000		;Must be >= 1Mo

_start:
	jmp     multiboot_entry			;if you want use you own bootloader               

	align  4
multiboot_header:
	dd	HEADER_MAGIC			; magic number
	dd	HEADER_FLAGS			; flags
	dd	CHECKSUM			; checksum
	dd	LOADBASE + multiboot_header	; header address
	dd	LOADBASE			; load address
	dd	00				; load end address : not necessary
	dd	00				; bss end address : not necessary
	dd	LOADBASE + multiboot_entry	; entry adress
	dd	1				; EGA-standard text mode
	dd	0				; width (no preference)
	dd	0				; height (no preference)
	dd	0				; must be 0 in text mode     

multiboot_entry:
	mov	edi, 0xB8000			;Msg to check the boot was OK
	mov	esi, loading
	add	esi, LOADBASE			;loading is just an offset
	mov	ah, 0x0f
msg:
	mov	byte al, [esi]
	cmp	al, 0
	je	load
	mov	word [edi], ax
	add	edi, 2
	inc	esi
	jmp	msg
	      
load:
	jmp	0x100200

loading:
	db	"Booting wyvern ..."
	db	0
	align	4
	times	(128) db 0x00
	
	times	512 - ($ - $$) db 0

