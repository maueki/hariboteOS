#!/usr/bin/make

CC=gcc
CFLAGS=-Wall -O2 -c -m32

RUSTC=rustc
TARGET=haribote
IPL=ipl
BOOTPACK=bootpack
OBJS=bootpack.o crt.o asmfunc.o
ASMHEAD=asmhead
LD=i386-elf-ld
QEMU=qemu-system-i386

${TARGET}.bin: ${IPL} ${ASMHEAD} ${BOOTPACK}
	dd if=/dev/zero of=$@ bs=512 count=2880 >/dev/null 2>&1
	dd if=${IPL} of=$@ conv=notrunc bs=512 count=1 seek=0 >/dev/null 2>&1 
	dd if=${ASMHEAD} of=$@ conv=notrunc seek=1 >/dev/null 2>&1
	dd if=${BOOTPACK} of=$@ conv=notrunc seek=2 >/dev/null 2>&1

${IPL}: ${IPL}.o ${IPL}.ls
	${LD} -T ${IPL}.ls -o $@ ${IPL}.o \
	-Map ${IPL}.map --cref

${ASMHEAD}: ${ASMHEAD}.o ${ASMHEAD}.ls
	${LD} -T ${ASMHEAD}.ls -o $@ ${ASMHEAD}.o \
	-Map ${ASMHEAD}.map --cref

${BOOTPACK}: ${OBJS} ${BOOTPACK}.ls
	${LD} -T ${BOOTPACK}.ls -o $@ ${OBJS} \
	-Map ${BOOTPACK}.map --cref

.SUFFIXES: .o .rs .S

.S.o:
	${CC} ${CFLAGS} $<

.rs.o:
	${RUSTC} -O --target=i686-unknown-linux-gnu  -C relocation-model=static --crate-type lib -o $@ --emit obj $<

clean:
	rm -f *.o *.map ${IPL} ${ASMHEAD} ${BOOTPACK} ${TARGET}.bin

run: ${TARGET}.bin
	${QEMU} -fda $<

.PHONY: all clean
