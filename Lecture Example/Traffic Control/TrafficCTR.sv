// TrafficCTR.sv
// This module controls a traffic light.
// author: Taewoo Kim
// date: Jan 21, 2025

`define GREEN_DELAY 30
`define YELLOW_DELAY 5

module trafficlight(
            input logic clk, reset_n, // 1MHz clock and Active-low reset
            output logic r1, y1, g1, r2, y2, g2 ); // traffic light control signals

    // Define the states as an enumeration (not macros!)
    typedef enum logic [1:0] { RG, RY, GR, YR } state_enum_t;
    state_enum_t state, next_state;  // The top-level states

    // State transition encoding
    typedef struct{
        state_enum_t next_state;
        logic [4:0] delay;
    }state_transition_s;

    // Lookup table for the state transition
    state_transition_s state_transition_lut [4] = '{
        '{RY, `YELLOW_DELAY - 1}, // RG -> RY
        '{GR, `GREEN_DELAY - 1},  // RY -> GR
        '{YR, `YELLOW_DELAY - 1}, // GR -> YR
        '{RG, `GREEN_DELAY - 1}   // YR -> RG
    };

    // light outpus struct
    typedef struct packed {
       logic r1, r2;
       logic y1, y2;
       logic g1, g2;
    } light_outputs_t;

    // Define the lookup table for each state
    light_outputs_t state_lut [4] = '{
        '{1, 0, 0, 0, 0, 1}, // RG: r1=1, g2=1
        '{1, 0, 0, 1, 0, 0}, // RY: r1=1, y2=1
        '{0, 1, 0, 0, 1, 0}, // GR: g1=1, r2=1
        '{0, 1, 1, 0, 0, 0}  // YR: y1=1, r2=1
    };

    logic [4:0] count, next_count;

    // Main Statemachine logic : wait until it counts down and then transition the state. 
    always_comb begin
        // Count down the timer
        if(count > 0) begin
            next_count = count - 1'b1;
            next_state = state;
        end else begin
            // Use the lookup table for transitions
            next_state = state_transition_lut[state].next_state;
            next_count = state_transition_lut[state].delay;
        end
    end

    // Used clock to capture the next state and the count
    always_ff @( posedge clk, negedge reset_n ) begin
        if(~reset_n) begin  // inital state GR for 30 seconds
            count <= `GREEN_DELAY;
            state <= GR;
        end else begin 
            count <= next_count;
            state <= next_state;
        end
    end

    // Output logic
    always_comb begin
        // Default all outputs to 0
        {r1, r2, y1, y2, g1, g2} = 6'b0;
        // Lookup the values based on the current state
        {r1, r2, y1, y2, g1, g2} = state_lut[state];
    end        

endmodule