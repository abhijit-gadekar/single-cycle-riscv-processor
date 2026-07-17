`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name : alu
// Description : RV32I Arithmetic Logic Unit
//
// Supported Operations
// --------------------
// 0000 : ADD
// 0001 : SUB
// 0010 : AND
// 0011 : OR
// 0100 : XOR
// 0101 : SLT   (signed)
// 0110 : SLTU  (unsigned)
// 0111 : SLL
// 1000 : SRL
// 1001 : SRA
// 1010 : LUI
// 1011 : AUIPC
//////////////////////////////////////////////////////////////////////////////////

module alu (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALUControl,

    output reg  [31:0] Result,
    output wire        Zero,
    output wire        Negative,
    output wire        Carry,
    output wire        Overflow
);

    //----------------------------------------------------------
    // Adder/Subtractor
    //----------------------------------------------------------
    wire        sub;
    wire [31:0] B_mux;
    wire [32:0] Sum;

    assign sub   = (ALUControl == 4'b0001);

    assign B_mux = sub ? ~B : B;

    assign Sum = {1'b0, A} + {1'b0, B_mux} + sub;

    //----------------------------------------------------------
    // Carry Flag
    //----------------------------------------------------------
    assign Carry = Sum[32];

    //----------------------------------------------------------
    // Overflow Flag
    //----------------------------------------------------------
    assign Overflow =
           sub ?
           ((A[31] ^ B[31]) & (A[31] ^ Sum[31])) :
           (~(A[31] ^ B[31]) & (A[31] ^ Sum[31]));

    //----------------------------------------------------------
    // ALU Operations
    //----------------------------------------------------------
    always @(*) begin
        case (ALUControl)

            4'b0000: Result = Sum[31:0];                  // ADD
            4'b0001: Result = Sum[31:0];                  // SUB

            4'b0010: Result = A & B;                      // AND
            4'b0011: Result = A | B;                      // OR
            4'b0100: Result = A ^ B;                      // XOR

            4'b0101: Result = ($signed(A) < $signed(B));  // SLT
            4'b0110: Result = (A < B);                    // SLTU

            4'b0111: Result = A << B[4:0];                // SLL
            4'b1000: Result = A >> B[4:0];                // SRL
            4'b1001: Result = $signed(A) >>> B[4:0];      // SRA

            4'b1010: Result = B;                          // LUI
            4'b1011: Result = A + B;                      // AUIPC

            default: Result = 32'b0;

        endcase
    end

    //----------------------------------------------------------
    // Status Flags
    //----------------------------------------------------------
    assign Zero     = (Result == 32'b0);
    assign Negative = Result[31];

endmodule
