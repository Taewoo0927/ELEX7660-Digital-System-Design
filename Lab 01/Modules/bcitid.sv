module bcitid (input logic [1:0] digit, output logic [3:0] idnum);

	logic [3:0] id_mem [3:0];
	
	initial begin
        id_mem[3] = 4'd4;
        id_mem[2] = 4'd7;
        id_mem[1] = 4'd6;
        id_mem[0] = 4'd3;
    end
	
	always_comb begin
		case (digit)
			 2'b11: idnum = id_mem[3]; // Leftmost digit
			 2'b10: idnum = id_mem[2]; // Third digit
			 2'b01: idnum = id_mem[1]; // Second digit
			 2'b00: idnum = id_mem[0]; // Rightmost digit
			 default: idnum <= 4'b0;
		endcase
	end
	
endmodule