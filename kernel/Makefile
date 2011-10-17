include ../make.config

KERNELASM = loader init isr
KERNELC = kmain idt gdt interrupt io kio
KERNELOBJ = ${KERNELASM:=.o} ${KERNELC:=.o}
KERNELSRC = ${KERNELASM:=.asm} ${KERNELC:=.c}

all: depend wyvern.kernel

depend: .depend
.depend: ${KERNELC:=.c}
	${RM} ./.depend
	$(CC) $(CFLAGS) -MM $^ >> ./.depend;
-include .depend

wyvern.kernel: ${KERNELOBJ}
	@${ECHO} "LD   $@"
	@${KLD} ${KLDFLAGS} -T linker.ld -o $@ ${KERNELOBJ}

.asm.o:
	@${ECHO} "ASM  $@"
	@${KNASM} ${KNASMFLAGS} -o $@ $<

.c.o:
	@${ECHO} "CC   $@"
	@${KCC} ${KCCFLAGS} -o $@ $<

clean:
	${RM} .depend
	${RM} ${KERNELOBJ}
	${RM} wyvern.kernel

.PHONY: all clean
.SUFFIXES: .c .o .asm

