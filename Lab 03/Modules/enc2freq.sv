// File: enc2freq.sv
// Description: enc2freq module using cw or ccw generate the desired freq scale 
// Author: Taewoo Kim
// Date: 2025-02-02

module enc2freq ( input logic cw, ccw,        // input cw and ccw
                  output logic [31:0] freq,   // desired frequency 
                  input logic reset_n, clk ); // reset and clock

	// array of frequency scale
    logic [31:0] freq_array [7:0] = '{524, 491, 437, 393, 349, 328, 295, 262};

    // Count until 3
	localparam PULSE_COUNTER = 2'b11;

    // initalize the logic count (0~3 and wrap back)
	logic [1:0] cw_counter = 0, ccw_counter = 0;
    logic [2:0] counter = 0; 
	logic cw_ready, ccw_ready;

	// using if statement to check if counter is ready and if it is send out the ccw/cw_ready signal.
	always_ff @(posedge clk, negedge reset_n) begin
		if (~reset_n) begin
            counter <= 0;
      end
	  // CW handling check if it's mutually exclusive
	  else if (cw && !ccw) begin
		// once it reaches the third state (0~3) send cw_ready and reset the counter
		 if (cw_counter == PULSE_COUNTER) begin
			cw_counter <= 0;
			counter <= counter + 1;
		// if it didn't reached, send 0 for cw_ready and count up the counter
		 end else begin
			cw_counter <= cw_counter + 1;
		 end
	  end 
	  
	  // CCW handling (similar) check if it's mutually exclusive
	  else if (ccw && !cw) begin
		// once it reaches the third state (0~3) send ccw_ready and reset the counter
		 if (ccw_counter == PULSE_COUNTER) begin 
			ccw_counter <= 0;
			counter <= counter - 1;
		// if it didn't reached, send 0 for ccw_ready and count up the counter
		 end else begin
			ccw_counter <= ccw_counter + 1;
		 end
	  end 
	end

	// assign the desired frequency
	assign freq = freq_array[counter];
	 
endmodule