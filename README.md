# Single-Cycle RISC-V Processor

A **32-bit Single-Cycle RV32I Processor** implemented in **Verilog HDL**, following the architecture described in:

> **Digital Design and Computer Architecture: RISC-V Edition**  
> *Sarah L. Harris and David Money Harris*

The project implements the complete datapath and control unit of a single-cycle RISC-V processor, along with a comprehensive self-checking verification environment and an automated regression framework.

---

# Project Overview

This project implements a complete **RV32I Single-Cycle Processor** from scratch using synthesizable Verilog HDL.

The processor executes every instruction in **one clock cycle**, making it an excellent platform for learning:

- Computer Architecture
- RTL Design
- Digital Logic Design
- Processor Microarchitecture
- ASIC Design Flow
- FPGA Design Flow

The design is modular, fully synthesizable, and suitable as a starting point for pipelined processor development and ASIC implementation.

---

# Processor Architecture

<p align="center">
<img src="https://github.com/user-attachments/assets/e38d738a-0e5a-4d78-832e-15261c7c3d3b" width="900">
</p>

A detailed description of the architecture is available in **Architecture.md**.

---

# Features

- RV32I Base Integer ISA
- 32-bit Single-Cycle Processor
- Harvard Architecture
- Modular RTL Design
- Hierarchical Datapath and Control Unit
- Synthesizable Verilog HDL
- Self-Checking Testbench
- Automated Regression Framework
- ASIC-Friendly RTL
- OpenLane / SKY130 Ready

---

# Supported Instructions

### Arithmetic

- ADD
- ADDI
- SUB

### Logical

- AND
- ANDI
- OR
- ORI
- XOR
- XORI

### Shift

- SLL
- SLLI
- SRL
- SRLI
- SRA
- SRAI

### Comparison

- SLT
- SLTU
- SLTI
- SLTIU

### Memory

- LW
- SW

### Branch

- BEQ
- BNE
- BLT
- BGE
- BLTU
- BGEU

### Jump

- JAL
- JALR

---

# Verification

The processor is verified using a reusable self-checking testbench.

Regression Suite:

- ✅ Basic
- ✅ Logic
- ✅ Shift
- ✅ Compare
- ✅ Memory
- ✅ Branch
- ✅ Jump
- ✅ Immediate
- ✅ Edge Cases
- ✅ Stress

```
========================================
Regression Summary
========================================

Passed : 10
Failed : 0
```

---

# Repository Structure

```
.
single-cycle-riscv-processor/
│
├── README.md                    # Project overview
├── LICENSE                      # License
├── .gitignore                   # Git ignore rules
│
├── Docs/
│   └── Architecture.md          # Processor architecture documentation
│
├── RTL/                         # RTL source files
│   ├── alu.v
│   ├── alu_decoder.v
│   ├── alu_mux.v
│   ├── control_unit.v
│   ├── data_memory.v
│   ├── datapath.v
│   ├── immediate_extend.v
│   ├── instruction_memory.v
│   ├── main_decoder.v
│   ├── pc_mux.v
│   ├── pc_target.v
│   ├── program_counter.v
│   ├── register_file.v
│   ├── result_mux.v
│   ├── riscv_core.v
│   └── top.v
│
├── Programs/                    # RV32I assembly programs
│   ├── basic_test.S
│   ├── logic_test.S
│   ├── shift_test.S
│   ├── compare_test.S
│   ├── memory_test.S
│   ├── branch_test.S
│   ├── jump_test.S
│   ├── immediate_test.S
│   ├── edge_test.S
│   ├── stress_test.S
│   ├── test_program.S
│   └── instructions.mem         # Generated instruction memory image
│
├── TB/                          # Verification environment
│   ├── alu_tb.v
│   ├── alu_decoder_tb.v
│   ├── control_unit_tb.v
│   ├── data_memory_tb.v
│   ├── immediate_extend_tb.v
│   ├── instruction_memory_tb.v
│   ├── main_decoder_tb.v
│   ├── program_counter_tb.v
│   ├── register_file_tb.v
│   ├── riscv_core_tb.v
│   ├── common_defs.vh
│   ├── common_tasks.vh
│   ├── common_utils.vh
│   └── tests/
│       ├── basic_test.vh
│       ├── logic_test.vh
│       ├── shift_test.vh
│       ├── compare_test.vh
│       ├── memory_test.vh
│       ├── branch_test.vh
│       ├── jump_test.vh
│       ├── immediate_test.vh
│       ├── edge_test.vh
│       ├── stress_test.vh
│       └── current_test.vh
│
├── SIM/
│   └── run.sh                   # Automated regression script
│
├── Results/                     # Simulation and implementation results
│
└── OpenLane/                    # RTL-to-GDSII flow (future)
```

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

# Running the Regression Suite

Run an individual test:

```bash
./SIM/run.sh basic
```

or execute the complete regression suite:

```bash
./SIM/run.sh all
```

---

# Design Flow

The project follows a standard digital design flow:

```
Architecture
      │
RTL Design
      │
Functional Verification
      │
Regression Testing
      │
Logic Synthesis
      │
Floorplanning
      │
Placement
      │
Clock Tree Synthesis
      │
Routing
      │
DRC / LVS
      │
GDSII
```

The RTL has been functionally verified and is ready for RTL-to-GDSII implementation using the **SkyWater SKY130 PDK** and **OpenLane 2**.

---

# Future Work

- RTL-to-GDSII implementation (OpenLane 2)
- Timing Analysis
- Power Analysis
- DRC/LVS Clean Layout

---

# References

1. Sarah L. Harris and David Money Harris, **Digital Design and Computer Architecture: RISC-V Edition**
2. The RISC-V Instruction Set Manual, Volume I: Unprivileged ISA
3. SkyWater SKY130 PDK
4. OpenLane 2
