// debounce.sv
// This is simple module to add debounce for the noisy signals,
// It uses shift register sampling mechanism to check the sample is all same or not.
// author: Taewoo Kim
// date: Jan 26, 2025

module debounce #(parameter N = 4) ( input clk, noisy_sig,
                 output stable_sig);

    // initialize the shift reg, size can be changed
    // to the desired sampling size.
    logic [N-1:0] shift_reg = 10'b0;

    always_ff @(posedge clk) begin

        // shift nosiy signal to the shift reg
        shift_reg <= {shift_reg[N-2:0], noisy_sig};

        // check if the shift_reg is filled with 1s
        if (&shift_reg) stable_sig <= 1'b1;
        // check if the shift_reg is filled with 0s
        else if (~|shift_reg) stable_sig <= 1'b0;
        
    end

endmodule