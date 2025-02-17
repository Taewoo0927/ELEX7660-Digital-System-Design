// File: shiftReg_tb.sv
// Description: This is a simple testbench to check shift register module 
// Author: Taewoo Kim
// Date: 2025-02-02

module shiftReg_tb;

    // Declare testbench signals
    logic [7:0] q;         // Output of the shift register
    logic [7:0] a;         // Parallel load input
    logic [1:0] s;         // Control signal for operation
    logic shiftIn;         // Input for shifting
    logic clk;             // Clock signal
    logic reset_n;         // Asynchronous active-low reset

    // Instantiate the shift register module
    shiftReg dut (.q(q), .a(a), .s(s), .shiftIn(shiftIn), .clk(clk), .reset_n(reset_n));

    // Clock generation
    always #5 clk = ~clk;

    // Task to check expected vs actual output
    task check_output(input [7:0] expected_q);
        #10; // Wait for one clock cycle
        if (q === expected_q)
            $display("PASS: Time=%0t | s=%b | shiftIn=%b | a=%b | Expected q=%b | Got q=%b", 
                     $time, s, shiftIn, a, expected_q, q);
        else
            $display("FAIL: Time=%0t | s=%b | shiftIn=%b | a=%b | Expected q=%b | Got q=%b", 
                     $time, s, shiftIn, a, expected_q, q);
    endtask

    initial begin
        $display("Starting Shift Register Testbench...");
        clk = 0; 
        reset_n = 0; // Apply reset
        #10 reset_n = 1; // Release reset

        // Test case 1: Parallel load
        a = 8'b10101010;
        s = 2'b00;
        check_output(8'b10101010);

        // Test case 2: Shift right with shiftIn = 1
        shiftIn = 1;
        s = 2'b01;
        check_output(8'b11010101);

        // Test case 3: Shift left with shiftIn = 0
        shiftIn = 0;
        s = 2'b10;
        check_output(8'b01010100); // Correct expected output for left shift

        // Test case 4: Hold current state
        s = 2'b11;
        check_output(8'b01010100); // Hold should retain the previous value

        // Finish simulation
        $display("Testbench completed.");
        $stop;
    end

endmodule

