typedef class agent_config_ext;
class gpio_env extends uvm_env;

  gpio_agent      gpio_agnt;
  agent_config cfg_obj;
  //if we had a scoreboard that would also be instantiated and created here
  `uvm_component_utils(gpio_env)


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
//the agent configuration class is set in the configuration db
//to be retrieved by driver and monitor
    
    gpio_agnt = gpio_agent::type_id::create("gpio_agnt", this);
    cfg_obj=agent_config_ext::type_id::create("cfg_obj");
    uvm_config_db#(agent_config)::set(null, "*", "cfg_obj", cfg_obj);
    //so gpio agent is created here and "Set" using config-db here, it will be retrieved in driver and monitor for use 
  
     endfunction : build_phase
 
  
  
    virtual task run_phase(uvm_phase phase);

      cfg_obj.run(); //this is kinda a useless thing

  endtask


  
endclass:gpio_env

