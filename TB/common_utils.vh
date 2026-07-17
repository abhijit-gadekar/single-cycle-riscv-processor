`ifndef COMMON_UTILS_VH
`define COMMON_UTILS_VH

//--------------------------------------------------
// Reset Processor
//--------------------------------------------------

task reset_processor;

begin

    reset = 1;

    repeat (2)
        @(posedge clk);

    reset = 0;

    @(posedge clk);

end

endtask

//--------------------------------------------------
// Run N Cycles
//--------------------------------------------------

task run_cycles;

input integer cycles;

integer i;

begin

    for(i=0;i<cycles;i=i+1)
        @(posedge clk);

end

endtask

//--------------------------------------------------
// Print Banner
//--------------------------------------------------

task print_banner;

input [256:0] test_name;

begin

    $display("");
    $display("========================================");
    $display("%s",test_name);
    $display("========================================");

end

endtask

//--------------------------------------------------
// Finish Test
//--------------------------------------------------

task finish_test;

begin

    report_results();
    $finish;

end

endtask

`endif
