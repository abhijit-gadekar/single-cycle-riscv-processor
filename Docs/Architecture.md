# Single-Cycle RV32I Processor Architecture

## Overview

This project implements a **32-bit Single-Cycle RISC-V (RV32I) Processor** in Verilog HDL.

The processor executes every instruction in **one clock cycle**, meaning instruction fetch, decode, execute, memory access, and write-back all occur within the same cycle.

The design follows the RV32I base integer instruction set and is organized as a modular datapath and control unit.

---

# Top-Level Architecture

<p align="center">
<img src="https://github.com/user-attachments/assets/e38d738a-0e5a-4d78-832e-15261c7c3d3b" width="900">
</p>

---

# Processor Specifications

| Parameter | Value |
|-----------|-------|
| ISA | RV32I |
| Architecture | Single Cycle |
| Data Width | 32 bits |
| Address Width | 32 bits |
| Register Count | 32 |
| Register Width | 32 bits |
| Register x0 | Hardwired to Zero |
| Memory | Word Addressed |
| Endianness | Little Endian |
| Clocking | Single Clock |

---

# Datapath

The datapath performs all arithmetic and data movement operations.

It contains:

- Program Counter
- Instruction Memory
- Register File
- Immediate Generator
- ALU Operand Multiplexer
- ALU
- Data Memory
- Result Multiplexer
- PC Target Adder
- PC Selection Multiplexer

---

## Program Counter

Maintains the address of the current instruction.

### Inputs

- clk
- reset
- pc_next

### Output

- pc

Behavior

```
reset -> PC = 0

otherwise

PC <- pc_next
```

---

## Instruction Memory

Instruction memory stores the machine code program.

Input

```
Address = PC
```

Output

```
32-bit Instruction
```

The memory is initialized using

```
$readmemh("instructions.mem")
```

during simulation.

---

## Register File

Contains the 32 architectural registers.

```
x0
x1
...
x31
```

Features

- Two read ports
- One write port
- x0 is constant zero
- Synchronous write
- Asynchronous read

---

## Immediate Generator

Generates properly sign-extended immediates.

Supported instruction formats

- I-Type
- S-Type
- B-Type
- U-Type
- J-Type

Outputs a 32-bit immediate.

---

## ALU Operand Multiplexer

Selects the second ALU operand.

```
ALUSrc = 0

Operand B = Register rs2
```

```
ALUSrc = 1

Operand B = Immediate
```

---

## Arithmetic Logic Unit

Performs all arithmetic and logical operations.

Supported operations

- ADD
- SUB
- AND
- OR
- XOR
- SLL
- SRL
- SRA
- SLT
- SLTU

Status Flags

- Zero
- Negative
- Carry
- Overflow

---

## Data Memory

Supports

- LW
- SW

Interface

```
Address

Write Data

Read Data

MemWrite
```

---

## Result Multiplexer

Selects the data written back into the register file.

Possible sources

- ALU Result
- Data Memory
- PC + 4

---

## PC Target Adder

Computes

```
PC Target

=

Current PC

+

Immediate
```

Used for

- Branches
- Jumps

---

## PC Multiplexer

Selects the next PC.

```
PCNext

=

PC+4

or

Branch Target
```

Selected using

```
PCSrc
```

---

# Control Unit

The control unit generates all control signals.

It consists of

```
Main Decoder

+

ALU Decoder
```

---

## Main Decoder

Decodes the opcode.

Generates

- RegWrite
- ALUSrc
- MemWrite
- ResultSrc
- Branch
- Jump
- ImmSrc
- ALUOp

---

## ALU Decoder

Uses

- funct3
- funct7
- opcode class

to generate

```
ALUControl
```

Supported operations

| ALUControl | Operation |
|------------|-----------|
|0000|ADD|
|0001|SUB|
|0010|AND|
|0011|OR|
|0100|XOR|
|0101|SLT|
|0110|SLTU|
|0111|SLL|
|1000|SRL|
|1001|SRA|

---

## Branch Decision Logic

Supported branch instructions

- BEQ
- BNE
- BLT
- BGE
- BLTU
- BGEU

Decision uses

- Zero
- Negative
- Carry
- Overflow

---

# Instruction Flow

Every instruction executes completely in one clock cycle.

```
Instruction Fetch

↓

Instruction Decode

↓

Register Read

↓

Immediate Generation

↓

Execute

↓

Memory Access

↓

Write Back

↓

Next Instruction
```

---

# Supported RV32I Instructions

## Arithmetic

- ADD
- ADDI
- SUB

---

## Logical

- AND
- ANDI
- OR
- ORI
- XOR
- XORI

---

## Shift

- SLL
- SLLI
- SRL
- SRLI
- SRA
- SRAI

---

## Comparison

- SLT
- SLTU
- SLTI
- SLTIU

---

## Memory

- LW
- SW

---

## Branch

- BEQ
- BNE
- BLT
- BGE
- BLTU
- BGEU

---

## Jump

- JAL
- JALR

---

# RTL Module Hierarchy

```
top

└── riscv_core

    ├── control_unit

    │   ├── main_decoder

    │   └── alu_decoder

    │

    └── datapath

        ├── program_counter

        ├── instruction_memory

        ├── register_file

        ├── immediate_extend

        ├── alu_mux

        ├── alu

        ├── data_memory

        ├── result_mux

        ├── pc_target

        └── pc_mux
```

---

# Verification

The processor is verified using a self-checking Verilog testbench.

Regression suite includes

- Basic Arithmetic
- Logic Operations
- Shift Operations
- Comparison Instructions
- Memory Operations
- Branch Instructions
- Jump Instructions
- Immediate Instructions
- Edge Cases
- Mixed Stress Program

Regression Result

```
Passed : 10

Failed : 0
```

---

# Design Characteristics

- Modular RTL
- Hierarchical architecture
- Fully synthesizable RTL
- Self-checking verification
- Automated regression framework
- RV32I compliant instruction subset
- Suitable for ASIC and FPGA implementation

---

# Future Work

- RTL-to-GDSII implementation using OpenLane and SKY130
