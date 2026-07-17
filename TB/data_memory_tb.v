`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : data_memory_tb
// Description : Self-checking testbench for Data Memory
//////////////////////////////////////////////////////////////////////////////////

module data_memory_tb;

    //----------------------------------------------------------
    // Testbench Signals
    //----------------------------------------------------------
    reg         clk;
    reg         MemWrite;
    reg  [31:0] addr;
    reg  [31:0] write_data;

    wire [31:0] read_data;

    //----------------------------------------------------------
    // DUT
    //----------------------------------------------------------
    data_memory dut (
        .clk(clk),
        .MemWrite(MemWrite),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    //----------------------------------------------------------
    // Clock Generation
    //----------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //----------------------------------------------------------
    // Test Counters
    //----------------------------------------------------------
    integer total_tests  = 0;
    integer passed_tests = 0;
    integer failed_tests = 0;

    //----------------------------------------------------------
    // Check Task
    //----------------------------------------------------------
    task check_read;
        input [31:0] expected;
        begin
            total_tests = total_tests + 1;

            #1;

            if (read_data === expected) begin
                passed_tests = passed_tests + 1;
                $display("[PASS] Addr = %h Read = %h", addr, read_data);
            end
            else begin
                failed_tests = failed_tests + 1;
                $display("[FAIL] Addr = %h Expected = %h Got = %h",
                         addr, expected, read_data);
            end
        end
    endtask

    //----------------------------------------------------------
    // Test Sequence
    //----------------------------------------------------------
    initial begin

        $dumpfile("data_memory.vcd");
        $dumpvars(0, data_memory_tb);

        $display("--------------------------------------------");
        $display(" Data Memory Verification");
        $display("--------------------------------------------");

        //------------------------------------------------------
        // Initialize Memory (for simulation only)
        //------------------------------------------------------
        dut.memory[0] = 32'h12345678;
        dut.memory[1] = 32'hDEADBEEF;
        dut.memory[2] = 32'hCAFEBABE;

        //------------------------------------------------------
        // Test 1 : Read Existing Data
        //------------------------------------------------------
        MemWrite = 0;
        addr = 32'h00000000;
        check_read(32'h12345678);

        addr = 32'h00000004;
        check_read(32'hDEADBEEF);

        addr = 32'h00000008;
        check_read(32'hCAFEBABE);

        //------------------------------------------------------
        // Test 2 : Write New Data
        //------------------------------------------------------
        addr       = 32'h0000000C;
        write_data = 32'hA5A5A5A5;
        MemWrite   = 1;

        @(posedge clk);
	#1;
        MemWrite = 0;
	#1;
        check_read(32'hA5A5A5A5);

        //------------------------------------------------------
        // Test 3 : Write Disabled
        //------------------------------------------------------
        addr       = 32'h00000010;
        write_data = 32'hFFFFFFFF;
        MemWrite   = 0;

        @(posedge clk);

        check_read(32'hxxxxxxxx);

        //------------------------------------------------------
        // Test 4 : Word Alignment
        //------------------------------------------------------
        addr = 32'h00000001;
        check_read(32'h12345678);

        addr = 32'h00000002;
        check_read(32'h12345678);

        addr = 32'h00000003;
        check_read(32'h12345678);

        addr = 32'h00000004;
        check_read(32'hDEADBEEF);

        //------------------------------------------------------
        // Summary
        //------------------------------------------------------
        $display("--------------------------------------------");
        $display(" Total Tests : %0d", total_tests);
        $display(" Passed      : %0d", passed_tests);
        $display(" Failed      : %0d", failed_tests);
        $display("--------------------------------------------");

        if (failed_tests == 0)
            $display(" ALL TESTS PASSED");
        else
            $display(" SOME TESTS FAILED");

        $display("--------------------------------------------");

        $finish;

    end

endmodule
