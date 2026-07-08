# Program Counter (PC)

## Overview

The Program Counter (PC) is a 32-bit register that stores the address of the instruction currently being executed.

At every rising edge of the clock, the PC loads the address of the next instruction (`pc_next`).

During reset, the PC is cleared to address **0x00000000**.

---

## Block Diagram

<img width="146" height="147" alt="image" src="https://github.com/user-attachments/assets/87137ca0-5d9c-482b-9ec4-da40d2ad5f50" />


---

## Inputs

| Signal | Width | Description |
|---------|------:|-------------|
| clk | 1 | System clock |
| rst | 1 | Active-high synchronous reset |
| pc_next | 32 | Address of next instruction |

---

## Outputs

| Signal | Width | Description |
|---------|------:|-------------|
| pc | 32 | Current instruction address |

---

## Operation

```
if (rst)
    pc = 0;
else
    pc = pc_next;
```

---

## RTL File

```
RTL/program_counter.v
```

---

## References

Digital Design and Computer Architecture: RISC-V Edition

Sarah L. Harris

David Money Harris
