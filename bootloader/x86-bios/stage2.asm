; Boot loader for wyvern

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


call	StopBaton
mov	si, $donemsg
call	PrintString
call	Newline

; Drop into protected mode
cli		; ensure interrupts are disabled

; load the GDT
lgdt	[gdtr]

; TODO jump into the GDT

; enable A20 line
; FIXME this mightn't always work. Try also
;	mov ax, 0x2401
;	int 0x15
;in	al, 0x92
;or	al, 2
;out	0x92, al

; We enter protected mode by flipping the first bit of CR0
mov	eax, cr0
or	al, 1
mov	cr0, eax

jmp	0x08:init_32bit

hlt

error:
call	StopBaton
call	Newline

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
; The requirement for a sector ending is that it consist entirely of the
; word 0x2db5 (10110101 00101101 on little-endian systems).
;
; The current sector is located at dap_offset.
CheckSector:
	mov	cx, 512
.checkloop:
	mov	ax, 0x2db5
	mov	si, [dap_offset]
	mov 	bx, 512
	sub	bx, cx
	mov	dx, [bx + si]
	cmp	ax, dx
	jne	.nomatch
	sub	cx, 2
	jnz	.checkloop
	mov	cx, 0		; This is the last sector
	jmp	.checkdone
.nomatch:			; This is not the last sector
	mov	cx, 1
.checkdone:			; The check is over - return the result
	ret

; Copy a sector from the sector hold point into the program destination, and 
; advance the program destination.
CopySector:
	mov	si, [kwptr]
	mov	bx, [dap_offset]
	; copy 512 bytes
	mov	cx, 512
.1:
	mov	ax, [bx]
	mov	[si], ax
	inc	si
	inc	bx
	dec	cx
	jnz	.1

	mov	[kwptr], si
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

$name:		db	'Wyvern Bootloader v0.2'
		db	0
$baton:		db	'/-\|'
$curbaton:	db	0
; used to slow the spin rate
$batonc		dw	0

$donemsg:	db	'Kernel loaded!'
		db	10
		db	13
		db	0

; Static data to help printing
_hex:		db '0123456789ABCDEF'
_errmsg:	db 'Stage 2 bootloader error (kernel could not be read): 0x'
		db 0
_haltmsg:	db 'Halting'
		db 0

; Kernel write pointer. Updated by WriteSector.
kwptr:		dw 0xa000

		db 'Hello'

; Global Descriptor Table
gdtr:		dw gdt_end-gdt
		dd gdt

gdt:					; Each entry is 2 words and four bytes.
; Null segment
		dw 0			; limit_low
		dw 0			; base_low
		db 0			; base_middle
		db 0			; access
		db 0			; granularity
		db 0			; base_high

; Code segment
;
; Theoretically, we could used segment based protection with a separate (and
; relatively small) code segment. However, wyven will want to cache as much
; code as possible, making a large (and potentially dynamic) code storage space
; useful. Effectively having one large segment makes the bootloader simpler and
; gives the kernel more control - everybody's happy.
		dw 0xffff		; limit_low
		dw 0			; base_low
		db 0			; base_middle
		db 0x9a			; access
		db 0xcf			; granularity
		db 0			; base_high

; Data segment
;
; Essentially identical to the code segment.
		dw 0xffff		; limit_low
		dw 0			; base_low
		db 0			; base_middle
		db 0x92			; access
		db 0xcf			; granularity
		db 0			; base_high
gdt_end:

[bits 32]

init_32bit:
mov	ax, 0x10
mov	ds, ax
mov	es, ax
mov	fs, ax
mov	gs, ax
hlt

[bits 16]

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
dw	0x9000	; offset of destination buffer
dap_segment:
dw	0x0000	; segment of destination buffer
dap_start:
dq	0x0007	; where to start reading
