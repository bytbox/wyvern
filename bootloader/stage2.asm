;;;;;;;;;;;;;
;; STAGE 2 ;;
;;;;;;;;;;;;;

[bits	16]
[org	0x1000]

mov	si, $name
call	PrintString
call	Newline

; get information about our system

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

; Print a character to the screen from al
PrintCharacter:
	mov	ah, 0x0e
	mov	bh, 0x00
	mov	bl, 0x07
	int	0x10
	ret

; Print a (null-terminated) string to the screen from the address in si
PrintString:
	mov	ch, 0
	mov	cl, 0
	.1:
	mov	bx, cx
	mov	al, [si + bx]
	call	PrintCharacter
	inc	cl
	mov	bx, cx
	mov	al, [si + bx]
	cmp	al, 0
	jnz	.1
	ret

; Move to the beginning of the next line
Newline:
	mov	al, 10
	call	PrintCharacter
	mov	al, 13
	call	PrintCharacter
	ret

;; Baton control functions
StartBaton:
	ret

SpinBaton:
	ret

StopBaton:
	ret

$name:		db	'Wyvern Bootloader v0.1'
$baton:		db	'/-\|'
$curbaton:	db	'/'

; force a total of 7 sectors
times	7*512 - ($ - $$) db 0

