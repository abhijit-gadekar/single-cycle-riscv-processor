`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Project : Single-Cycle RISC-V Processor
// Module  : Instruction Memory
// File    : instruction_memory.v
// Description:
// Read-only instruction memory.
// - 32-bit address input
// - 32-bit instruction output
// - Word aligned
// - Initialized using $readmemh()
//
//////////////////////////////////////////////////////////////////////////////////

module instruction_memory #(
    parameter DEPTH = 64
)(
    input  wire [31:0] addr,
    output wire [31:0] instruction
);
    //----------------------------------------------------------
    // Memory Declaration
    //----------------------------------------------------------

    reg [31:0] memory [0:DEPTH-1];

    //----------------------------------------------------------
    // Initialize Memory
    //----------------------------------------------------------

    initial begin
        $readmemh("Programs/instructions.mem", memory);
    end

    //----------------------------------------------------------
    // Read Logic
    //----------------------------------------------------------

    assign instruction = memory[addr[31:2]];

endmodule
