; Boot loader for wyvern

[bits 16]
[org 0x7c00]

cli

call	Progress

;mov     ax, 0x07c0
;mov     ds, ax
;mov     es, ax
;mov     fs, ax
;mov     gs, ax

; Assume we're using the first hard disk
mov	dl, 0x80

; reset drive
mov	ah, 0x00
int	0x13

;mov	di, 512
;a:
;mov	al, [0x7c00 + di]
;call	PrintCharacter
;dec	di
;jnz	a

mov	si, 0x7c00
add	si, 0x0200
sub	si, 18

call	PrintCharacter
mov	ah, 0x42
int	0x13

mov	al, ah
add	al, '0'
call	PrintCharacter

jc	Error

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
hlt

times	512 - 16 - 2 - ($ - $$) db 0

; The DAP: Data Address Packet
db	0x10	; size of DAP
db	0x00	; unused
db	0x01	; number of sectors to read
db	0x00	; unused
dw	0x1000	; offset of destination buffer
dw	0x0000	; segment of destination buffer
dw	0x0000
dw	0x0000
dw	0x0000
dw	0x0001	; where to start reading
dw	0xaa55

