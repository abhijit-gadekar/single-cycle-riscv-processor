`ifndef COMMON_TASKS_VH
`define COMMON_TASKS_VH

//--------------------------------------------------
// Global Counters
//--------------------------------------------------

integer total_tests;
integer passed_tests;
integer failed_tests;

//--------------------------------------------------
// Reset Counters
//--------------------------------------------------

task init_testbench;
begin
    total_tests  = 0;
    passed_tests = 0;
    failed_tests = 0;
end
endtask

//--------------------------------------------------
// Register Check
//--------------------------------------------------

task check_reg;

input [4:0] reg_num;
input [31:0] expected;

begin

    total_tests = total_tests + 1;

    if (dut.datapath_inst.register_file_inst.registers[reg_num] === expected)
    begin
        passed_tests = passed_tests + 1;
        $display("[PASS] x%0d = %08h", reg_num, expected);
    end
    else
    begin
        failed_tests = failed_tests + 1;
        $display("[FAIL] x%0d Expected=%08h Got=%08h",
                 reg_num,
                 expected,
                 dut.datapath_inst.register_file_inst.registers[reg_num]);
    end

end

endtask

//--------------------------------------------------
// Memory Check
//--------------------------------------------------

task check_mem;

input integer addr;
input [31:0] expected;

begin

    total_tests = total_tests + 1;

    if (dut.datapath_inst.data_memory_inst.memory[addr] === expected)
    begin
        passed_tests = passed_tests + 1;
        $display("[PASS] MEM[%0d] = %08h", addr, expected);
    end
    else
    begin
        failed_tests = failed_tests + 1;
        $display("[FAIL] MEM[%0d] Expected=%08h Got=%08h",
                 addr,
                 expected,
                 dut.datapath_inst.data_memory_inst.memory[addr]);
    end

end

endtask

task check_x0;

begin

    total_tests = total_tests + 1;

    if(dut.datapath_inst.register_file_inst.registers[0]===32'd0)
    begin
        passed_tests = passed_tests + 1;
        $display("[PASS] x0 constant zero");
    end
    else
    begin
        failed_tests = failed_tests + 1;
        $display("[FAIL] x0 modified");
    end

end

endtask

task check_memory_zero;

input integer first;
input integer last;

integer i;

begin

    for(i=first;i<=last;i=i+1)
    begin

        total_tests = total_tests + 1;

        if(dut.datapath_inst.data_memory_inst.memory[i]==32'd0)
        begin
            passed_tests = passed_tests + 1;
        end
        else
        begin
            failed_tests = failed_tests + 1;

            $display("[FAIL] MEM[%0d]=%h",
                     i,
                     dut.datapath_inst.data_memory_inst.memory[i]);

        end

    end

end

endtask

task wait_for_pc;

input [31:0] pc_value;

integer timeout;

begin

    timeout = 500;

    while((dut.datapath_inst.pc!=pc_value)&&(timeout>0))
    begin
        @(posedge clk);
        timeout = timeout - 1;
    end

    if(timeout==0)
        $display("[WARNING] Timeout waiting for PC=%h",pc_value);

end

endtask

task check_opcode;

input [6:0] opcode;

begin

    total_tests = total_tests + 1;

    if(dut.datapath_inst.instruction[6:0]==opcode)
    begin
        passed_tests = passed_tests + 1;
    end
    else
    begin
        failed_tests = failed_tests + 1;
    end

end

endtask

//--------------------------------------------------
// PC Check
//--------------------------------------------------

task check_pc;

input [31:0] expected;

begin

    total_tests = total_tests + 1;

    if (dut.datapath_inst.pc == expected)
    begin
        passed_tests = passed_tests + 1;
        $display("[PASS] PC = %08h", expected);
    end
    else
    begin
        failed_tests = failed_tests + 1;
        $display("[FAIL] PC Expected=%08h Got=%08h",
                 expected,
                 dut.datapath_inst.pc);
    end

end

endtask

//--------------------------------------------------
// Instruction Check
//--------------------------------------------------

task check_instruction;

input [31:0] expected;

begin

    total_tests = total_tests + 1;

    if (dut.datapath_inst.instruction == expected)
    begin
        passed_tests = passed_tests + 1;
        $display("[PASS] Instruction = %08h", expected);
    end
    else
    begin
        failed_tests = failed_tests + 1;
        $display("[FAIL] Instruction Expected=%08h Got=%08h",
                 expected,
                 dut.datapath_inst.instruction);
    end

end

endtask

//--------------------------------------------------
// Summary
//--------------------------------------------------

task report_results;

begin

    $display("");
    $display("========================================");
    $display(" RV32I Processor Verification Summary");
    $display("========================================");
    $display("Total Tests : %0d", total_tests);
    $display("Passed      : %0d", passed_tests);
    $display("Failed      : %0d", failed_tests);
    $display("========================================");

    if (failed_tests == 0)
        $display("ALL TESTS PASSED");
    else
        $display("TEST FAILURES DETECTED");

end

endtask

`endif
