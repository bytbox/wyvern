; Boot loader for wyvern

;;;;;;;;;;;;;
;; STAGE 1 ;;
;;;;;;;;;;;;;

[bits 16]
[org 0x7c00]

cli

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
jc	_Error

jmp	0:0x1000

_Error:
mov	si, 0
.1:
mov	al, [_errmsg + si]
mov	ah, 0x0e
mov	bh, 0x00
mov	bl, 0x07
int	0x10
inc	si
mov	al, [_errmsg + si]
cmp	al, 0
jnz	.1
hlt

_errmsg:	db 'Stage 1 bootloader error'
		db 10
		db 13
		db 'Halting'
		db 10
		db 13
		db 0

times	512 - 16 - 2 - ($ - $$) db 0

; The DAP: Data Address Packet
db	0x10	; size of DAP
db	0x00	; unused
dw	0x01	; number of sectors to read
dw	0x1000	; offset of destination buffer
dw	0x0000	; segment of destination buffer
dq	0x0001	; where to start reading

dw	0xaa55


;;;;;;;;;;;;;
;; STAGE 2 ;;
;;;;;;;;;;;;;

mov	al, '>'
mov	ah, 0x0e
mov	bh, 0x00
mov	bl, 0x07
int	0x10

; force another 7 sectors
times	8*512 - ($ - $$) db 0

