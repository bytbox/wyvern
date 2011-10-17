include make.config

all: wyvern.img

wyvern.img: kernel
	${CAT} kernel/wyvern.kernel > $@

kernel:
	make -Ckernel

clean:
	${RM} wyvern.img
	make -Ckernel clean

.PHONY: all clean kernel

