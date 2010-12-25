;;;;;;;;;;;;;
;; STAGE 2 ;;
;;;;;;;;;;;;;

[bits	16]
[org	0x1000]

mov	si, $name
call	PrintString
call	Newline

call	StartBaton

; get information about our system, as necessary

; TODO: go graphical

; read the kernel into memory
mov	dl, 0
copykernel:
call	ReadSector
call	CheckSector
jcxz	done
call	CopySector
mov	dx, [$batonc]
inc	dx
and	dx, 0x03ff
mov	[$batonc], dx
jnz	skipspin
call	SpinBaton
skipspin:
jmp	copykernel

done:

; Drop into protected mode
cli		; ensure interrupts are disabled

; TODO load the GDT

call	StopBaton

; We enter protected mode by flipping the first bit of CR0
mov	eax, cr0
or	al, 1
;mov	cr0, eax
; TODO jump into the GDT

hlt

error:
call	StopBaton
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
call	Newline

mov	si, 0
.2:
mov     al, [_haltmsg + si]
call	PrintCharacter
inc     si
mov     al, [_haltmsg + si]
cmp     al, 0
jnz     .2
call	Newline
cli
hlt

;;; Function definitions
;;	These functions are 16-bit real mode functions - they
;;	use the BIOS directly and will not work once we are in protected mode.

; Read a single sector from the current cursor position, and advance the
; cursor.
ReadSector:
	; copy sector
	mov	dl, [drive]
	mov	si, dap
	mov	ah, 0x42
	int	0x13
	jc	error
	; advance the cursor
	mov	eax, [dap_start]
	inc	eax
	mov	[dap_start], eax
	ret

; Check the current sector to see if it is the final sector in the kernel.
; The value of cx will be 0 if it is, >0 if it is not.
;
; The requirement for a sector ending is that in consist entirely of the
; word 0x2db5 (10110101 00101101 on little-endian systems).
CheckSector:
	mov	cx, 1
	ret

; Copy a sector from the sector hold point into the program destination, and 
; advance the program destination.
CopySector:
	ret

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
	mov	al, [$baton]
	mov	[$curbaton], byte 0
	call	PrintCharacter
	ret

SpinBaton:
	mov	al, 8
	call	PrintCharacter
	mov	ch, 0
	mov	cl, [$curbaton]
	inc	cl
	and	cl, 3
	mov	[$curbaton], cx
	mov	si, cx
	mov	al, [$baton + si]
	call	PrintCharacter
	ret

StopBaton:
	mov	al, 8
	call	PrintCharacter
	mov	al, ' '
	call	PrintCharacter
	mov	al, 8
	call	PrintCharacter
	ret

$name:		db	'Wyvern Bootloader v0.1'
		db	0
$baton:		db	'/-\|'
$curbaton:	db	0
; used to slow the spin rate
$batonc		dw	0

; Static data to help printing
_hex:		db '0123456789ABCDEF'
_errmsg:	db 'Stage 2 bootloader error (kernel could not be read): 0x'
		db 0
_haltmsg:	db 'Halting'
		db 0

; force a total of 7 sectors
times	7*512 - 16 - 1 - ($ - $$) db 0

; The ID of the drive from which to read the kernel
drive:
db	0x80

; The DAP: Data Address Packet
; This describes where to read the kernel from
dap:
dap_size:
db	0x10	; size of DAP
db	0x00	; unused
dap_rsize:
dw	0x01	; number of sectors to read
dap_offset:
dw	0xa000	; offset of destination buffer
dap_segment:
dw	0x0000	; segment of destination buffer
dap_start:
dq	0x0008	; where to start reading

