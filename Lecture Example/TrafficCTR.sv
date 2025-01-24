// TrafficCTR.sv
// This module controls a traffic light.
// author: Taewoo Kim
// date: Jan 21, 2025


module trafficlight(
            input logic clk, reset_n // 1MHz clock and Active-low reset
            output logic r1, y1, g1, r2, y2, g2 // traffic light control signals
            );

    enum logic [1:0] { RG, RY, GR, YR } state, next_state;
    logic [4:0] count, next_count;

    always_comb begin
        // To do: Traffic control state machine logic should be here
    end

    
    always_ff @( posedge clock, negedge reset_n ) begin
        if(~reset_n) begin
            
        end

        count <= next_count
    end

endmodule