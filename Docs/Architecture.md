# Single-Cycle RISC-V Processor Architecture



# 1. Program Counter (PC)

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

# 2. Instruction Memory

## Description

The Instruction Memory stores the program instructions and provides a single read port.

The processor supplies a **32-bit instruction address**, and the memory
returns the corresponding **32-bit instruction**.

The memory is **word aligned**, therefore only address bits **[31:2]**
are used for indexing.

Instructions are initialized using the Verilog system task
`$readmemh()` from

```
Programs/instructions.mem
```

This memory is **read-only** during processor execution.


## Block Diagram

<img width="202" height="202" alt="image" src="https://github.com/user-attachments/assets/2c3e41c4-d7f0-4f49-a62b-6521b29fd413" />


## Inputs

| Signal | Width | Description |
|---------|------:|-------------|
| addr | 32 | Instruction Address |

## Outputs

| Signal | Width | Description |
|---------|------:|-------------|
| instruction | 32 | Instruction Word |

## Memory Organization

```
Address        Instruction

0x00000000 -> Instruction 0
0x00000004 -> Instruction 1
0x00000008 -> Instruction 2
0x0000000C -> Instruction 3
...
```

## Address Mapping

Since every instruction occupies **4 bytes**,

```
Memory Index = addr[31:2]
```

This ignores the two least significant bits because instructions are
always word aligned.

---

## Execution Flow

<img width="281" height="212" alt="image" src="https://github.com/user-attachments/assets/29426b90-e912-4d92-924c-c6f38b094cdf" />

# 3. Register File

## Description

The Register File contains thirty-two 32-bit general-purpose registers
(`x0`–`x31`).

It provides:

- Two asynchronous read ports
- One synchronous write port

Register `x0` is hardwired to zero. Any attempt to write to `x0` is ignored.

## Inputs

| Signal | Width | Description |
|---------|------:|-------------|
| clk | 1 | System Clock |
| we | 1 | Write Enable |
| rs1 | 5 | Read Address 1 |
| rs2 | 5 | Read Address 2 |
| rd | 5 | Write Address |
| write_data | 32 | Data to be written |

## Outputs

| Signal | Width | Description |
|---------|------:|-------------|
| read_data1 | 32 | Data from `rs1` |
| read_data2 | 32 | Data from `rs2` |

## Features

- 32 × 32-bit registers
- Two asynchronous read ports
- One synchronous write port
- `x0` always returns zero
- Writes to `x0` are ignored

## References

Digital Design and Computer Architecture: RISC-V Edition

Sarah L. Harris

David Money Harris

