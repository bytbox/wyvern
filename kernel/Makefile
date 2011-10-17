include ../make.config

KERNELASM = loader init isr
KERNELC = kmain idt gdt interrupt io
KERNELOBJ = ${KERNELASM:=.o} ${KERNELC:=.o}

all: wyvern.kernel

wyvern.kernel: ${KERNELOBJ}
	${KLD} ${KLDFLAGS} -T ${KERNELOBJ} -o $@ linker.ld

clean:
	${RM} ${KERNELOBJ}
	${RM} wyvern.kernel

.PHONY: all clean

