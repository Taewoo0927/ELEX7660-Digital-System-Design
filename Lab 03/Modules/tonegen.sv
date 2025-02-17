// File: tongen.sv
// Description: simple tongen module to create the tone using 
//              input as desired frequency. 
// Author: Taewoo Kim
// Date: 2025-02-02

module tonegen #(parameter FCLK = 50000000)                // clock frequency, Hz
        ( input logic [31:0] freq,      // frequency to output on speaker
          input logic onOff,            // 1 -> generate output, 0-> no output
          output logic spkr,            // speaker output
          input logic reset_n, clk);    // reset and clock

  // initialize the counter and desired_freq variable
  logic [31:0] count;
  logic [31:0] desired_freq;

  // shift by 1 to multiply 2 to freq without using multiplication
  assign desired_freq = freq << 1;

  // using always_ff to count to get desired cycles
  always_ff @( posedge clk, negedge reset_n ) begin
    
    // rest the spkr and counter
    if(~reset_n) begin
      spkr <= 0;
      count <= 0;
    end 

    // if tonegen is on start count until desired cycle
    else if (onOff) begin

      // count the counter using desired freq
      count <= count + desired_freq;      
      // once it reached desired cycle toggle spkr to create tone
      if(count >= (FCLK-desired_freq)) begin
        spkr <= ~spkr;
        count <= 0;
      end

    end
    
    
  end

endmodule