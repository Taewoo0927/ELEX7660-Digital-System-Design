// File: seqDetect_tb.sv
// Description: This is a simple testbench to check the sequence detector module 
// Author: Taewoo Kim
// Date: 2025-02-10

module seqDetect_tb;

    // Declare testbench signals
    parameter N = 3;          // Parameter to define the sequence width
    logic a;                  // Serial input to the sequence detector
    logic [N-1:0] seq;        // Register to store the detected sequence
    logic valid;              // Output signal indicating sequence detection
    logic clk, reset_n;       // Clock and active-low reset signals

    // Test patterns to be applied to the sequence detector
    logic [N-1:0] test_patterns [6:0] = '{3'b101, 3'b111, 3'b011, 3'b111, 3'b001, 3'b110, 3'b111};

    // Instantiate the sequence detector module
    seqDetect #(3) dut (.valid(valid), .a(a), .seq(seq), .clk(clk), .reset_n(reset_n));
    
    // Generate a clock signal with a period of 10 time units
    always #5 clk = ~clk;
    
    // Task to check if the actual output matches the expected output
    task check_output(input expected_valid);
        if (valid === expected_valid) 
            $display("PASS: valid=%b | sequence=%b", valid, seq);
        else 
            $display("FAIL: valid=%b | sequence=%b", valid, seq);
    endtask
    
    // Task to send a sequence of bits serially to the sequence detector
    task send_serial_input(input [N-1:0] data);
        for (int i = N-1; i >= 0; i--) begin
            a = data[i];  // Send bits one at a time
            #10;          // Wait for one clock cycle
        end
    endtask

    // Initial block to start the test sequence
    initial begin
        $display("Starting Shift Register Testbench...");
        clk = 0;           // Initialize clock to 0
        reset_n = 0;       // Apply reset (active-low)
        #10 reset_n = 1;   // Release reset after 10 time units
        
        seq = 3'b001;      // Initialize sequence to a known value
        
        // Loop through all test patterns and apply them sequentially
        for (int i = 0; i < 7; i++) begin
            send_serial_input(test_patterns[i]); // Send the test pattern serially
            if(seq == test_patterns[i]) 
                check_output(1);  // Expected output is 1 if sequence matches
            else 
                check_output(0);  // Otherwise, expected output is 0
        end

        // End of simulation
        $display("Testbench completed.");
        $stop; // Stop simulation
    end
    
endmodule