; Multiboot boot loader for wyvern
;
; This "boot loader" may be loaded by any multiboot-compliant boot loader (such
; as GRUB), and will in turn load the wyvern kernel.

; This is the only stage

[bits	32]
HEADER_MAGIC	equ	0x1BADB002
HEADER_FLAGS	equ	0x00010000
CHECKSUM	equ	-(HEADER_MAGIC + HEADER_FLAGS)
LOADBASE	equ	0x00100000   ;Must be >= 1Mo
STACK_SIZE	equ	0x4000

_start:
	jmp     multiboot_entry         ;if you want use you own bootloader               

	align  4                     ;Multiboot header must be 32
multiboot_header:
	dd   HEADER_MAGIC      ;magic number
	dd   HEADER_FLAGS      ;flags
	dd   CHECKSUM                  ;checksum
	dd   LOADBASE + multiboot_header   ;header adress
	dd   LOADBASE                  ;load adress
	dd   00                     ;load end adress : not necessary
	dd   00                     ;bss end adress : not necessary
	dd   LOADBASE + multiboot_entry   ;entry adress
     
multiboot_entry:
	mov    esp, stack + STACK_SIZE      ;Setup the stack
	push   0                     ;Reset EFLAGS
	popf
	push   ebx                     ;Push magic number and
	push   eax                     ;multiboot info adress
	                          ;which are loaded in registers
	                          ;eax and ebx before jump to
	                          ;entry adress
	                          ;[LOADBASE + multiboot_entry]
	                       
	;call   EXT_C(main)               ; !! commented
	                          ;main (unsigned long magic, unsigned long addr)
	                          ;your kernel entry point
	                             
	mov   edi, 0xB8000            ;Msg to check the boot was OK
	mov   esi, hello
	add   esi, LOADBASE            ;hello is just an offset
msg:      
	mov   byte al, [esi]
	cmp   al, 0
	je   loop
	mov   ah, 0xa0                                     
	mov   word [edi],   ax         
	add   edi, 2
	inc   esi
	jmp   msg
	      
	loop:   hlt                        ;Halt processor
	      jmp     loop
   
_edata:                                 
hello:
   db   "Hello world from GRUB and flat binary kernel !\0"   
   align 4
   times (128) db 0x00                     ;foo data
stack:
   align 4
   times (STACK_SIZE) db 00
_end:

