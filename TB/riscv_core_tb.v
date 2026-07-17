`timescale 1ns/1ps

`include "common_defs.vh"

module riscv_core_tb;

reg clk;
reg reset;

//
// DUT
//
riscv_core dut (
    .clk(clk),
    .reset(reset)
);

//
// Include tasks AFTER the DUT so they can reference "dut"
//
`include "common_tasks.vh"
`include "common_utils.vh"

//
// Clock generation
//
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

//
// Main test
//
initial begin

    reset = 1'b0;

    $dumpfile("riscv_core.vcd");
    $dumpvars(0, riscv_core_tb);

    init_testbench();

    print_banner("RV32I BASIC TEST");

    reset_processor();

    run_cycles(50);

`include "tests/current_test.vh"

    report_results();

    $finish;

end

endmodule
