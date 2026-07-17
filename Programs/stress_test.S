.section .text
.globl _start

_start:

    addi x1,x0,10
    addi x2,x0,20

    add x3,x1,x2
    sub x4,x2,x1

    and x5,x1,x2
    or  x6,x1,x2
    xor x7,x1,x2

    sll x8,x1,x1
    srl x9,x2,x1

    slt x10,x1,x2

    sw x3,0(x0)
    lw x11,0(x0)

    beq x3,x11,PASS

    addi x12,x0,111

PASS:

    jal x0,DONE

    addi x13,x0,111

DONE:

done:
    beq x0,x0,done
