`include "def.sv"  
interface sideband_if(input clk,reset);
  

  logic [`MAX_SYNCINPUT-1:0] synchronousinput;
  logic  [`MAX_SYNCOUTPUT-1:0] synchronousoutput;
  logic [`MAX_ASYNCINPUT-1:0] asynchronousinput;
  logic [`MAX_ASYNCOUTPUT-1:0] asynchronousoutput;
  logic reset_agent;

  //---------------------------------------
  //driver clocking block
  //---------------------------------------
  clocking driver_cb @(posedge clk);
    default input #0 output #0;
  output synchronousinput;
  endclocking
  clocking monitor_cb @(posedge clk);
    default input #0 output #0;
  input synchronousoutput;
  endclocking
  //---------------------------------------
  //driver modport
  //---------------------------------------
  modport DRIVER(clocking driver_cb, input asynchronousinput);
    modport MONITOR(clocking monitor_cb, output asynchronousoutput);
  
  
endinterface
//----------------------------------------------------
      //DESIGN
//----------------------------------------------------
      
`include "uvm_macros.svh"
import uvm_pkg::*;  
      
  
module dut(
  input clk, 
  input [`MAX_SYNCINPUT-1:0] syncip,
  output reg [`MAX_SYNCOUTPUT-1:0] syncop,
  input [`MAX_ASYNCINPUT-1:0] asyncip,
  output reg [`MAX_ASYNCOUTPUT-1:0] asyncop );

      always @(posedge clk)
        begin
        syncop =syncip ;
         asyncop = asyncip; 
          `uvm_info("inside dut",$sformatf("syncip=%h", syncop),UVM_LOW); 
          `uvm_info("inside dut",$sformatf("asyncip=%h", asyncop),UVM_LOW); 
          
        end
endmodule
