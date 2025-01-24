// UpDownCnt3.sv
// Simple state machine lecture exmpale, 3 bit up/down cunter
// author: Taewoo Kim
// date: Jan 17, 2025

module UpDownCnt3 (input logic upDown,
                   output logic [2:0] count,
                   input logic clk, reset_n );

    logic [2:0] nextCount;

    // Counting logic
    always_comb begin
        if (upDown)
            nextCount = count + 1'b1;
        else
            nextCount = count - 1'b1;
    end

    // Clock to store nextCount to count
    always_ff @( posedge clk, negedge reset_n ) begin
        if (~reset_n)
            count <= 0;
        count <= nextCount;
    end
    
endmodule
