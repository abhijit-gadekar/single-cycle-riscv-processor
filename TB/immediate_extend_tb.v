`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : immediate_extend_tb
// Description : Self-checking testbench for Immediate Extend Unit
//////////////////////////////////////////////////////////////////////////////////

module immediate_extend_tb;

    //----------------------------------------------------------
    // Testbench Signals
    //----------------------------------------------------------
    reg  [31:7] instruction;
    reg  [2:0]  ImmSrc;

    wire [31:0] immediate;

    //----------------------------------------------------------
    // DUT
    //----------------------------------------------------------
    immediate_extend dut (
        .instruction(instruction),
        .ImmSrc(ImmSrc),
        .immediate(immediate)
    );

    //----------------------------------------------------------
    // Test Counters
    //----------------------------------------------------------
    integer total_tests  = 0;
    integer passed_tests = 0;
    integer failed_tests = 0;

    //----------------------------------------------------------
    // Check Task
    //----------------------------------------------------------
    task check_immediate;
        input [31:0] expected;
        begin
            total_tests = total_tests + 1;

            #1;

            if (immediate === expected) begin
                passed_tests = passed_tests + 1;
                $display("[PASS] ImmSrc=%b Immediate=%h", ImmSrc, immediate);
            end
            else begin
                failed_tests = failed_tests + 1;
                $display("[FAIL] ImmSrc=%b Expected=%h Got=%h",
                         ImmSrc, expected, immediate);
            end
        end
    endtask

    //----------------------------------------------------------
    // Test Sequence
    //----------------------------------------------------------
    initial begin

        $dumpfile("immediate_extend.vcd");
        $dumpvars(0, immediate_extend_tb);

        $display("--------------------------------------------");
        $display(" Immediate Extend Verification");
        $display("--------------------------------------------");

        //------------------------------------------------------
        // I-Type : immediate = +10
        //------------------------------------------------------
        instruction = {20'h00A00, 5'b00000};
        ImmSrc = 3'b000;
        check_immediate(32'h0000000A);

        //------------------------------------------------------
        // S-Type : immediate = +20
        //------------------------------------------------------
        instruction = {7'b0000000,
                       5'b00000,
                       5'b00000,
                       3'b000,
                       5'b10100};
        ImmSrc = 3'b001;
        check_immediate(32'h00000014);

        //------------------------------------------------------
        // B-Type : immediate = +16
        //------------------------------------------------------
        instruction = {
            1'b0,          // bit31
            6'b000000,     // bits30:25
            5'b00000,      // rs2
            5'b00000,      // rs1
            3'b000,        // funct3
            4'b1000,       // bits11:8
            1'b0           // bit7
        };
        ImmSrc = 3'b010;
        check_immediate(32'h00000010);

        //------------------------------------------------------
        // U-Type : 0x12345000
        //------------------------------------------------------
        instruction = {20'h12345, 5'b00000};
        ImmSrc = 3'b011;
        check_immediate(32'h12345000);

        //------------------------------------------------------
        // J-Type : (0x004)
        //------------------------------------------------------
        instruction = {
    		1'b0,
    		10'b0000000010,
    		1'b0,
    		8'b00000000,
    		5'b00000
	};		
        ImmSrc = 3'b100;
        check_immediate(32'h00000004);

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
