; Boot loader for wyvern

;;;;;;;;;;;;;
;; STAGE 1 ;;
;;;;;;;;;;;;;

[bits	16]
[org	0x7c00]

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
jnc	0x1000

; Print an error message
__Error:
mov	dl, ah
mov	si, 0
.1:
mov	al, [_errmsg + si]
call	PrintCharacter
inc	si
mov	al, [_errmsg + si]
cmp	al, 0
jnz	.1

; print the actual error code
mov	dh, 0
mov	si, dx
shr	si, 4
mov	al, [_hex + si]
call	PrintCharacter
mov	si, dx
and	si, 0x0f
mov	al, [_hex + si]
call	PrintCharacter

mov	si, 0
.2:
mov     al, [_haltmsg + si]
call	PrintCharacter
inc     si
mov     al, [_haltmsg + si]
cmp     al, 0
jnz     .2

hlt

; Print a single character from al
PrintCharacter:
	mov	ah, 0x0e
	mov	bh, 0x00
	mov	bl, 0x07
	int	0x10
	ret

_hex:		db '0123456789ABCDEF'
_errmsg:	db 'Stage 1 bootloader error: 0x'
		db 0
_haltmsg:	db 10
		db 13
		db 'Halting'
		db 10
		db 13
		db 0

times	512 - 16 - 2 - ($ - $$) db 0

; The DAP: Data Address Packet
; This describes where to read stage 2 from
db	0x10	; size of DAP
db	0x00	; unused
dw	0x07	; number of sectors to read
dw	0x1000	; offset of destination buffer
dw	0x0000	; segment of destination buffer
dq	0x0001	; where to start reading

dw	0xaa55

