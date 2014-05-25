.intel_syntax noprefix

#define INIT_SEG 0x07c0

.file "helloos.S"

.code16gcc

.section .rodata

msg1:
.string "hello,world"

.text
main:
	cli
	mov ax, 0
	mov ds, ax
	mov es, ax
	mov sp, INIT_SEG
	mov ss, ax
	sti

	mov al, 0x0a
	mov ah, 0x0e
	mov bx, 7
	int 0x10
	
	mov si, offset msg1
putloop:
	mov al, [si]
	inc si
	cmp al, 0
	je fin
	mov ah, 0x0e
	mov bx, 7
	int 0x10
	jmp putloop

fin:
	hlt
	jmp fin

.section .sign
sign:
.byte 0x55
.byte 0xaa
