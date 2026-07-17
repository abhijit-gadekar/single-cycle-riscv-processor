`timescale 1ns/1ps

module control_unit_tb;

reg [6:0] opcode;
reg [2:0] funct3;
reg funct7b5;
reg Zero;

wire RegWrite;
wire [2:0] ImmSrc;
wire ALUSrc;
wire MemWrite;
wire [1:0] ResultSrc;
wire Branch;
wire Jump;
wire [3:0] ALUControl;
wire PCSrc;

control_unit dut(

.opcode(opcode),
.funct3(funct3),
.funct7b5(funct7b5),
.Zero(Zero),

.RegWrite(RegWrite),
.ImmSrc(ImmSrc),
.ALUSrc(ALUSrc),
.MemWrite(MemWrite),
.ResultSrc(ResultSrc),
.Branch(Branch),
.Jump(Jump),

.ALUControl(ALUControl),
.PCSrc(PCSrc)

);

initial begin

$dumpfile("control_unit.vcd");
$dumpvars(0,control_unit_tb);

$display("-----------------------------");
$display("Control Unit Verification");
$display("-----------------------------");

opcode=7'b1100011;
funct3=3'b000;
funct7b5=0;
Zero=1;

#5;

if(PCSrc)
$display("[PASS] BEQ Branch");
else
$display("[FAIL] BEQ Branch");

opcode=7'b1101111;
Zero=0;

#5;

if(PCSrc)
$display("[PASS] JAL");

else
$display("[FAIL] JAL");

opcode=7'b0110011;
funct3=3'b111;
funct7b5=0;

#5;

if(ALUControl==4'b0010)
$display("[PASS] AND Decode");
else
$display("[FAIL] AND Decode");

$display("-----------------------------");
$finish;

end

endmodule
