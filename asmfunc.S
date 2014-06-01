# -*- coding:utf-8 -*-
.intel_syntax noprefix
.file "asmfunc.S"

.code32

.globl io_hlt
io_hlt:
	hlt
	ret
