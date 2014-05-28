#!/usr/bin/make

CC = gcc
CFLAGS = -Wall -O2 -c -m32

TARGET = haribote
IPL = ipl
HARIBOTE = haribote

${TARGET}.bin: ${IPL} ${HARIBOTE}
	dd if=/dev/zero of=$@ bs=512 count=2880 &> /dev/null
	dd if=${IPL} of=$@ conv=notrunc bs=512 count=1 seek=0 &> /dev/null
	dd if=${HARIBOTE} of=$@ conv=notrunc seek=1 &> /dev/null

${IPL}: ${IPL}.o ${IPL}.ls
	ld -T ${IPL}.ls -o $@ ${IPL}.o \
	-Map ${IPL}.map --cref

${HARIBOTE}: ${HARIBOTE}.o ${HARIBOTE}.ls
	ld -T ${HARIBOTE}.ls -o $@ ${HARIBOTE}.o \
	-Map ${HARIBOTE}.map --cref

%.o: %.S Makefile
	${CC} ${CFLAGS} $<

%.o: %.c Makefile
	${CC} ${CFLAGS} $<

clean:
	rm -f *.o *.map ${IPL} ${HRIBOTE} ${TARGET}.bin

.PHONY: all clean
