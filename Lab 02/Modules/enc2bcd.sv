// en2bcd.sv
// This is simple module to control encoder to count up once in single detent (count one for four pulse.)
// and convert hex to 00~99
// author: Taewoo Kim
// date: Jan 26, 2025

module enc2bcd (input logic clk, cw, ccw, output logic [7:0] bcd_count);

	// Count until 3
	localparam PULSE_COUNTER = 2'b11;	
    // initalize the logic count (0~3 and wrap back)
	logic [1:0] cw_counter = 0, ccw_counter = 0;
	logic cw_ready, ccw_ready;

	// using if statement to check if counter is ready and if it is send out the ccw/cw_ready signal.
	always_ff @(posedge clk) begin
	  // CW handling check if it's mutually exclusive
	  if (cw && !ccw) begin
		// once it reaches the third state (0~3) send cw_ready and reset the counter
		 if (cw_counter == PULSE_COUNTER) begin
			cw_ready <= 1;
			cw_counter <= 0;
		// if it didn't reached, send 0 for cw_ready and count up the counter
		 end else begin
			cw_counter <= cw_counter + 1;
			cw_ready <= 0;
		 end
	  end else cw_ready <= 0;
	  
	  // CCW handling (similar) check if it's mutually exclusive
	  if (ccw && !cw) begin
		// once it reaches the third state (0~3) send ccw_ready and reset the counter
		 if (ccw_counter == PULSE_COUNTER) begin 
			ccw_ready <= 1;
			ccw_counter <= 0;
		// if it didn't reached, send 0 for ccw_ready and count up the counter
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
			// check if first digit is 9, if it wrap back to 0 and check second digit is 9
			// if it was 9 wrap back to 0 else +1
			if(bcd_count[3:0] == 4'h09) begin
				bcd_count[3:0] <= 4'h00;
				bcd_count[7:4] <= (bcd_count[7:4] == 4'h09) ? 4'h00 : bcd_count[7:4] + 1;
			end else bcd_count[3:0] <= bcd_count[3:0] + 1'b1; // cw: count up
		// ccw activated
		end else if (ccw_ready) begin
			// if first digit is 0 than set to 9 (wrap back)
			// if second digit was 0 wrap back to 0 otherwise -1
			if(bcd_count[3:0] == 4'h00) begin	
				bcd_count[3:0] <= 4'h09;
				bcd_count[7:4] <= (bcd_count[7:4] == 4'h00) ? 4'h09 : bcd_count[7:4] - 1'b1;
			end else bcd_count[3:0] <= bcd_count[3:0] - 1'b1; // ccw: count up 	
		end
    end 
	 
endmodule