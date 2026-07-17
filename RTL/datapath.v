`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project : Single-Cycle RISC-V Processor
// Module  : datapath
// Description:
// Implements the complete datapath of the single-cycle RV32I processor.
//
// Instantiates:
//  - Program Counter
//  - Instruction Memory
//  - Register File
//  - Immediate Extend
//  - ALU Operand Mux
//  - ALU
//  - Data Memory
//  - Result Mux
//  - PC Target Adder
//  - PC Mux
//////////////////////////////////////////////////////////////////////////////////

module datapath(

    input  wire        clk,
    input  wire        reset,

    // Control Signals
    input  wire        RegWrite,
    input  wire [2:0]  ImmSrc,
    input  wire        ALUSrc,
    input  wire [3:0]  ALUControl,
    input  wire        MemWrite,
    input  wire [1:0]  ResultSrc,
    input  wire        PCSrc,

    // Status
    output wire        Zero,
    output wire Negative,
    output wire Carry,
    output wire Overflow,
    // Instruction fields to Control Unit
    output wire [6:0]  opcode,
    output wire [2:0]  funct3,
    output wire        funct7b5

);

    //----------------------------------------------------------
    // Internal Signals
    //----------------------------------------------------------

    wire [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    wire [31:0] pc_target;

    wire [31:0] instruction;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    wire [31:0] immediate;

    wire [31:0] alu_operand_b;
    wire [31:0] alu_result;

    wire [31:0] memory_read_data;

    wire [31:0] result;

    wire negative;
    wire carry;
    wire overflow;

    //----------------------------------------------------------
    // Instruction Decode
    //----------------------------------------------------------

    assign opcode   = instruction[6:0];
    assign funct3   = instruction[14:12];
    assign funct7b5 = instruction[30];

    //----------------------------------------------------------
    // PC + 4
    //----------------------------------------------------------

    assign pc_plus4 = pc + 32'd4;

    //----------------------------------------------------------
    // Program Counter
    //----------------------------------------------------------

    program_counter program_counter_inst(

        .clk(clk),
        .rst(reset),
        .pc_next(pc_next),
        .pc(pc)

    );

    //----------------------------------------------------------
    // Instruction Memory
    //----------------------------------------------------------

    instruction_memory instruction_memory_inst(

        .addr(pc),
        .instruction(instruction)

    );

    //----------------------------------------------------------
    // Register File
    //----------------------------------------------------------

    register_file register_file_inst(

        .clk(clk),
        .we(RegWrite),

        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),

        .write_data(result),

        .read_data1(read_data1),
        .read_data2(read_data2)

    );

    //----------------------------------------------------------
    // Immediate Extend
    //----------------------------------------------------------

    immediate_extend immediate_extend_inst(

        .instruction(instruction[31:7]),
        .ImmSrc(ImmSrc),
        .immediate(immediate)

    );

    //----------------------------------------------------------
    // ALU Operand Mux
    //----------------------------------------------------------

    alu_mux alu_mux_inst(

        .register_data(read_data2),
        .immediate(immediate),
        .ALUSrc(ALUSrc),

        .alu_operand_b(alu_operand_b)

    );

    //----------------------------------------------------------
    // ALU
    //----------------------------------------------------------

    alu alu_inst(

        .A(read_data1),
        .B(alu_operand_b),
        .ALUControl(ALUControl),

        .Result(alu_result),
        .Zero(Zero),
        .Negative(negative),
        .Carry(carry),
        .Overflow(overflow)

    );

    assign Negative = negative;
    assign Carry    = carry;
    assign Overflow = overflow;
    //----------------------------------------------------------
    // Data Memory
    //----------------------------------------------------------

    data_memory data_memory_inst(

        .clk(clk),
        .MemWrite(MemWrite),

        .addr(alu_result),
        .write_data(read_data2),

        .read_data(memory_read_data)

    );

    //----------------------------------------------------------
    // Result Mux
    //----------------------------------------------------------

    result_mux result_mux_inst(

        .alu_result(alu_result),
        .read_data(memory_read_data),
        .pc_plus4(pc_plus4),

        .ResultSrc(ResultSrc),

        .result(result)

    );

    //----------------------------------------------------------
    // PC Target
    //----------------------------------------------------------

    pc_target pc_target_inst(

        .pc(pc),
        .immediate(immediate),

        .target(pc_target)

    );

    //----------------------------------------------------------
    // PC Mux
    //----------------------------------------------------------

    pc_mux pc_mux_inst(

        .pc_plus4(pc_plus4),
        .pc_target(pc_target),

        .PCSrc(PCSrc),

        .pc_next(pc_next)

    );

endmodule
