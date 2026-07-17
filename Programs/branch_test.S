.section .text
.globl _start

_start:

    addi x1, x0, 10
    addi x2, x0, 5

    bgeu x1, x2, PASS

    addi x3, x0, 111

PASS:
    addi x4, x0, 99

done:
    beq x0, x0, done
