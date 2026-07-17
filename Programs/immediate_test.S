.section .text
.globl _start

_start:

    addi x1,x0,12

    andi x2,x1,3
    ori  x3,x1,1
    xori x4,x1,15

    slli x5,x1,2
    srli x6,x5,1

    addi x7,x0,-16
    srai x8,x7,2

    slti x9,x1,20
    sltiu x10,x1,20

done:
    beq x0,x0,done
