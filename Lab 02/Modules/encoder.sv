// encoder.sv
// This is simple module to control encoder
// author: Taewoo Kim
// date: Jan 26, 2025

module encoder( input logic a, b, clk, // input: swithc a, b and clk
                output logic cw, ccw); // output: direction of the encoder

    // Initialize the prev_a & prev_b also define cw_next & ccw_next
    logic prev_a = 0; 
    logic prev_b = 0;
    logic cw_next, ccw_next;

    // Patterns that's been used for the rotary encoder
    /* Prev a, a, Prev b, b
            0, 1,      0, 0 : CW
            1, 1,      0, 1 : CW
            1, 0,      1, 1 : CW
            0, 0,      1, 0 : CW

            0, 0,      0, 1 : CCW
            0, 1,      1, 1 : CCW
            1, 1,      1, 0 : CCW
            1, 0,      0, 0 : CCW  */ 
    
    // Using the above patterns implement the conditions with case statement
    always_comb begin
	    // Initialize outputs to default values
		 cw_next  = 1'b0;
		 ccw_next = 1'b0;
        case ({prev_a, a, prev_b, b})
            4'b0010, 4'b1011, 4'b1101, 4'b0100: cw_next = 1'b1; // CW
            4'b0001, 4'b0111, 4'b1110, 4'b1000: ccw_next  = 1'b1; // CCW
        endcase
    end

    // In rising edge the clocks as desired outputs
    always_ff @( posedge clk ) begin
        prev_a <= a;        // save a value to prev_a
        prev_b <= b;        // save b value to prev_b
        ccw <= ccw_next;    // set ccw
        cw <= cw_next;      // set cw
    end

endmodule


/* Second way: using the pattern of the conditions
if ((a != prev_b) && (prev_a == b)) begin
    cw_next  = 1'b1;
end else if ((a == prev_b) && (b != prev_a)) begin
    ccw_next = 1'b1;
end else begin
    cw_next  = 1'b0;
    ccw_next = 1'b0;
end */