`include "include_file.sv"
module top;
  
  bit clk=1;
  bit reset;
  

  always #5 clk = ~clk; //clock time period is 10ns
  

  initial begin
    reset = 1;
    #5 reset =0;
  end
  

  sideband_if intf(clk,reset); 
  

    

  initial begin 
    uvm_config_db#(virtual sideband_if)::set(uvm_root::get(),"*","vif",intf);

    $dumpfile("dump.vcd"); 
    $dumpvars;
  end

  initial begin 
    run_test("gpio_test");
  end

dut dut1(intf.clk,intf.synchronousinput,intf.synchronousoutput,intf.asynchronousinput,intf.asynchronousoutput);
  //now we instantiate intf, and instantiate dut while connecting intf and dut
  
endmodule




