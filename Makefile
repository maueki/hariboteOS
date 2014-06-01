#!/usr/bin/make

CC = g++
CFLAGS = --std=c++0x -Wall -O2 -c -m32

TARGET = haribote
IPL = ipl
BOOTPACK = bootpack
OBJS = crt.o bootpack.o asmfunc.o
ASMHEAD = asmhead

${TARGET}.bin: ${IPL} ${ASMHEAD} ${BOOTPACK}
	dd if=/dev/zero of=$@ bs=512 count=2880 &> /dev/null
	dd if=${IPL} of=$@ conv=notrunc bs=512 count=1 seek=0 &> /dev/null
	dd if=${ASMHEAD} of=$@ conv=notrunc seek=1 &> /dev/null
	dd if=${BOOTPACK} of=$@ conv=notrunc seek=2 &> /dev/null

${IPL}: ${IPL}.o ${IPL}.ls
	ld -T ${IPL}.ls -o $@ ${IPL}.o \
	-Map ${IPL}.map --cref

${ASMHEAD}: asmhead.o asmhead.ls
	ld -T asmhead.ls -o $@ asmhead.o \
	-Map ${ASMHEAD}.map --cref

${BOOTPACK}: ${OBJS} bootpack.ls
	ld -T bootpack.ls -o $@ ${OBJS} \
	-Map ${BOOTPACK}.map --cref

%.o: %.S Makefile
	${CC} ${CFLAGS} $<

%.o: %.c Makefile
	${CC} ${CFLAGS} $<

clean:
	rm -f *.o *.map ${IPL} ${ASMHEAD} ${BOOTPACK} ${TARGET}.bin

.PHONY: all clean
