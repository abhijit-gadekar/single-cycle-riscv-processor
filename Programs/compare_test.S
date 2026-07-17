.section .text
.globl _start

_start:

    addi x1, x0, 5
    addi x2, x0, 10
    addi x3, x0, -1

    slt  x4, x1, x2
    slt  x5, x2, x1
    slt  x6, x3, x1

    sltu x7, x1, x2
    sltu x8, x3, x1

    slti  x9,  x1, 6
    slti  x10, x2, 6

    sltiu x11, x1, 6
    sltiu x12, x3, 1

done:
    beq x0,x0,done
