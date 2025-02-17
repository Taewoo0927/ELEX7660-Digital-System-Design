// File: shiftReg.sv
// Description: This is a simple module to create an 8-bit shift register
// Author: Taewoo Kim
// Date: 2025-02-02

module shiftReg (
    output logic [7:0] q,  // 8-bit output register
    input logic [7:0] a,   // 8-bit parallel load input
    input logic [1:0] s,   // 2-bit control signal to determine operation
    input logic shiftIn,   // Single-bit shift input for shifting operations
    input logic clk,       // Clock signal
    input logic reset_n    // Active-low asynchronous reset
);

    // Always block triggered on the rising edge of the clock or falling edge of reset
    always_ff @(posedge clk, negedge reset_n) begin
        if (~reset_n) begin // If reset is active (low)
            q <= 8'b0; // Clear the shift register
        end else begin // Otherwise, check operation based on control signal 's'
            case (s) // Case statement to determine shift operation
                2'b00 : q <= a; // Parallel load from input 'a'
                2'b01 : q <= {shiftIn, q[7:1]}; // Shift right: insert shiftIn at MSB, shift right
                2'b10 : q <= {q[6:0], shiftIn}; // Shift left: insert shiftIn at LSB, shift left
                2'b11 : q <= q; // Hold the current value
            endcase
        end
    end
endmodule