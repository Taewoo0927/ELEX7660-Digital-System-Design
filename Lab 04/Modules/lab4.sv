// File: lab4.sv
// Description: ELEX 7660 lab4 top-level module.
//              We can use enc to select analog channel
//              and use adc to convert analog to digital bits and display on
//              7-segments
// Author: Taewoo Kim
// Date: 2025-02-10

module lab4 (
				 input logic CLOCK_50,           // 50 MHz clock input
				 (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
				 input logic enc1_a, enc1_b,     // Encoder 1 signals (A and B channels)
				 input logic s1,             // Pushbuttons for reset (s1) and turning On/Off (s2)
				 input logic ADC_SDO,
				 output logic [7:0] leds,        // 7-segment LED display output
				 output logic ADC_CONVST, ADC_SCK, ADC_SDI,
				 output logic [3:0] ct           // Digit cathodes for the 7-segment display
				 );

   logic [1:0] digit;  // select digit to display
   logic [3:0] disp_digit;  // current digit of count to display
   logic [15:0] clk_div_count; // count used to divide clock
   logic enc1_cw, enc1_ccw; // enc1 cw/ccw variables
   logic [11:0] adc_values; // variable to store adc vals
   logic [2:0] channel_values; // variable to store channel vals

  // instantiate modules to implement design
  decode2 decode2_0 (.digit, .ct);  
	// instantiate decode 7 to display digit on leds 
  decode7 decode7_0 (.num(disp_digit), .leds);  
	 
  // instantiate encoders
   encoder encoder_1 (.clk(digit), .a(enc1_a), .b(enc1_b), .cw(enc1_cw), .ccw(enc1_ccw));

  // instantiate encoder to channel
   enc2chan enc2chan_1 (.clk(clk_div_count[13]), .reset_n(s1), .cw(enc1_cw), .ccw(enc1_ccw), .chan(channel_values));
   
   // instantiate adc interface module
   adcinterface adcinterface_1 (.clk(clk_div_count[13]), .reset_n(s1), .chan(channel_values), .result(adc_values), .ADC_SDO, .ADC_CONVST, .ADC_SCK, .ADC_SDI);
   
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
          2'b00: disp_digit = adc_values[3:0];    // display adc values digit 0
          2'b01: disp_digit = adc_values[7:4];    // display adc values digit 1
          2'b10: disp_digit = adc_values[11:8];   // display adc values digit 2
			 2'b11: disp_digit = {1'b0, channel_values}; // display # of analog channel
			 default: disp_digit = 4'd0;
		 endcase		
  end 


endmodule


