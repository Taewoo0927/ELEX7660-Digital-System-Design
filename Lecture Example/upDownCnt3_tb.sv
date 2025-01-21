// UpDownCnt3_tb.sv
// Testbench to exercise a simple state machine lecture example
// author: Taewoo Kim
// date: Jan 17, 2025

logic upDown
logic [2:0] count;
logic clk;

UpDownCnt3 dut(.*);

initial begin

    // count up 5 times then down 5 times.
    upDown = 1;
    repeat (5) @(negedge clk);
    upDown = 0;
    repeat (5) @(negedge clk);

    $stop
end

// generate 1Hz clk
always 
    #500ms clk = ~clk;