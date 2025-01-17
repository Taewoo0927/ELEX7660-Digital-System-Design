module bcitid (input logic [1:0] digit, output logic [3:0] idnum);
	
	always_comb begin
		case (digit)
			 2'b11: idnum = 4'h4; // Leftmost digit
			 2'b10: idnum = 4'h7; // Third digit
			 2'b01: idnum = 4'h6; // Second digit
			 2'b00: idnum = 4'h3; // Rightmost digit
		endcase
	end
	
endmodule