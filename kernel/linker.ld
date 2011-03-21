OUTPUT_FORMAT("binary")
ENTRY(loader)
phys = 0x00010000;

SECTIONS
{
	.text phys : AT(phys) {
		code = .;
		*(.text)
		*(.rodata)
		. = ALIGN(4096);
	}
	.data : AT(phys + (data - code))
	{
		data = .;
		*(.data)
		. = ALIGN(4096);
	}
	.bss : AT(phys + (bss - code))
	{
		bss = .;
		*(.bss)
		. = ALIGN(4096);
	}
	end = .;
}

/*OUTPUT_FORMAT("binary")
ENTRY (loader)

SECTIONS {
	.text : AT(0x00010000) {
		*(.text)
	}

	.rodata ALIGN (0x1000) : {
		*(.rodata)
	}

	.data ALIGN (0x1000) : {
		*(.data)
	}

	.bss : {
		sbss = .;
		*(COMMON)
		*(.bss)
		ebss = .;
	}

	/DISCARD/ : {
		*(.comment)
	}
}*/
