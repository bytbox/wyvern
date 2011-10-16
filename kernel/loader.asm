global loader           ; making entry point visible to linker
extern kmain            ; kmain is defined elsewhere

[bits	32]
HEADER_MAGIC	equ	0x1BADB002
HEADER_FLAGS	equ	0x00010004
CHECKSUM	equ	-(HEADER_MAGIC + HEADER_FLAGS)
LOADBASE	equ	0x00100000		;Must be >= 1Mo
; reserve initial kernel stack space
STACKSIZE equ 0x4000			; 16K should be enough
 
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
loader:
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
	mov esp, stack+STACKSIZE	; set up the stack
	call kmain			; call kernel proper
	int 3
	;cli
hang:
	hlt				; halt machine should kernel return
	jmp   hang

loading:
	db	"Booting wyvern ..."
	db	0


section .bss
align 4
stack:
	resb STACKSIZE

