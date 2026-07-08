`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Project : Single-Cycle RISC-V Processor
// Module  : Instruction Memory Testbench
// File    : instruction_memory_tb.v
// Description:
// Self-checking testbench for the Instruction Memory.
//////////////////////////////////////////////////////////////////////////////////

module instruction_memory_tb;

    //----------------------------------------------------------
    // Testbench Signals
    //----------------------------------------------------------

    reg  [31:0] addr;
    wire [31:0] instruction;

    //----------------------------------------------------------
    // Device Under Test
    //----------------------------------------------------------

    instruction_memory dut (
        .addr(addr),
        .instruction(instruction)
    );

    //----------------------------------------------------------
    // Waveform Dump
    //----------------------------------------------------------

    initial begin
        $dumpfile("instruction_memory.vcd");
        $dumpvars(0, instruction_memory_tb);
    end

    //----------------------------------------------------------
    // Self-Checking Task
    //----------------------------------------------------------

    task check_instruction;

        input [31:0] address;
        input [31:0] expected;

        begin

            addr = address;

            #1;

            if (instruction === expected)
                $display("[PASS] Address = %h | Instruction = %h",
                          address, instruction);

            else
                $display("[FAIL] Address = %h | Expected = %h | Got = %h",
                          address, expected, instruction);

        end

    endtask

    //----------------------------------------------------------
    // Test Sequence
    //----------------------------------------------------------

    initial begin

        $display("--------------------------------------------");
        $display(" Instruction Memory Verification");
        $display("--------------------------------------------");

        check_instruction(32'h00000000, 32'h0062E233);

        check_instruction(32'h00000004, 32'h0064A423);

        check_instruction(32'h00000008, 32'hFFC4A303);

        check_instruction(32'h0000000C, 32'hFE420AE3);

        $display("--------------------------------------------");
        $display(" Verification Completed");
        $display("--------------------------------------------");

        $finish;

    end

endmodule
