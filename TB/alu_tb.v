`timescale 1ns / 1ps

module alu_tb;

    //----------------------------------------------------------
    // Testbench Signals
    //----------------------------------------------------------
    reg  [31:0] A;
    reg  [31:0] B;
    reg  [3:0]  ALUControl;

    wire [31:0] Result;
    wire        Zero;
    wire        Negative;
    wire        Carry;
    wire        Overflow;

    //----------------------------------------------------------
    // DUT
    //----------------------------------------------------------
    alu dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero),
        .Negative(Negative),
        .Carry(Carry),
        .Overflow(Overflow)
    );

    //----------------------------------------------------------
    // Test Counters
    //----------------------------------------------------------
    integer total_tests  = 0;
    integer passed_tests = 0;
    integer failed_tests = 0;

    //----------------------------------------------------------
    // Task : Check Result
    //----------------------------------------------------------
    task check_result;
        input [31:0] expected;
        begin
            total_tests = total_tests + 1;

            if (Result === expected) begin
                $display("[PASS] ALUControl=%b A=%h B=%h Result=%h",
                         ALUControl, A, B, Result);
                passed_tests = passed_tests + 1;
            end
            else begin
                $display("[FAIL] ALUControl=%b A=%h B=%h Expected=%h Got=%h",
                         ALUControl, A, B, expected, Result);
                failed_tests = failed_tests + 1;
            end
        end
    endtask

    //----------------------------------------------------------
    // Test Sequence
    //----------------------------------------------------------
    initial begin

        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        $display("--------------------------------------------");
        $display(" RV32I ALU Verification");
        $display("--------------------------------------------");

        //------------------------------
        // ADD
        //------------------------------
        A = 32'd20;
        B = 32'd10;
        ALUControl = 4'b0000;
        #5;
        check_result(32'd30);

        //------------------------------
        // SUB
        //------------------------------
        A = 32'd20;
        B = 32'd10;
        ALUControl = 4'b0001;
        #5;
        check_result(32'd10);

        //------------------------------
        // AND
        //------------------------------
        A = 32'hF0F0F0F0;
        B = 32'h0FF00FF0;
        ALUControl = 4'b0010;
        #5;
        check_result(32'h00F000F0);

        //------------------------------
        // OR
        //------------------------------
        ALUControl = 4'b0011;
        #5;
        check_result(32'hFFF0FFF0);

        //------------------------------
        // XOR
        //------------------------------
        ALUControl = 4'b0100;
        #5;
        check_result(32'hFF00FF00);

        //------------------------------
        // SLT (Signed)
        //------------------------------
        A = -10;
        B = 5;
        ALUControl = 4'b0101;
        #5;
        check_result(32'd1);

        //------------------------------
        // SLTU (Unsigned)
        //------------------------------
        A = 32'h00000001;
        B = 32'hFFFFFFFF;
        ALUControl = 4'b0110;
        #5;
        check_result(32'd1);

        //------------------------------
        // SLL
        //------------------------------
        A = 32'h00000001;
        B = 32'd4;
        ALUControl = 4'b0111;
        #5;
        check_result(32'h00000010);

        //------------------------------
        // SRL
        //------------------------------
        A = 32'h80000000;
        B = 32'd4;
        ALUControl = 4'b1000;
        #5;
        check_result(32'h08000000);

        //------------------------------
        // SRA
        //------------------------------
        A = 32'h80000000;
        B = 32'd4;
        ALUControl = 4'b1001;
        #5;
        check_result(32'hF8000000);

        //------------------------------
        // LUI
        //------------------------------
        A = 32'h00000000;
        B = 32'h12345000;
        ALUControl = 4'b1010;
        #5;
        check_result(32'h12345000);

        //------------------------------
        // AUIPC
        //------------------------------
        A = 32'h00001000;
        B = 32'h00002000;
        ALUControl = 4'b1011;
        #5;
        check_result(32'h00003000);

        //----------------------------------------------------------
        // Flags
        //----------------------------------------------------------

        // Zero Flag
        A = 32'd5;
        B = 32'd5;
        ALUControl = 4'b0001;
        #5;

        if (Zero)
            $display("[PASS] Zero Flag");
        else begin
            $display("[FAIL] Zero Flag");
            failed_tests = failed_tests + 1;
        end

        // Negative Flag
        A = 32'd5;
        B = 32'd10;
        ALUControl = 4'b0001;
        #5;

        if (Negative)
            $display("[PASS] Negative Flag");
        else begin
            $display("[FAIL] Negative Flag");
            failed_tests = failed_tests + 1;
        end

        //----------------------------------------------------------
        // Summary
        //----------------------------------------------------------
        $display("--------------------------------------------");
        $display(" Total Tests : %0d", total_tests);
        $display(" Passed      : %0d", passed_tests);
        $display(" Failed      : %0d", failed_tests);
        $display("--------------------------------------------");

        if (failed_tests == 0)
            $display(" ALL TESTS PASSED ");
        else
            $display(" SOME TESTS FAILED ");

        $display("--------------------------------------------");

        $finish;

    end

endmodule
