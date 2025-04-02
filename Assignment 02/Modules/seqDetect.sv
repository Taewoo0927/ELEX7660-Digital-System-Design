// File: seqDetect.sv
// Description: This is a simple sequence detector module
//              The output valid should be asserted for one clock cycle if the last N 'a' bits match the seq input. 
// Author: Taewoo Kim
// Date: 2025-02-20

module seqDetect #(parameter N=6)(         // Default N --> 6
    output logic valid,                    // Output signal that is asserted when sequence is detected
    input logic a,                         // Serial input bit stream
    input logic [N-1:0] seq,               // Sequence to be detected (N-bit pattern)
    input logic clk, reset_n               // Clock and active-low reset
); 

    // Declare a register to store the last N received bits
    logic [N-1:0] valid_buffer, next_valid_buffer; 
    
    // Counter to keep track of how many bits have been received
    logic [$clog2(N+1)-1:0] bit_count, next_bit_count; 
    
    // Temporary variable for next valid state
    logic next_valid;

    //-------------------------
    // 1) Combinational logic --> update one by one
    //-------------------------
    always_comb begin
        // Shift the new bit 'a' into the valid_buffer (shifting left)
        next_valid_buffer = {valid_buffer[N-2:0], a};
        
        // Increment bit count until it reaches N, then keep it at N
        next_bit_count    = (bit_count < N) ? (bit_count + 1) : bit_count;
        
        // Check if we have received at least N bits and the last N bits match the expected sequence
        next_valid        = (next_bit_count >= N && next_valid_buffer == seq);
    end

    //-------------------------
    // 2.) always_ff logic --> synchronize the variables
    //-------------------------
    // Using always_ff to synchronize valid_buffer, bit_count, and valid with the clock
    always_ff @(posedge clk, negedge reset_n) begin
        if(~reset_n) begin  // Asynchronous active-low reset
            valid_buffer <= '0;  // Clear the buffer storing received bits
            bit_count    <= '0;  // Reset the bit counter
            valid        <= 1'b0; // Deassert valid output
        end
        else if (next_valid) begin // If sequence detected, reset the system
            valid        <= 1'b1;  // Assert valid for one cycle
            valid_buffer <= '0;    // Reset the buffer
            bit_count    <= '0;    // Reset the counter
        end
        else begin
            valid_buffer <= next_valid_buffer; // Update valid_buffer with the shifted sequence
            bit_count    <= next_bit_count;    // Update bit counter
            valid        <= 1'b0;              // Deassert valid in other cycles
        end
    end

endmodule