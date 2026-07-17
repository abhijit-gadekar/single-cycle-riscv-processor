`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project : Single-Cycle RISC-V Processor
// Module  : top
// Description:
// Top-level wrapper for the Single-Cycle RV32I Processor.
//
// Instantiates:
//  - riscv_core
//
//////////////////////////////////////////////////////////////////////////////////

module top(

    input wire clk,
    input wire reset

);

    //----------------------------------------------------------
    // RISC-V Core
    //----------------------------------------------------------

    riscv_core riscv_core_inst(

        .clk(clk),
        .reset(reset)

    );

endmodule
