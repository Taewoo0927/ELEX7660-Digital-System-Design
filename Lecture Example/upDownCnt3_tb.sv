// UpDownCnt3_tb.sv
// Testbench to exercise a simple state machine lecture example
// author: Taewoo Kim
// date: Jan 17, 2025

logic upDown
logic [2:0] count;
logic clk=0, reset_n=0;

UpDownCnt3 dut(.*);

initial begin
    
    // Apply active low reset for 100ms
    reset_n = 0;
    #100ms;
    reset_n = 1;

    // count up 9 times then down 10 times.
    upDown = 1;
    repeat (9) @(negedge clk);
    upDown = 0;
    repeat (10) @(negedge clk);

    $stop
end

// generate 1Hz clk
always 
    #500ms clk = ~clk;