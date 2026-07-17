`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project : Single-Cycle RISC-V Processor
// Module  : Register File
// File    : register_file.v
//
// Description:
// 32 x 32-bit Register File
//
// Features:
// - Two asynchronous read ports
// - One synchronous write port
// - Register x0 is hardwired to zero
// - Writes to x0 are ignored
//
//////////////////////////////////////////////////////////////////////////////////

module register_file (

    input  wire        clk,
    input  wire        we,

    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  rd,

    input  wire [31:0] write_data,

    output wire [31:0] read_data1,
    output wire [31:0] read_data2

);

    //----------------------------------------------------------
    // Register Memory
    //----------------------------------------------------------

    reg [31:0] registers [0:31];
    integer i;
    initial begin
    for (i = 0; i < 32; i = i + 1)
        registers[i] = 32'd0;
    end
    //----------------------------------------------------------
    // Write Port (Synchronous)
    //----------------------------------------------------------

    always @(posedge clk)
    begin
        if (we && (rd != 5'd0))
            registers[rd] <= write_data;
    end

    //----------------------------------------------------------
    // Read Port 1 (Asynchronous)
    //----------------------------------------------------------

    assign read_data1 = (rs1 == 5'd0) ? 32'h00000000 :
                        registers[rs1];

    //----------------------------------------------------------
    // Read Port 2 (Asynchronous)
    //----------------------------------------------------------

    assign read_data2 = (rs2 == 5'd0) ? 32'h00000000 :
                        registers[rs2];

endmodule
