;;;;;;;;;;;;;
;; STAGE 2 ;;
;;;;;;;;;;;;;

[bits	16]
[org	0x1000]

mov	al, '>'
mov	ah, 0x0e
mov	bh, 0x00
mov	bl, 0x07
int	0x10

; TODO: go graphical

; Drop into protected mode
cli		; ensure interrupts are disabled


; force a total of 7 sectors
times	7*512 - ($ - $$) db 0

