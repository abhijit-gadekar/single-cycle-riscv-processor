.section .text
.globl _start

_start:

    addi x0,x0,123

    addi x1,x0,-1

    slli x2,x1,31

    srli x3,x2,31

    srai x4,x1,31

    addi x5,x0,0

done:
    beq x0,x0,done
