`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project : Single-Cycle RISC-V Processor
// Module  : riscv_core
// Description:
// Top-level CPU Core
//
// Instantiates:
//  - Control Unit
//  - Datapath
//////////////////////////////////////////////////////////////////////////////////

module riscv_core(

    input wire clk,
    input wire reset

);

    //----------------------------------------------------------
    // Control Signals
    //----------------------------------------------------------

    wire        RegWrite;
    wire [2:0]  ImmSrc;
    wire        ALUSrc;
    wire [3:0]  ALUControl;
    wire        MemWrite;
    wire [1:0]  ResultSrc;
    wire        PCSrc;

    //----------------------------------------------------------
    // Status Signals
    //----------------------------------------------------------

    wire Zero;
    wire Negative;
    wire Carry;
    wire Overflow;
    //----------------------------------------------------------
    // Instruction Fields
    //----------------------------------------------------------

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire       funct7b5;

    //----------------------------------------------------------
    // Control Unit
    //----------------------------------------------------------

    control_unit control_unit_inst(

        .opcode(opcode),
        .funct3(funct3),
        .funct7b5(funct7b5),

        .Zero(Zero),
	.Negative(Negative),
	.Carry(Carry),
	.Overflow(Overflow),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(),
        .Jump(),

        .ALUControl(ALUControl),
        .PCSrc(PCSrc)

    );

    //----------------------------------------------------------
    // Datapath
    //----------------------------------------------------------

    datapath datapath_inst(

        .clk(clk),
        .reset(reset),

        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .PCSrc(PCSrc),

        .Zero(Zero),
        .Negative(Negative),
        .Carry(Carry),
        .Overflow(Overflow),
        .opcode(opcode),
        .funct3(funct3),
        .funct7b5(funct7b5)

    );

endmodule
