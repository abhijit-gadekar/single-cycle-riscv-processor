`timescale 1ns / 1ps

module main_decoder_tb;

reg [6:0] opcode;

wire RegWrite;
wire [2:0] ImmSrc;
wire ALUSrc;
wire MemWrite;
wire [1:0] ResultSrc;
wire Branch;
wire Jump;
wire [1:0] ALUOp;

main_decoder dut(
    .opcode(opcode),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .Branch(Branch),
    .Jump(Jump),
    .ALUOp(ALUOp)
);

integer pass = 0;
integer fail = 0;

task check;
input expRegWrite;
input [2:0] expImmSrc;
input expALUSrc;
input expMemWrite;
input [1:0] expResultSrc;
input expBranch;
input expJump;
input [1:0] expALUOp;
begin
#1;
if(RegWrite==expRegWrite &&
   ImmSrc==expImmSrc &&
   ALUSrc==expALUSrc &&
   MemWrite==expMemWrite &&
   ResultSrc==expResultSrc &&
   Branch==expBranch &&
   Jump==expJump &&
   ALUOp==expALUOp)
begin
    pass=pass+1;
    $display("[PASS] opcode=%b",opcode);
end
else begin
    fail=fail+1;
    $display("[FAIL] opcode=%b",opcode);
end
end
endtask

initial begin

$display("------------------------------");
$display("Main Decoder Verification");
$display("------------------------------");

opcode=7'b0110011; check(1,3'b000,0,0,2'b00,0,0,2'b10); //R
opcode=7'b0010011; check(1,3'b000,1,0,2'b00,0,0,2'b10); //I
opcode=7'b0000011; check(1,3'b000,1,0,2'b01,0,0,2'b00); //LW
opcode=7'b0100011; check(0,3'b001,1,1,2'b00,0,0,2'b00); //SW
opcode=7'b1100011; check(0,3'b010,0,0,2'b00,1,0,2'b01); //Branch
opcode=7'b1101111; check(1,3'b100,0,0,2'b10,0,1,2'b00); //JAL
opcode=7'b1100111; check(1,3'b000,1,0,2'b10,0,1,2'b00); //JALR
opcode=7'b0110111; check(1,3'b011,1,0,2'b00,0,0,2'b00); //LUI
opcode=7'b0010111; check(1,3'b011,1,0,2'b00,0,0,2'b00); //AUIPC

$display("------------------------------");
$display("PASS=%0d FAIL=%0d",pass,fail);
$finish;

end

endmodule
