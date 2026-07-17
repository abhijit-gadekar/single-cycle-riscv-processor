`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : pc_target
// Description : Branch / Jump Target Address Generator
//////////////////////////////////////////////////////////////////////////////////

module pc_target(

    input  wire [31:0] pc,
    input  wire [31:0] immediate,

    output wire [31:0] target

);

    assign target = pc + immediate;

endmodule
