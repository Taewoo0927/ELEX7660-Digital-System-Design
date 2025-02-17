// File: encoder_tb.sv
// Description: This is a simple testbench to check priority encoder module 
// Author: Taewoo Kim
// Date: 2025-02-02

module encoder_tb;

    // Declare testbench signals
    logic [1:0] y;    // Output of the encoder
    logic [3:0] a;    // Input to the encoder
    logic valid;      // Valid output flag

    // Instantiate the encoder module
    encoder dut (.y(y), .a(a), .valid(valid));

    // Task to check expected vs actual output
    task check_output(input [3:0] a_in, input [1:0] expected_y, input expected_valid);
        a = a_in; // Apply input to the encoder
        #10; // Wait for output to settle

        // Compare expected vs actual results and display outcome
        if (y === expected_y && valid === expected_valid)
            $display("PASS: Time=%0t | a=%b | Expected y=%b, valid=%b | Got y=%b, valid=%b", 
                     $time, a, expected_y, expected_valid, y, valid);
        else
            $display("FAIL: Time=%0t | a=%b | Expected y=%b, valid=%b | Got y=%b, valid=%b", 
                     $time, a, expected_y, expected_valid, y, valid);
    endtask

    initial begin
        $display("Starting Encoder Testbench..."); // Start message
        $monitor("Time=%0t | a=%b | y=%b | valid=%b", $time, a, y, valid); // Monitor values

        // Test cases with expected outputs
        check_output(4'b0000, 2'b00, 0); // No valid input
        check_output(4'b0001, 2'b00, 1); // Encoding input 0001
        check_output(4'b0010, 2'b01, 1); // Encoding input 0010
        check_output(4'b0011, 2'b01, 1); // Encoding input 0011
        check_output(4'b0100, 2'b10, 1); // Encoding input 0100
        check_output(4'b0101, 2'b10, 1); // Encoding input 0101
        check_output(4'b0110, 2'b10, 1); // Encoding input 0110
        check_output(4'b0111, 2'b10, 1); // Encoding input 0111
        check_output(4'b1000, 2'b11, 1); // Encoding input 1000
        check_output(4'b1001, 2'b11, 1); // Encoding input 1001
        check_output(4'b1010, 2'b11, 1); // Encoding input 1010
        check_output(4'b1011, 2'b11, 1); // Encoding input 1011
        check_output(4'b1100, 2'b11, 1); // Encoding input 1100
        check_output(4'b1101, 2'b11, 1); // Encoding input 1101
        check_output(4'b1110, 2'b11, 1); // Encoding input 1110
        check_output(4'b1111, 2'b11, 1); // Encoding input 1111

        // Finish simulation
        $display("Testbench completed.");
        $stop;
    end

endmodule
