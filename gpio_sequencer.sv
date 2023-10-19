
class gpio_sequencer extends uvm_sequencer#(gpio_seq_item_ext);

  `uvm_component_utils(gpio_sequencer) 

  //---------------------------------------
  //constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass



