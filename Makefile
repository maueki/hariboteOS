#!/usr/bin/make

CC=gcc
CFLAGS=-Wall -O2 -c -m32

RUSTC=rustc
TARGET=haribote
IPL=ipl
BOOTPACK=bootpack
LIBCORE:=libcore.rlib
OBJS=crt.o $(LIBCORE)
ASMHEAD=asmhead
LD=i386-elf-ld
QEMU=qemu-system-i386
WORK_DIR=$(HOME)/work
RUST_SRC=${WORK_DIR}/rustc-1.2.0-src.tar.gz
TARGETSPEC:=target.json

all: ${TARGET}.bin

UPDATE:
	curl https://static.rust-lang.org/dist/rustc-1.2.0-src.tar.gz -o ${RUST_SRC}

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
	${LD} --gc-sections -T ${BOOTPACK}.ls -o $@ ${OBJS} \
	-Map ${BOOTPACK}.map --cref

${WORK_DIR}/libcore/lib.rs: ${WORK_DIR}/rustc-1.2.0-src.tar.gz
	tar -xmf ${WORK_DIR}/rustc-1.2.0-src.tar.gz -C ${WORK_DIR} rustc-1.2.0/src/libcore --transform 's~^rustc-1.2.0/src/~~'

$(LIBCORE): ${WORK_DIR}/libcore/lib.rs Makefile
	$(RUSTC) -O --cfg arch__x86 --target=$(TARGETSPEC) -o $@ --crate-type=lib --emit=link,dep-info $<

.SUFFIXES: .o .rs .S

.S.o:
	${CC} ${CFLAGS} $<

crt.o: crt.rs bootpack.rs asmfunc.rs Makefile $(LIBCORE)
	${RUSTC} -O --target=$(TARGETSPEC) -C relocation-model=static --crate-type lib -o $@ --emit=obj,dep-info --extern core=$(LIBCORE) $<

clean:
	rm -f *.o *.map ${IPL} ${ASMHEAD} ${BOOTPACK} ${TARGET}.bin

run: ${TARGET}.bin
	${QEMU} -fda $<

.PHONY: all clean
