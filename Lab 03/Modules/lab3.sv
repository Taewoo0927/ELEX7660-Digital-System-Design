// File: lab3.sv
// Description: ELEX 7660 lab3 top-level module.
//              We can scale the buzzer to make different frequency sounds
//					 and 7-segment display the corresponding frequency.
//              display module.
// Author: Taewoo Kim
// Date: 2025-02-02

module lab3 ( input logic CLOCK_50,       // 50 MHz clock
              input logic s1,
              input logic s2,
              (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
              input logic enc1_a, enc1_b, //Encoder 1 pins
				      (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) input logic 
              enc2_a, enc2_b,				      //Encoder 2 pins
              output logic [7:0] leds,    // 7-seg LED enables
              output logic [3:0] ct,      // digit cathodes
              output logic spkr ) ;       // speaker

   logic [1:0] digit;  // select digit to display
   logic [3:0] disp_digit;  // current digit of count to display
   logic [15:0] clk_div_count; // count used to divide clock
   logic [31:0] desired_freq;
   logic enc1_cw, enc1_ccw;

   // instantiate modules to implement design
   decode2 decode2_0 (.digit,.ct) ;
   decode7 decode7_0 (.num(disp_digit), .leds) ;
  // instantiate encoders
   encoder encoder_1 (.clk(CLOCK_50), .a(enc1_a), .b(enc1_b), .cw(enc1_cw), .ccw(enc1_ccw));
  // instantiate encoder to bcd
   enc2freq enc2freq_1 (.cw(enc1_cw), .ccw(enc1_ccw), .freq(desired_freq), .reset_n(s1), .clk(CLOCK_50));
   tonegen tonegen_1 ( .freq(desired_freq), .onOff(s2), .spkr(spkr), .reset_n(s1), .clk(CLOCK_50));
   
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
			  2'b00: disp_digit = desired_freq[3:0]; // if digit is 0
			  2'b01: disp_digit = desired_freq[7:4]; // if digit is 1
			  2'b10: disp_digit = desired_freq[11:8]; // if digit is 2
			  2'b11: disp_digit = desired_freq[15:12]; // if digit is 3
			  default: disp_digit = 4'b0000;       // Default or error value
		 endcase		
  end 


endmodule


