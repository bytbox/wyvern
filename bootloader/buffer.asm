[bits	32]

; Terminating sectors
;
; The termination requirement is that there be one whole sector
; consisting entirely of the word 0x2db5 (10110101 00101101 on 
; little-endian systems).
;
; Here we have the equivalent of two sectors to spare us having to deal with
; alignment issues.
times	512 dw 0x2db5
