`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project : Single-Cycle RISC-V Processor
// Module  : Register File Testbench
// File    : register_file_tb.v
//
// Description:
// Self-checking testbench for the Register File.
//
//////////////////////////////////////////////////////////////////////////////////

module register_file_tb;

    //----------------------------------------------------------
    // Testbench Signals
    //----------------------------------------------------------

    reg         clk;
    reg         we;

    reg  [4:0]  rs1;
    reg  [4:0]  rs2;
    reg  [4:0]  rd;

    reg  [31:0] write_data;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    //----------------------------------------------------------
    // Device Under Test
    //----------------------------------------------------------

    register_file dut (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    //----------------------------------------------------------
    // Clock Generation
    //----------------------------------------------------------

    initial
        clk = 1'b0;

    always #5 clk = ~clk;

    //----------------------------------------------------------
    // Waveform Dump
    //----------------------------------------------------------

    initial begin
        $dumpfile("register_file.vcd");
        $dumpvars(0, register_file_tb);
    end

    //----------------------------------------------------------
    // Self-Checking Tasks
    //----------------------------------------------------------

    task write_register;

        input [4:0] reg_addr;
        input [31:0] data;

        begin
            @(negedge clk);

            we         = 1'b1;
            rd         = reg_addr;
            write_data = data;

            @(posedge clk);
            #1;

            we = 1'b0;
        end

    endtask

    task check_register;

        input [4:0] reg_addr;
        input [31:0] expected;

        begin

            rs1 = reg_addr;
            #1;

            if(read_data1 === expected)
                $display("[PASS] x%0d = %h", reg_addr, read_data1);
            else
                $display("[FAIL] x%0d Expected=%h Got=%h",
                          reg_addr, expected, read_data1);

        end

    endtask

    //----------------------------------------------------------
    // Test Sequence
    //----------------------------------------------------------

    initial begin

        $display("--------------------------------------------");
        $display(" Register File Verification");
        $display("--------------------------------------------");

        we         = 0;
        rs1        = 0;
        rs2        = 0;
        rd         = 0;
        write_data = 0;

        //------------------------------------------------------
        // Test 1 : x0 always zero
        //------------------------------------------------------

        check_register(5'd0,32'h00000000);

        //------------------------------------------------------
        // Test 2 : Write x5
        //------------------------------------------------------

        write_register(5'd5,32'h12345678);

        check_register(5'd5,32'h12345678);

        //------------------------------------------------------
        // Test 3 : Write x10
        //------------------------------------------------------

        write_register(5'd10,32'hDEADBEEF);

        check_register(5'd10,32'hDEADBEEF);

        //------------------------------------------------------
        // Test 4 : Dual Read
        //------------------------------------------------------

        rs1 = 5'd5;
        rs2 = 5'd10;

        #1;

        if(read_data1 == 32'h12345678 &&
           read_data2 == 32'hDEADBEEF)

            $display("[PASS] Dual Read");

        else

            $display("[FAIL] Dual Read");

        //------------------------------------------------------
        // Test 5 : Write to x0 (Ignored)
        //------------------------------------------------------

        write_register(5'd0,32'hFFFFFFFF);

        check_register(5'd0,32'h00000000);

        //------------------------------------------------------
        // Test 6 : Write Enable Disabled
        //------------------------------------------------------

        // First write a known value to x7
        write_register(5'd7, 32'hCAFEBABE);

        // Try to overwrite it with WE = 0
        @(negedge clk);

        we = 0;
        rd = 5'd7;
        write_data = 32'hAAAAAAAA;

        @(posedge clk);

        check_register(5'd7, 32'hCAFEBABE);

        //------------------------------------------------------

        $display("--------------------------------------------");
        $display(" Register File Verification Completed");
        $display("--------------------------------------------");

        $finish;

    end

endmodule
