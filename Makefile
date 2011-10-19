include make.config

all: wyvern.img

wyvern.img: kernel
	${CAT} kernel/wyvern.kernel > $@

bin2c:
	make -Ctools/bin2c

kernel: bin2c
	make -Ckernel

clean:
	${RM} wyvern.img
	make -Ckernel clean
	make -Ctools/bin2c clean

.PHONY: all clean kernel bin2c

