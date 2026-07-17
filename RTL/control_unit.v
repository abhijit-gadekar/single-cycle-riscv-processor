`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : control_unit
// Description : RV32I Control Unit
//
// Combines:
//  - Main Decoder
//  - ALU Decoder
//
// Generates all processor control signals.
//
//////////////////////////////////////////////////////////////////////////////////

module control_unit(

    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire       funct7b5,

    input  wire       Zero,

    output wire       RegWrite,
    output wire [2:0] ImmSrc,
    output wire       ALUSrc,
    output wire       MemWrite,
    output wire [1:0] ResultSrc,
    output wire       Branch,
    output wire       Jump,

    output wire [3:0] ALUControl,
    output wire       PCSrc

);

    //----------------------------------------------------------
    // Internal Signals
    //----------------------------------------------------------
    wire [1:0] ALUOp;

    //----------------------------------------------------------
    // Main Decoder
    //----------------------------------------------------------
    main_decoder main_decoder_inst (

        .opcode(opcode),

        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)

    );

    //----------------------------------------------------------
    // ALU Decoder
    //----------------------------------------------------------
    alu_decoder alu_decoder_inst (

        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .opb5(opcode[5]),

        .ALUControl(ALUControl)

    );

    //----------------------------------------------------------
    // Next PC Selection
    //----------------------------------------------------------
    assign PCSrc = (Branch & Zero) | Jump;

endmodule
