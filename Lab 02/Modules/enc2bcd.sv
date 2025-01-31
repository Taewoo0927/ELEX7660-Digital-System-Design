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

    // encoder counts: (increment when cw=1, decrement when ccw=1)
    always_ff @(posedge clk)  begin

		// cw activated
		if (cw) begin

			// counted up to 3
			if (state_count >= PULSE_COUNTER) begin

				// check if first digit is 9
				if(bcd_count[3:0] >= 4'h09) begin
					bcd_count[3:0] <= 4'h00;
					bcd_count[7:4] <= (bcd_count[7:4] >= 4'h09) ? 4'h00 : bcd_count[7:4] + 1;
				end
				
				bcd_count[3:0] <= bcd_count[3:0] + 1'b1; // cw: count up
			end
			state_count <= state_count + 1; // count the state
		
		// ccw activated
		end else if (ccw) begin
			if (state_count >= PULSE_COUNTER) begin

				// if first digit is 0 than set to 9 (wrap back)
				if(bcd_count[3:0] == 4'h00) begin	
					bcd_count[3:0] <= 4'h09;
					bcd_count[7:4] <= (bcd_count[7:4] == 4'h00) ? 4'h09 : bcd_count[7:4] - 1'b1;
				end

				bcd_count[3:0] <= bcd_count[3:0] - 1'b1; // ccw: count up
			end 	
			state_count <= state_count + 1; // count the state
		
		// nothing activated
		end else bcd_count <= bcd_count;

    end

endmodule