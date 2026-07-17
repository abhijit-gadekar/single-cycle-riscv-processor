`timescale 1ns/1ps

module alu_decoder_tb;

reg [1:0] ALUOp;
reg [2:0] funct3;
reg funct7b5;
reg opb5;

wire [3:0] ALUControl;

alu_decoder dut(
.ALUOp(ALUOp),
.funct3(funct3),
.funct7b5(funct7b5),
.opb5(opb5),
.ALUControl(ALUControl)
);

integer pass=0;
integer fail=0;

task check;
input [3:0] exp;
begin
#1;
if(ALUControl==exp)
begin
pass=pass+1;
$display("[PASS] %b",ALUControl);
end
else begin
fail=fail+1;
$display("[FAIL] Expected=%b Got=%b",exp,ALUControl);
end
end
endtask

initial begin

$display("--------------------------");
$display("ALU Decoder Verification");
$display("--------------------------");

ALUOp=2'b00; check(4'b0000);

ALUOp=2'b01; check(4'b0001);

ALUOp=2'b10;

funct3=3'b000;funct7b5=0;opb5=1;check(4'b0000);
funct3=3'b000;funct7b5=1;opb5=1;check(4'b0001);
funct3=3'b111;check(4'b0010);
funct3=3'b110;check(4'b0011);
funct3=3'b100;check(4'b0100);
funct3=3'b010;check(4'b0101);
funct3=3'b011;check(4'b0110);
funct3=3'b001;check(4'b0111);
funct3=3'b101;funct7b5=0;check(4'b1000);
funct3=3'b101;funct7b5=1;check(4'b1001);

$display("--------------------------");
$display("PASS=%0d FAIL=%0d",pass,fail);

$finish;

end

endmodule
