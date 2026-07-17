.section .text
.globl _start

_start:

    # x1 = 5
    addi x1, x0, 5

    # x2 = 10
    addi x2, x0, 10

    # x3 = x1 + x2 = 15
    add x3, x1, x2

    # x4 = x2 - x1 = 5
    sub x4, x2, x1

    # x5 = x1 & x2
    and x5, x1, x2

    # x6 = x1 | x2
    or x6, x1, x2

    # x7 = x1 ^ x2
    xor x7, x1, x2

    # x8 = (x2 < x1) ? 1 : 0
    slt x8, x2, x1

    # Store x3
    sw x3, 0(x0)

    # Load back
    lw x9, 0(x0)

    # Branch should be taken
    beq x9, x3, PASS

    addi x10, x0, 111

PASS:

    addi x11, x0, 55

LOOP:
    jal x0, LOOP
