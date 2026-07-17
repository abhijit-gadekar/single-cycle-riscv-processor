`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : pc_mux
// Description : Next Program Counter Multiplexer
//////////////////////////////////////////////////////////////////////////////////

module pc_mux(

    input  wire [31:0] pc_plus4,
    input  wire [31:0] pc_target,
    input  wire        PCSrc,

    output wire [31:0] pc_next

);

    assign pc_next = (PCSrc) ? pc_target : pc_plus4;

endmodule
