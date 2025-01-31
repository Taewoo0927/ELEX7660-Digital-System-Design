// en2bcd.sv
// This is simple module to control encoder to count every fourth pulse
// and convert hex to 0~99
// author: Taewoo Kim
// date: Jan 26, 2025


module enc2bcd (input logic clk, cw, ccw, output logic [7:0] bcd_count);

    // initalize the logic count
    logic [2:0] count = 0;

    // encoder counts: (increment when cw=1, decrement when ccw=1)
    always_ff @(posedge clk)  begin

		  // To do: Need to reset to 0 if it reaches 9.
		  // Which means 3:0 reach 9 -> 0 but 
        // encoder count starts once count reach 4 and wrap back to 0
		  if (cw) begin
		    count ++;
			 if (count >= 4) begin
				bcd_count <= bcd_count + 1'b1; // cw: count up
			 end
		  end else if (ccw) begin
		    count ++;
			 if (count >= 4) bcd_count <= bcd_count - 1'b1; // ccw: count down
		  end else bcd_count <= bcd_count;
		  
    end

endmodule