// decode7.sv
// Decription: The decode7 module converts any 4 bit number num (0, 1, 2, ...E, F) 
//			   the signals necessary to control the 7-segment display.
// author: Taewoo Kim
// date: Jan 14, 2025


module decode7 (input logic [3:0] num,  	// 4-bit input number
				output logic [7:0] leds) ;  // 7-segment LED cathods

		// use case statement to map the input number to the corresponding 
		// 7-seg display			
		always_comb begin
			case(num)
				4'h00 : leds = 8'h3F; 		// display 0
				4'h01 : leds = 8'h06; 		// display 1
				4'h02 : leds = 8'h5B;		// display 2
				4'h03 : leds = 8'h4F;		// display 3
				4'h04 : leds = 8'h66; 		// display 4
				4'h05 : leds = 8'h6D; 		// display 5
				4'h06 : leds = 8'h7D;		// display 6
				4'h07 : leds = 8'h07;		// display 7
				4'h08 : leds = 8'h7F; 		// display 8
				4'h09 : leds = 8'h67; 		// display 9
				4'h0A : leds = 8'h77;		// display A
				4'h0B : leds = 8'h7C;		// display b
				4'h0C : leds = 8'h39; 		// display C
				4'h0D : leds = 8'h5E; 		// display d
				4'h0E : leds = 8'h79;		// display E
				4'h0F : leds = 8'h71;		// display F
			endcase
		end
endmodule
