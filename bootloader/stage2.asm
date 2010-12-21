;;;;;;;;;;;;;
;; STAGE 2 ;;
;;;;;;;;;;;;;

[bits	16]
[org	0x1000]

mov	al, '>'
call	PrintCharacter

; TODO: go graphical

; Drop into protected mode
cli		; ensure interrupts are disabled
; TODO load the GDT
; We enter protected mode by flipping the first bit of CR0
mov	eax, cr0
or	al, 1
;mov	cr0, eax
; TODO jump into the GDT

;;; Function definitions
;;	These functions are 16-bit real mode functions - they
;;	use the BIOS directly and will not work once we are in protected mode.

; Print a character to the screen
PrintCharacter:
	mov	ah, 0x0e
	mov	bh, 0x00
	mov	bl, 0x07
	int	0x10
	ret

; force a total of 7 sectors
times	7*512 - ($ - $$) db 0

