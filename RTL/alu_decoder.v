`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : alu_decoder
// Description : RV32I ALU Decoder
//
// ALUOp
// -----
// 00 : ADD        (Load/Store)
// 01 : SUB        (Branches)
// 10 : Decode funct3/funct7
// 11 : Reserved
//////////////////////////////////////////////////////////////////////////////////

module alu_decoder (

    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire       funct7b5,
    input  wire       opb5,

    output reg  [3:0] ALUControl

);

    wire RtypeSub;

    assign RtypeSub = funct7b5 & opb5;

    always @(*) begin

        case (ALUOp)

            //--------------------------------------------------
            // Load / Store
            //--------------------------------------------------
            2'b00:
                ALUControl = 4'b0000;       // ADD

            //--------------------------------------------------
            // Branch
            //--------------------------------------------------
            2'b01:
                ALUControl = 4'b0001;       // SUB

            //--------------------------------------------------
            // R-Type / I-Type
            //--------------------------------------------------
            2'b10:
            begin
                case (funct3)

                    3'b000:
                        if (RtypeSub)
                            ALUControl = 4'b0001;   // SUB
                        else
                            ALUControl = 4'b0000;   // ADD

                    3'b001: ALUControl = 4'b0111;   // SLL

                    3'b010: ALUControl = 4'b0101;   // SLT

                    3'b011: ALUControl = 4'b0110;   // SLTU

                    3'b100: ALUControl = 4'b0100;   // XOR

                    3'b101:
                        if (funct7b5)
                            ALUControl = 4'b1001;   // SRA
                        else
                            ALUControl = 4'b1000;   // SRL

                    3'b110: ALUControl = 4'b0011;   // OR

                    3'b111: ALUControl = 4'b0010;   // AND

                    default:
                        ALUControl = 4'b0000;

                endcase
            end

            //--------------------------------------------------
            // Reserved
            //--------------------------------------------------
            default:
                ALUControl = 4'b0000;

        endcase

    end

endmodule
