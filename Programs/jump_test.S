.section .text
.globl _start

_start:

    jal x1,FUNC

    addi x10,x0,111

FUNC:

    addi x2,x0,22

    jalr x0,0(x1)
