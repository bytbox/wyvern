include ../make.config

#depend: .depend

#.depend: $(SRCS)
#        rm -f ./.depend
#        $(CC) $(CFLAGS) -MM $^ >> ./.depend;

#include .depend

KERNELASM = loader init isr
KERNELC = kmain idt gdt interrupt io kio
KERNELOBJ = ${KERNELASM:=.o} ${KERNELC:=.o}

all: wyvern.kernel

wyvern.kernel: ${KERNELOBJ}
	${KLD} ${KLDFLAGS} -T linker.ld -o $@ ${KERNELOBJ}

.asm.o:
	${KNASM} ${KNASMFLAGS} -o $@ $<

.c.o:
	${KCC} ${KCCFLAGS} -o $@ $<

clean:
	${RM} ${KERNELOBJ}
	${RM} wyvern.kernel

.PHONY: all clean
.SUFFIXES: .c .o .asm

