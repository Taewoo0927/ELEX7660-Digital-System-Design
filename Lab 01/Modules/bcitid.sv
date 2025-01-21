// bcitid.sv
// Description: The bcitid module implements a 4x4 bit memory
// 				that will store the last four digits of our BCIT student ID.
// author: Taewoo Kim
// date: Jan 14, 2025

module bcitid (input logic [1:0] digit, // 2-bit input digit 
				output logic [3:0] idnum); // 4-bit output for id #
	
	// Use case statement to map the input digit to the corresponding
	// student ID number
	always_comb begin
		case (digit)
			 2'b11: idnum = 4'h4; // Leftmost digit
			 2'b10: idnum = 4'h7; // Third digit
			 2'b01: idnum = 4'h6; // Second digit
			 2'b00: idnum = 4'h3; // Rightmost digit
		endcase
	end
	
endmodule