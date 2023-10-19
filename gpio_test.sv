class gpio_test extends uvm_test;

  `uvm_component_utils(gpio_test)
  
   gpio_sequence seq; 
  //---------------------------------------
  // env instance 
  //--------------------------------------- 
  gpio_env env;

  //---------------------------------------
  // constructor
  //---------------------------------------
  function new(string name = "gpio_model_base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	seq =gpio_sequence::type_id::create("seq");
    // Create the env
    env = gpio_env::type_id::create("env", this);
  endfunction : build_phase
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.gpio_agnt.sequencer);
    phase.drop_objection(this);
    
  endtask : run_phase
  
endclass
