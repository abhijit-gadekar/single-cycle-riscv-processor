.section .text
.globl _start

_start:

    addi x1,x0,25
    addi x2,x0,50
    addi x3,x0,75

    sw x1,0(x0)
    sw x2,4(x0)
    sw x3,8(x0)

    lw x4,0(x0)
    lw x5,4(x0)
    lw x6,8(x0)

done:
    beq x0,x0,done
