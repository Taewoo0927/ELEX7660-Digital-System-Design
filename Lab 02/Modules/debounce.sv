// debounce.sv
// This is simple module to add debounce for the noisy signals,
// It uses shift register sampling mechanism to check the sample is all same or not.
// author: Taewoo Kim
// date: Jan 26, 2025


// This was nice try but it won't work for the rotary encoder:
// The reason is rotary encoder might generate cw - cw - ccw (0) - cw - cw including noise
// which means if I have 6 bit shift register it will never fill up with the same values.

module debounce #(parameter N = 15) ( input clk, noisy_sig,
                 output logic stable_sig);

    // initialize the shift reg, size can be changed
    // to the desired sampling size.
    logic [N-1:0] shift_reg = 16'h0000;

    always_ff @(posedge clk) begin
        // shift nosiy signal to the shift reg
        shift_reg <= {shift_reg[N-2:0], noisy_sig};

        if (shift_reg == {N{1'b1}}) begin
			 stable_sig <= 1'b1;
			 shift_reg <= '0;
		  end else begin
			 stable_sig <= 1'b0;
		  end
    end

endmodule