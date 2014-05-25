#!/usr/bin/make

CC = gcc
CFLAGS = -Wall -O2 -c

TARGET = helloos

all:
	$(MAKE) $(AM_MAKEFLAGS) ${TARGET}.bin

${TARGET}: ${TARGET}.o ${TARGET}.ls
	ld -T ${TARGET}.ls -o ${TARGET} ${TARGET}.o -Map ${TARGET}.map --cref

${TARGET}.bin: ${TARGET}
	dd if=/dev/zero of=$@ bs=512 count=2880 &> /dev/null
	dd if=${TARGET} of=$@ bs=512 count=1 &> /dev/null

clean:
	rm -f *.o *.map ${TARGET}.bin ${TARGET}

%.o: %.S Makefile
	${CC} ${CFLAGS} $<

.PHONY: all clean
