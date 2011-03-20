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
}
