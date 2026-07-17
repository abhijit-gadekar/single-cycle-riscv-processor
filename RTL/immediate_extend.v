`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : immediate_extend
// Description : Immediate Extension Unit for RV32I Processor
//
// ImmSrc Encoding
// 000 : I-type
// 001 : S-type
// 010 : B-type
// 011 : U-type
// 100 : J-type
//
//////////////////////////////////////////////////////////////////////////////////

module immediate_extend(

    input  wire [31:7] instruction,
    input  wire [2:0]  ImmSrc,

    output reg  [31:0] immediate

);

    always @(*) begin

        case (ImmSrc)

            //--------------------------------------------------
            // I-Type (ADDI, LW, JALR, etc.)
            //--------------------------------------------------
            3'b000:
                immediate = {{20{instruction[31]}},
                              instruction[31:20]};

            //--------------------------------------------------
            // S-Type (SW)
            //--------------------------------------------------
            3'b001:
                immediate = {{20{instruction[31]}},
                              instruction[31:25],
                              instruction[11:7]};

            //--------------------------------------------------
            // B-Type (Branches)
            //--------------------------------------------------
            3'b010:
                immediate = {{19{instruction[31]}},
                              instruction[31],
                              instruction[7],
                              instruction[30:25],
                              instruction[11:8],
                              1'b0};

            //--------------------------------------------------
            // U-Type (LUI / AUIPC)
            //--------------------------------------------------
            3'b011:
                immediate = {instruction[31:12],
                             12'b0};

            //--------------------------------------------------
            // J-Type (JAL)
            //--------------------------------------------------
            3'b100:
                immediate = {{11{instruction[31]}},
                              instruction[31],
                              instruction[19:12],
                              instruction[20],
                              instruction[30:21],
                              1'b0};

            //--------------------------------------------------
            // Default
            //--------------------------------------------------
            default:
                immediate = 32'b0;

        endcase

    end

endmodule
