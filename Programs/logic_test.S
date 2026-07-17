    .section .text
    .globl _start

_start:

    # Load test operands
    addi x1, x0, 12          # x1 = 12 (0x0C)
    addi x2, x0, 10          # x2 = 10 (0x0A)

    # R-type logic
    and  x3, x1, x2          # x3 = 8
    or   x4, x1, x2          # x4 = 14
    xor  x5, x1, x2          # x5 = 6

    # I-type logic
    andi x6, x1, 3           # x6 = 0
    ori  x7, x1, 1           # x7 = 13
    xori x8, x2, 15          # x8 = 5

done:
    beq x0, x0, done         # Infinite loop
