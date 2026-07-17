`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : alu_mux
// Description : ALU Operand B Multiplexer
//
// Selects the second ALU operand:
//
// ALUSrc = 0 -> Register File Read Data 2
// ALUSrc = 1 -> Sign-Extended Immediate
//
//////////////////////////////////////////////////////////////////////////////////

module alu_mux(

    input  wire [31:0] register_data,
    input  wire [31:0] immediate,
    input  wire        ALUSrc,

    output wire [31:0] alu_operand_b

);

    assign alu_operand_b = (ALUSrc) ? immediate : register_data;

endmodule
