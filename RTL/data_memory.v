`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : data_memory
// Description : 64-word Data Memory for Single-Cycle RV32I Processor
//
// Features:
// - 32-bit word-addressable memory
// - Asynchronous read
// - Synchronous write
// - Word-aligned accesses
//
//////////////////////////////////////////////////////////////////////////////////

module data_memory #(

    parameter DEPTH = 64

)(

    input  wire        clk,
    input  wire        MemWrite,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,

    output wire [31:0] read_data

);

    //----------------------------------------------------------
    // Memory Array
    //----------------------------------------------------------

    reg [31:0] memory [0:DEPTH-1];

    //----------------------------------------------------------
    // Asynchronous Read
    //----------------------------------------------------------

    assign read_data = memory[addr[31:2]];

    //----------------------------------------------------------
    // Synchronous Write
    //----------------------------------------------------------

    always @(posedge clk) begin

        if (MemWrite)
            memory[addr[31:2]] <= write_data;

    end

endmodule
