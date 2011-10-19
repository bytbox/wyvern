BASEDIR ?= ..
KERNDIR = ${BASEDIR}/kernel

include ${BASEDIR}/make.config

KERNELASM_LIST = loader init isr
KERNELASM = $(foreach f, ${KERNELASM_LIST}, ${BASEDIR}/kernel/$f)
KERNELC_LIST = kmain idt gdt interrupt io kio scam
KERNELC = $(foreach f, ${KERNELC_LIST}, ${BASEDIR}/kernel/$f)
KERNELOBJ = ${KERNELASM:=.o} ${KERNELC:=.o}
KERNELSRC = ${KERNELASM:=.asm} ${KERNELC:=.c}

all: depend wyvern.kernel

depend: .depend
.depend: ${KERNELC:=.c}
	@${RM} $@
	$(foreach c, ${KERNELC}, $(KCC) $(KCCFLAGS) -MM ${c:=.c} -MT ${c:=.o} >> $@;)
-include .depend

wyvern.kernel: ${KERNELOBJ}
	@${ECHO} "LD   $@"
	@${KLD} ${KLDFLAGS} -T ${BASEDIR}/kernel/linker.ld -o $@ ${KERNELOBJ}

.asm.o:
	@${ECHO} "ASM  $@"
	@${KNASM} ${KNASMFLAGS} -o $@ $<

.c.o:
	@${ECHO} "CC   $@"
	@${KCC} ${KCCFLAGS} -o $@ $<

clean:
	${RM} ${KERNDIR}/.depend
	${RM} ${KERNELOBJ}
	${RM} ${KERNDIR}/wyvern.kernel

distclean realclean clobber: clean

.PHONY: all clean depend distclean realclean clobber
.SUFFIXES: .c .o .asm

