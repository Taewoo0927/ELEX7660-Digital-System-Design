// trafficlight_tb.sv 
// testbench to test traffic light lecture example code 
// date: Jan 12, 2024S 
// author: Robert Trost 

module trafficlight_tb ; 

logic clk = 0, reset_n = 0; // clock and active low reset 
logic r1, y1, g1, r2, y2, g2; // outputs to observe 
trafficlight dut (.*) ; // device under test 

initial begin     
    // hold reset for two clock cycles 
    reset_n = 0;
    repeat(2) @(negedge clk); 
    reset_n = 1; 
    // run for 200 seconds 
    repeat(200) @(negedge clk); 
    $stop; 
end 

// generate a 1Hz clock 
always  
    #500ms clk = ~ clk; 

endmodule 