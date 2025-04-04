// File: lab2.sv
// Description: ELEX 7660 lab2 top-level module.  Counts up the
//              digits of decimal number 00~99 on each side of encoder of 4 digit 7-segment
//              display module.
// Author: Robert Trost
// Updated by: Taewoo Kim
// Date: 2025-02-02

module lab2 ( input logic CLOCK_50,       // 50 MHz clock
              (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
              input logic enc1_a, enc1_b, //Encoder 1 pins
				      (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) input logic 
              enc2_a, enc2_b,				      //Encoder 2 pins
              output logic [7:0] leds,    // 7-seg LED enables
              output logic [3:0] ct ) ;   // digit cathodes

   logic [1:0] digit;  // select digit to display
   logic [3:0] disp_digit;  // current digit of count to display
   logic [15:0] clk_div_count; // count used to divide clock

   logic [7:0] enc1_count, enc2_count; // count used to track encoder movement and to display
   logic enc1_cw, enc1_ccw, enc2_cw, enc2_ccw;  // encoder module outputs
   logic enc1_a_db, enc1_b_db, enc2_a_db, enc2_b_db;

   // instantiate modules to implement design
   decode2 decode2_0 (.digit,.ct) ;
   decode7 decode7_0 (.num(disp_digit),.leds) ;
  // instantiate encoders
   encoder encoder_1 (.clk(CLOCK_50), .a(enc1_a), .b(enc1_b), .cw(enc1_cw), .ccw(enc1_ccw));
   encoder encoder_2 (.clk(CLOCK_50), .a(enc2_a), .b(enc2_b), .cw(enc2_cw), .ccw(enc2_ccw));
  // instantiate encoder to bcd
   enc2bcd enc2bcd_1 (.clk(CLOCK_50), .cw(enc1_cw), .ccw(enc1_ccw), .bcd_count(enc1_count));
   enc2bcd enc2bcd_2 (.clk(CLOCK_50), .cw(enc2_cw), .ccw(enc2_ccw), .bcd_count(enc2_count));
	
   // use count to divide clock and generate a 2 bit digit counter to determine which digit to display
   always_ff @(posedge CLOCK_50) 
     clk_div_count <= clk_div_count + 1'b1 ;

  // assign the top two bits of count to select digit to display
  assign digit = clk_div_count[15:14]; 

  // Select digit to display (disp_digit)
  // Left two digits (3,2) display encoder 1 hex count and right two digits (1,0) display encoder 2 hex count
  always_comb begin
      // according to enc1_counts or enc2_counts value set disp_digit accordingly to set the leds 
		 case (digit)
			  2'b00: disp_digit = enc2_count[3:0]; // if digit is 0
			  2'b01: disp_digit = enc2_count[7:4]; // if digit is 1
			  2'b10: disp_digit = enc1_count[3:0]; // if digit is 2
			  2'b11: disp_digit = enc1_count[7:4]; // if digit is 3
			  default: disp_digit = 4'b0000;       // Default or error value
		 endcase		
  end  

endmodule


