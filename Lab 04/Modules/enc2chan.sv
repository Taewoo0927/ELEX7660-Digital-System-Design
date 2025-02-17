// File: enc2chan.sv
// Description: Module using cw or ccw inputs to generate the desired channel scale 
// Author: Taewoo Kim
// Date: 2025-02-10

module enc2chan (
    input  logic       cw, ccw,       // Encoder signals: cw and ccw
    output logic [2:0] chan,          // Desired channel output
    input  logic       reset_n, clk   // Asynchronous reset and clock
);

    // Array of channel scales (frequency levels)
    logic [2:0] chan_array [7:0] = '{3'b111, 3'b110, 3'b101, 3'b100, 3'b011, 3'b010, 3'b001, 3'b000};

    // Count threshold (pulse counter)
    localparam logic [1:0] PULSE_COUNTER = 2'b11;

    // Pulse counters for cw and ccw signals
    logic [1:0] cw_counter, ccw_counter;
    // Main channel index counter
    logic [2:0] counter;

    // Registers to store previous states for edge detection
    logic cw_prev, ccw_prev;

    // Edge detection: capture previous cw and ccw values
    always_ff @(posedge clk, negedge reset_n) begin
        // initialize cw_prev and ccw_prev
        if (!reset_n) begin
            cw_prev  <= 1'b0; 
            ccw_prev <= 1'b0;
        // every clock edge store cw/ccw to cw_prev/ccw_prev
        end else begin
            cw_prev  <= cw;
            ccw_prev <= ccw;
        end
    end

    // Generate one-shot pulses on the rising edge of cw or ccw, 
    // and ensure they are mutually exclusive
	logic cw_edge, ccw_edge;
	assign cw_edge  = (cw && !cw_prev) && !ccw;
	assign ccw_edge = (ccw && !ccw_prev) && !cw;

    // Update counters on detected rising edges
    always_ff @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            cw_counter   <= 2'b0;
            ccw_counter  <= 2'b0;
            counter      <= 3'b0;
        end else begin
            // CW handling: if a rising edge is detected on cw
            if (cw_edge) begin
                if (cw_counter == PULSE_COUNTER) begin
                    cw_counter <= 2'b0;
                    counter    <= counter + 1; // Increment channel index
                end else begin
                    cw_counter <= cw_counter + 1;
                end
            end 
            // CCW handling: if a rising edge is detected on ccw
            else if (ccw_edge) begin
                if (ccw_counter == PULSE_COUNTER) begin
                    ccw_counter <= 2'b0;
                    counter     <= counter - 1; // Decrement channel index
                end else begin
                    ccw_counter <= ccw_counter + 1;
                end
            end
            // Optionally, you might reset the counters if no edge is detected:
            else begin
                cw_counter  <= cw_counter;
                ccw_counter <= ccw_counter;
            end
        end
    end

    // Assign the channel output based on the channel index
    assign chan = chan_array[counter];

endmodule
