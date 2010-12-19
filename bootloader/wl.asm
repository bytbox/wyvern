; Boot loader for wyvern

[bits 16]
[org 0x7c00]

cli

call	Progress

; Assume we're using the first hard disk
mov	dl, 0x80

; reset drive
mov	ah, 0x00
int	0x13

mov	si, 0x7c00
add	si, 0x0200
sub	si, 18

mov	ah, 0x42
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
hlt

times	512 - 16 - 2 - ($ - $$) db 0

; The DAP: Data Address Packet
db	0x10	; size of DAP
db	0x00	; unused
dw	0x01	; number of sectors to read
dw	0x1000	; offset of destination buffer
dw	0x0000	; segment of destination buffer
dq	0x0001	; where to start reading

dw	0xaa55

call	Progress

; force completion of the sector
times	512 db 0

