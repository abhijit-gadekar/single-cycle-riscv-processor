module main_decoder(

    input  wire [6:0] opcode,

    output reg        RegWrite,
    output reg [2:0]  ImmSrc,
    output reg        ALUSrc,
    output reg        MemWrite,
    output reg [1:0]  ResultSrc,
    output reg        Branch,
    output reg        Jump,
    output reg [1:0]  ALUOp

);

always @(*) begin

    // Defaults
    RegWrite = 1'b0;
    ImmSrc   = 3'b000;
    ALUSrc   = 1'b0;
    MemWrite = 1'b0;
    ResultSrc= 2'b00;
    Branch   = 1'b0;
    Jump     = 1'b0;
    ALUOp    = 2'b00;

    case(opcode)

        // R-Type
        7'b0110011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b0;
            ALUOp    = 2'b10;
        end

        // I-Type ALU
        7'b0010011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            ALUOp    = 2'b10;
            ImmSrc   = 3'b000;
        end

        // Load
        7'b0000011: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            ResultSrc= 2'b01;
            ALUOp    = 2'b00;
            ImmSrc   = 3'b000;
        end

        // Store
        7'b0100011: begin
            ALUSrc   = 1'b1;
            MemWrite = 1'b1;
            ALUOp    = 2'b00;
            ImmSrc   = 3'b001;
        end

        // Branch
        7'b1100011: begin
            Branch   = 1'b1;
            ALUOp    = 2'b01;
            ImmSrc   = 3'b010;
        end

        // JAL
        7'b1101111: begin
            RegWrite = 1'b1;
            Jump     = 1'b1;
            ResultSrc= 2'b10;
            ImmSrc   = 3'b100;
        end

        // JALR
        7'b1100111: begin
            RegWrite = 1'b1;
            Jump     = 1'b1;
            ALUSrc   = 1'b1;
            ResultSrc= 2'b10;
            ALUOp    = 2'b00;
            ImmSrc   = 3'b000;
        end

        // LUI
        7'b0110111: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            ImmSrc   = 3'b011;
        end

        // AUIPC
        7'b0010111: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            ALUOp    = 2'b00;
            ImmSrc   = 3'b011;
        end

        default: begin
	end

    endcase

end

endmodule
