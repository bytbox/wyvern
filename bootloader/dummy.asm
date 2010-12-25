; A dummy kernel for testing the wyvern bootloader

[bits	32]
[org	0x1000]

; This kernel is mostly just empty space. It has a valid ending 
; sequence.

times	2047*512 db 0

; Terminating sectors
;
; The termination requirement is that there be one whole sector
; consisting entirely of the word 0x2db5 (10110101 00101101 on 
; little-endian systems).
times	256 dw 0x2db5
