module vendingMachine_tb();

  logic clk, reset_n, nickel, dime, quarter, valid;
  
  vendingMachine dut ( .valid(valid), .nickel(nickel), .dime(dime), .quarter(quarter), .clk(clk), .reset_n(reset_n) );
  
    always #5 clk = ~clk;
  
  initial begin
    reset_n = 0;
    nickel = 0;
    dime = 0;
    quarter = 0;
    
    clk = 0;           
    reset_n = 0;       
    #10 reset_n = 1;   
    
    
    @(posedge clk);
    dime = 1;
    @(posedge clk);
    dime = 0;
    if (valid == 0) $display("PASS: After dime deposit, valid is 0 as expected.");
    else $display("FAIL: After dime deposit, valid expected 0 but got %b", valid);
      
      
    // put nickel
    // now we should have 15 cents
    @(posedge clk);
    nickel = 1;
    @(posedge clk);
    nickel = 0;
    if (valid == 0) $display("PASS: After dime nickel, valid is 0 as expected.");
    else $display("FAIL: After dime nickel, valid expected 0 but got %b", valid);

    // put quarter
    // now we should have 40 cents
    @(posedge clk);
    quarter = 1;
    @(posedge clk);
    quarter = 0;
    if (valid == 0) $display("PASS: After first quarter deposit, valid is 0 as expected.");
    else $display("FAIL: After first quarter deposit, valid expected 0 but got %b", valid);
      
      
    // put quarter
    // now we should have 65 cents
    @(posedge clk);
    quarter = 1;
    @(posedge clk);
    quarter = 0;
    if (valid == 0) $display("PASS: After second quarter deposit, valid is 0 as expected.");
    else $display("FAIL: After second quarter deposit, valid expected 0 but got %b", valid);

    // put quarter
    // now we should have 90 cents
    @(posedge clk);
    quarter = 1;
    @(posedge clk);
    quarter = 0;
    if (valid == 0) $display("PASS: After third quarter deposit, valid is 0 as expected.");
    else $display("FAIL: After third quarter deposit, valid expected 0 but got %b", valid);
      
    // put dime
    // now we should have 100 cents
    @(posedge clk);
    dime = 1;
    @(posedge clk);
    dime = 0;
    @(posedge clk);
    if (valid == 1) $display("PASS: After final dime deposit, valid asserted as expected.");
    else $display("FAIL: After final dime deposit, valid expected 1 but got %b", valid);

    // End of simulation
    $display("Testbench completed.");
    $finish;
  end

endmodule