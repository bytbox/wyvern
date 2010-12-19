; Boot loader for wyvern

[bits 16]
[org 0x7c00]

cli

call	Progress

mov     ax, 0x07c0
mov     ds, ax
mov     es, ax
mov     fs, ax
mov     gs, ax

; attempt to read a single byte
; Assume we're using the first hard disk
mov	dl, 0x80

; reset drive
mov	ah, 0x00
int	0x13

; read a single sector
mov	ah, 0x02
mov	al, 0x01	; number of sectors
mov	ch, 0x00	; track
mov	cl, 0x00	; sector
mov	dh, 0x00	; head
			; disk is already set
mov	ax, 0x0000
mov	es, ax
mov	bx, 0x0000
int	0x13
jc	Error

mov	al, [0x1000]
add	al, '0'
call	PrintCharacter

call	Progress
hlt

;; print a '.' to the screen
;; Modifies ax, bx
Progress:
mov	al, '.'
call	PrintCharacter
ret

;; print a single character to the screen from al
;; modifies ah, bx
PrintCharacter:
mov	ah, 0x0e
mov	bh, 0x00
mov	bl, 0x07
int	0x10
ret

Error:
mov	al, '!'
call	PrintCharacter
ret

times	510 - ($ - $$) db 0
dw	0xaa55

