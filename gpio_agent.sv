class gpio_agent extends uvm_agent;

  //---------------------------------------
  // component instances
  //---------------------------------------
  gpio_driver    driver;
  gpio_sequencer sequencer;
  gpio_monitor monitor;

  `uvm_component_utils(gpio_agent)
  
  //---------------------------------------
  // constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    driver    = gpio_driver::type_id::create("driver", this);
    sequencer = gpio_sequencer::type_id::create("sequencer", this);
    monitor   = gpio_monitor::type_id::create("monitor",this);
  
  endfunction : build_phase
  
  //---------------------------------------  
  // connect_phase - connecting the driver and sequencer port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
      //if we had a scoreboard here the monitor's port woild be connected to that
    end
  endfunction : connect_phase

endclass : gpio_agent
