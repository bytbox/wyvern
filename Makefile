include make.config

all: wyvern.img

wyvern.img: kernel/wyvern.kernel
	${CAT} kernel/wyvern.kernel > $@

kernel/wyvern.kernel: 
	make -Ckernel

clean:
	${RM} wyvern.img
	make -Ckernel clean

.PHONY: all clean

