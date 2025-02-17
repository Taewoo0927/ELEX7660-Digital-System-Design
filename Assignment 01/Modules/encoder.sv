// File: encoder.sv
// Description: This is a simple priority encoder module 
// Author: Taewoo Kim
// Date: 2025-02-02

module encoder (
    output logic [1:0] y,  // 2-bit output representing the encoded value
    output logic valid,     // Output signal indicating if the input is valid
    input logic [3:0] a     // 4-bit input representing the encoded signal
);

    // Always block using combinational logic to determine output
    always_comb begin
        // Case statement to encode the input based on priority
        casez (a) 
            4'b0000: {y[1], y[0], valid} = 3'b000; // No active input, output is 00, valid=0
            4'b0001: {y[1], y[0], valid} = 3'b001; // Input 0001, encode as 00, valid=1
            4'b001?: {y[1], y[0], valid} = 3'b011; // Input 001x, encode as 01, valid=1
            4'b01??: {y[1], y[0], valid} = 3'b101; // Input 01xx, encode as 10, valid=1
            4'b1???: {y[1], y[0], valid} = 3'b111; // Input 1xxx, encode as 11, valid=1
            default: {y[1], y[0], valid} = 3'b000; // Default case, output is 00, valid=0
        endcase
    end

endmodule