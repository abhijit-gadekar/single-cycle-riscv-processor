`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Project : Single-Cycle RISC-V Processor
// Module  : Program Counter Testbench
// File    : program_counter_tb.v
// Description: Testbench for the Program Counter.
//////////////////////////////////////////////////////////////////////////////////

module program_counter_tb;

    // Testbench Signals
    reg         clk;
    reg         rst;
    reg  [31:0] pc_next;
    wire [31:0] pc;

    //=========================================================
    // Device Under Test (DUT)
    //=========================================================
    program_counter dut (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc)
    );

    //=========================================================
    // Clock Generation (100 MHz)
    //=========================================================
    initial
        clk = 0;

    always #5 clk = ~clk;

    //=========================================================
    // Waveform Dump
    //=========================================================
    initial begin
        $dumpfile("program_counter.vcd");
        $dumpvars(0, program_counter_tb);
    end

    //=========================================================
    // Self-Checking Task
    //=========================================================
    task check_pc;

        input [31:0] expected;

        begin
            #1;    // Wait for non-blocking assignment to update

            if (pc === expected)
                $display("[PASS] Time=%0t  Expected=%h  Got=%h",
                         $time, expected, pc);
            else
                $display("[FAIL] Time=%0t  Expected=%h  Got=%h",
                         $time, expected, pc);
        end

    endtask

    //=========================================================
    // Test Sequence
    //=========================================================
    initial begin

        $display("--------------------------------------------");
        $display("     Program Counter Verification");
        $display("--------------------------------------------");

        rst     = 1'b1;
        pc_next = 32'h00000000;

        //------------------------------------------------------
        // Test 1 : Reset
        //------------------------------------------------------
        @(posedge clk);
        check_pc(32'h00000000);

        //------------------------------------------------------
        // Test 2 : First PC Update
        //------------------------------------------------------
        rst     = 1'b0;
        pc_next = 32'h00000004;

        @(posedge clk);
        check_pc(32'h00000004);

        //------------------------------------------------------
        // Test 3 : Second PC Update
        //------------------------------------------------------
        pc_next = 32'h00000008;

        @(posedge clk);
        check_pc(32'h00000008);

        //------------------------------------------------------
        // Test 4 : Third PC Update
        //------------------------------------------------------
        pc_next = 32'h0000000C;

        @(posedge clk);
        check_pc(32'h0000000C);

        //------------------------------------------------------
        // Test 5 : Reset Again
        //------------------------------------------------------
        rst = 1'b1;

        @(posedge clk);
        check_pc(32'h00000000);

        $display("--------------------------------------------");
        $display("     Simulation Completed");
        $display("--------------------------------------------");

        $finish;

    end

endmodule
