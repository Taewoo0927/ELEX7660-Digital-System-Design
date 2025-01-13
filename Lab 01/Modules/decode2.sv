module decode2 (input logic [1:0] digit, output logic [3:0] ct) ;
					
		always_comb begin
			case(digit)
				2'b00 : ct = 4'b1110;
				2'b01 : ct = 4'b1101;
				2'b10 : ct = 4'b1011;
				2'b11 : ct = 4'b0111;
			endcase
		end
		
endmodule
			