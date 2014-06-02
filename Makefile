#!/usr/bin/make

CC = g++
CFLAGS = --std=c++0x -Wall -O2 -c -m32 \
	-I/usr/include/x86_64-linux-gnu/c++/4.8/

TARGET = haribote
IPL = ipl
BOOTPACK = bootpack
OBJS = crt.o bootpack.o asmfunc.o
ASMHEAD = asmhead

${TARGET}.bin: ${IPL} ${ASMHEAD} ${BOOTPACK}
	dd if=/dev/zero of=$@ bs=512 count=2880 >/dev/null 2>&1
	dd if=${IPL} of=$@ conv=notrunc bs=512 count=1 seek=0 >/dev/null 2>&1 
	dd if=${ASMHEAD} of=$@ conv=notrunc seek=1 >/dev/null 2>&1
	dd if=${BOOTPACK} of=$@ conv=notrunc seek=2 >/dev/null 2>&1

${IPL}: ${IPL}.o ${IPL}.ls
	ld -T ${IPL}.ls -o $@ ${IPL}.o \
	-Map ${IPL}.map --cref

${ASMHEAD}: ${ASMHEAD}.o ${ASMHEAD}.ls
	ld -T ${ASMHEAD}.ls -o $@ ${ASMHEAD}.o \
	-Map ${ASMHEAD}.map --cref

${BOOTPACK}: ${OBJS} ${BOOTPACK}.ls
	ld -T ${BOOTPACK}.ls -o $@ ${OBJS} \
	-Map ${BOOTPACK}.map --cref

%.o: %.S Makefile
	${CC} ${CFLAGS} $<

%.o: %.c Makefile
	${CC} ${CFLAGS} $<

clean:
	rm -f *.o *.map ${IPL} ${ASMHEAD} ${BOOTPACK} ${TARGET}.bin

.PHONY: all clean
