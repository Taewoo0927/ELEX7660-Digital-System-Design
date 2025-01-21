// decode2.sv
// Description: The decode2 module implements a 2-to-4 decoder.
// author: Taewoo Kim
// date: Jan 14, 2025

module decode2 (input logic [1:0] digit, // 2-bit input digits 
				output logic [3:0] ct) ; // 4-bit active low output
					
		// use case statement to map the input number to the corresponding ct (output)
		always_comb begin
			case(digit)
				2'b00 : ct = 4'b1110; // Activate output 0 (active low)
				2'b01 : ct = 4'b1101; // Activate output 1 (active low)
				2'b10 : ct = 4'b1011; // Activate output 2 (active low)
				2'b11 : ct = 4'b0111; // Activate output 3 (active low)
			endcase
		end
		
endmodule
			