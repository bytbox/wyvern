global loader           ; making entry point visible to linker
extern kmain            ; kmain is defined elsewhere
 
; reserve initial kernel stack space
STACKSIZE equ 0x4000			; 16K should be enough
 
loader:
	mov esp, stack+STACKSIZE	; set up the stack
	call kmain			; call kernel proper
	;cli
hang:
	hlt				; halt machine should kernel return
	jmp   hang

section .bss
align 4
stack:
	resb STACKSIZE

