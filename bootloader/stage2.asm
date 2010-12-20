;;;;;;;;;;;;;
;; STAGE 2 ;;
;;;;;;;;;;;;;

[org	0x1000]
mov	al, '>'
mov	ah, 0x0e
mov	bh, 0x00
mov	bl, 0x07
int	0x10

; TODO: go graphical

; Drop into protected mode


; force another 7 sectors
times	7*512 - ($ - $$) db 0

