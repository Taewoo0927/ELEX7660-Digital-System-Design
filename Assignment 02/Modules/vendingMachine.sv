// File: vendingMachine.sv
// Description: Vending Machine module that accumulates coin inputs (nickel, dime, quarter) 
//              and sets 'valid' high when the total reaches 100 cents.
// Author: Taewoo Kim
// Date: 2025-02-20

module vendingMachine (output logic valid, // Output signal indicating if total amount has reached 100 cents
                       input logic nickel, dime, quarter, // Coin inputs: 5 cents, 10 cents, 25 cents
                       input logic clk, reset_n); // Clock and active-low reset signals

    // Define storage for total amount (in cents)
    // Since max value needed is 100, clog2(100) bits are enough
    logic [$clog2(100)-1:0] total_amount; 
    logic [$clog2(100)-1:0] next_total_amount; // Next state value for total_amount
    logic next_valid; // Next state value for valid signal

    // Combinational logic: Compute next total amount based on coin inputs
    always_comb begin
        next_total_amount = total_amount 
                            + (nickel ? 5 : 0)   // Add 5 cents if nickel is inserted
                            + (dime ? 10 : 0)    // Add 10 cents if dime is inserted
                            + (quarter ? 25 : 0); // Add 25 cents if quarter is inserted
        
        // Check if total amount reaches or exceeds 100 cents
        next_valid = (next_total_amount >= 100) ? 1'b1 : 1'b0;
    end
    
    // Sequential logic: Update total_amount and valid on clock edge
    always_ff @(posedge clk, negedge reset_n) begin
        if (~reset_n) begin
            // Reset condition: Set total_amount and valid to 0
            total_amount <= 0;
            valid <= 0;
        end else if (next_valid) begin
            // If total amount reaches 100 cents, reset total_amount and set valid high
            total_amount <= 0;
            valid <= 1'b1;
        end else begin
            // Otherwise, update total_amount with new value and keep valid low
            total_amount <= next_total_amount;
            valid <= 1'b0;
        end
    end

endmodule
