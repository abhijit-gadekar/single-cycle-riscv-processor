`timescale 1ns / 1ps

//////////////////////////////////////////////////////////
// Project: Single Cycle RISC-V Processor
// Module : Program COunter
// File   : program_counter.v
// Description: 32-bit Program COunter (PC)
// - Stores the address of the current instruction
// - Updates on every rising edge of the clock
// - Resets at 0x00000000
// - Synthesizable on FPGA and ASIC Flow
// Author : Abhijit Gadekar
//////////////////////////////////////////////////////////


module program_counter (

    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] pc_next,
    output reg  [31:0] pc

);

always @(posedge clk)
begin
    if (rst)
        pc <= 32'h00000000;
    else
        pc <= pc_next;
end

endmodule
