// File: adcinterface.sv                                      
 // Description: adcinterface module to integrate ltc2308 adc  
 // Author: Taewoo Kim                                          
 // Date: 2025-02-10                                            

module adcinterface( 
                        input logic clk, reset_n,   // clock and reset signals: 'clk' for timing, 'reset_n' active low reset.
                        input logic [2:0] chan,     // ADC channel to sample, 3 bits wide to select channel and configuration bits.
                        output logic [11:0] result, // 12-bit ADC result output from the ADC conversion.
                        
                        // ltc2308 signals 
                        output logic ADC_CONVST, ADC_SCK, ADC_SDI, 
                        input logic ADC_SDO 
                        ); 

    // patterns:
    //
    // ADC_CONVST	Output	Conversion Start – Triggers ADC conversion.
    // ADC_SCK	    Output	Serial Clock – Clocks data in/out (like SPI).
    // ADC_SDI	    Output	Serial Data Input – Sends config commands to ADC.
    // ADC_SDO	    Input	Serial Data Output – Receives 12-bit ADC result.

    /*        
        adc_counter	ADC_CONVST	ADC_SCK	    Event
        0	        1	        0	        Start ADC conversion (Pulse CONVST).
        1	        0	        0	        Hold CONVST low for 1 cycle.
        2-13	    0	        clk	        Toggle SCK for 12 cycles (data transfer).
        14-15	    0	        0	        Wait before restart.
    */

    logic [3:0] adc_counter;  // 4-bit counter to keep track of the ADC state sequence.
    logic [5:0] SDI_init;     // 6-bit register used to hold and shift out configuration bits to the ADC.
    logic [11:0] SDO_temp;    // Temporary 12-bit register to hold serial data received from ADC before finalizing.

    // Combinational block: defines outputs ADC_SDI, ADC_CONVST, and ADC_SCK based on adc_counter and clock.
    always_comb begin
        ADC_SDI = SDI_init[5];   // Drive ADC_SDI with the most significant bit of the configuration register.
        ADC_CONVST = (adc_counter == 4'd0) ? 1'b1 : 1'b0;  // Generate a high pulse on ADC_CONVST when adc_counter is 0, triggering a conversion.
        // For ADC_SCK, during states 2 to 13, output the system clock to drive ADC_SCK; otherwise, hold it low.
        ADC_SCK = (adc_counter >= 2 && adc_counter <= 13) ? clk : 1'b0; 
    end

    // Sequential block: Negative edge of clock or negative reset, updating the adc_counter.
    always_ff @(negedge clk, negedge reset_n) begin
        if(~reset_n) begin
            adc_counter <= 4'd0;  // On reset (active low), initialize adc_counter to 0.
        end else adc_counter <= adc_counter + 1'b1;  // Otherwise, increment the adc_counter by 1 on every negative edge of clk.
    end

    /*
        S/D = SINGLE-ENDED/DIFFERENTIAL BIT
        O/S = ODD/SIGN BIT
        S1 = ADDRESS SELECT BIT 1
        S0 = ADDRESS SELECT BIT 0
        UNI = UNIPOLAR/BIPOLAR BIT
        SLP = SLEEP MODE BIT
    */

    // Sequential block: Sets up the configuration bits for the ADC (SDI_init) based on the ADC_CONVST and adc_counter.
    always_ff @(posedge ADC_CONVST, negedge ADC_SCK) begin
        if (ADC_CONVST) begin
            // On the rising edge of ADC_CONVST, load SDI_init with the configuration bits:
            // Bit breakdown: 
            //   - Single-Ended = 1,
            //   - Odd bit is taken from chan[0],
            //   - Next two bits (S1:S0) from chan[2:1],
            //   - Unipolar = 1,
            //   - Sleep = 0.
            SDI_init <= { 1'b1, chan[0], chan[2:1], 1'b1, 1'b0 };
        end
        else if (adc_counter >= 4'd2 && adc_counter <= 4'd7) begin
            // Between adc_counter values 2 and 7, shift SDI_init left by one bit.
            // The left shift moves the current MSB out and introduces a 0 at the LSB.
            SDI_init <= {SDI_init[4:0], 1'b0};  
        end

    end

    // Sequential block: Captures ADC_SDO data into SDO_temp on the positive edge of ADC_SCK or negative reset.
    always_ff @(posedge ADC_SCK, negedge reset_n) begin
        if (~reset_n) begin
            SDO_temp <= 12'b0;  // On reset, clear the temporary data register.
        end 
        else if (adc_counter >= 2 && adc_counter <= 13) begin
            // During the data transfer phase (adc_counter from 2 to 13), shift in ADC_SDO bit by bit.
            // The previous 11 bits in SDO_temp are shifted left, and the new bit is concatenated at LSB.
            SDO_temp <= {SDO_temp[10:0], ADC_SDO};
        end
    end

    // Sequential block: At the negative edge of ADC_SCK, finalize and store the conversion result.
    always_ff @(negedge ADC_SCK, negedge reset_n) begin
        if (~reset_n) begin
            result <= 12'b0;  // On reset, clear the final ADC result.
        end
        else if (adc_counter == 13) begin
            result <= SDO_temp;  // When adc_counter reaches 13, assign the captured 12-bit data to result.
        end
    end

endmodule 
