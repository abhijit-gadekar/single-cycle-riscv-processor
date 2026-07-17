`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : result_mux
// Description : Write-Back Result Multiplexer
//
// Selects the data written back to the Register File.
//
// ResultSrc = 2'b00 -> ALU Result
// ResultSrc = 2'b01 -> Data Memory Read Data
// ResultSrc = 2'b10 -> PC + 4
//////////////////////////////////////////////////////////////////////////////////

module result_mux(

    input  wire [31:0] alu_result,
    input  wire [31:0] read_data,
    input  wire [31:0] pc_plus4,
    input  wire [1:0]  ResultSrc,

    output wire [31:0] result

);

    assign result = (ResultSrc == 2'b00) ? alu_result :
                    (ResultSrc == 2'b01) ? read_data  :
                    (ResultSrc == 2'b10) ? pc_plus4   :
                                           32'b0;

endmodule
