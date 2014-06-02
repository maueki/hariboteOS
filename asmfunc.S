# -*- coding:utf-8 -*-
.intel_syntax noprefix
.file "asmfunc.S"

.code32

.globl io_hlt
io_hlt:
	hlt
	ret

.globl write_mem8

write_mem8:// void write_mem8(int addr, int data)
	mov ecx, [esp+4]// addrをecxへ
	mov al , [esp+8]// dataをalへ
	mov BYTE [ecx], al
	ret
