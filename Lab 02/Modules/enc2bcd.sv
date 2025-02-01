// en2bcd.sv
// This is simple module to control encoder to count every fourth pulse
// and convert hex to 0~99
// author: Taewoo Kim
// date: Jan 26, 2025

module enc2bcd (input logic clk, cw, ccw, output logic [7:0] bcd_count);

	// Count until 3
	localparam PULSE_COUNTER = 2'b11;	
    // initalize the logic count (0~3 and wrap back)
   logic [1:0] state_count = 0;
	logic [1:0] cw_counter = 0, ccw_counter = 0;
	logic cw_ready, ccw_ready;

	// By separating the always_ff I can correct the timing,
	// since second ff is using first ff's value it will wait and update on the next cycle.
	// whereas, if I have everything in one ff if it's not ready it will either use old values or 	
	// it might behave unintendly.
	// counter needs to be separated since cw or ccw might have noise and both can count.
	
	// When I used shared counter, it won't check 4 states for specific rotation.
	// If I'm rotating cw and got cw-cw-cw-ccw it will go in to ccw since it counted up 4 but last was ccw.
	// Whereas, if I separate the counter it will specifically check cw four times to count up to cw.

	always_ff @(posedge clk) begin
	  // CW handling
	  if (cw && !ccw) begin
		 if (cw_counter == PULSE_COUNTER) begin
			cw_ready <= 1;
			cw_counter <= 0;
		 end else begin
			cw_counter <= cw_counter + 1;
			cw_ready <= 0;
		 end
	  end else cw_ready <= 0;
	  
	  // CCW handling (similar)
	  if (ccw && !cw) begin
		 if (ccw_counter == PULSE_COUNTER) begin
			ccw_ready <= 1;
			ccw_counter <= 0;
		 end else begin
			ccw_counter <= ccw_counter + 1;
			ccw_ready <= 0;
		 end
	  end else ccw_ready <= 0;
	end

    // encoder counts: (increment when cw_ready = 1, decrement when ccw_ready = 1)
    always_ff @(posedge clk)  begin
		// cw activated
		if (cw_ready) begin
			// check if first digit is 9
			if(bcd_count[3:0] == 4'h09) begin
				bcd_count[3:0] <= 4'h00;
				bcd_count[7:4] <= (bcd_count[7:4] == 4'h09) ? 4'h00 : bcd_count[7:4] + 1;
			end else bcd_count[3:0] <= bcd_count[3:0] + 1'b1; // cw: count up
		end else if (ccw_ready) begin
			// if first digit is 0 than set to 9 (wrap back)
			if(bcd_count[3:0] == 4'h00) begin	
				bcd_count[3:0] <= 4'h09;
				bcd_count[7:4] <= (bcd_count[7:4] == 4'h00) ? 4'h09 : bcd_count[7:4] - 1'b1;
			end else bcd_count[3:0] <= bcd_count[3:0] - 1'b1; // ccw: count up 	
		end
    end 
	 
endmodule