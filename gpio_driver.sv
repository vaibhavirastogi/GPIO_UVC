`define DRIV_IF vif.DRIVER.driver_cb
class gpio_driver extends uvm_driver #(gpio_seq_item_ext); //parametrized by the transaction item

  //--------------------------------------- 
  // Virtual Interface
  //--------------------------------------- 
  virtual sideband_if vif;
  agent_config cfg_obj;  //now this is the first file in our flow that needs config_obj 
  gpio_seq_item set_static;
  `uvm_component_utils(gpio_driver)
    
  //--------------------------------------- 
  // Constructor
  //--------------------------------------- 
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //--------------------------------------- 
  // build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sideband_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    uvm_config_db#(agent_config)::get(null, "", "cfg_obj", cfg_obj);
    
    //we "Get" the config db and virtual interface in build phase
  
  endfunction: build_phase

  //---------------------------------------  
  // run phase
  //---------------------------------------  
  task run_phase(uvm_phase phase);
    set_static =new();
    //assigning cfg object fields to seq item
      gpio_seq_item::size_syncip=cfg_obj.size_syncip;
      gpio_seq_item::size_asyncip=cfg_obj.size_asyncip;
      gpio_seq_item::name_syncip=cfg_obj.name_syncip;
      gpio_seq_item::name_asyncip=cfg_obj.name_asyncip;
    forever begin
      seq_item_port.get_next_item(req);
   
      //printing what you got from sequencer
      foreach(req.name_syncip[i]) 
        `uvm_info("driver",$sformatf("syncip %s = %h", req.name_syncip[i], req.val_syncip[req.name_syncip[i]]),UVM_LOW);
      foreach(req.name_asyncip[i]) 
        `uvm_info("driver",$sformatf("asyncip %s = %h", req.name_asyncip[i], req.val_asyncip[req.name_asyncip[i]]),UVM_LOW);
      
      
      drive();

      seq_item_port.item_done(); //recall that seq_item_port needs no declaration in driver code but analysis ports will need declaration in monitor
    end
  endtask : run_phase
  
  //---------------------------------------
  // drive - transaction level to signal level
  // drives the value's from seq_item to interface signals
  //---------------------------------------
  virtual task drive();
    
      fork
        begin
            vif.DRIVER.asynchronousinput <= cfg_obj.get_val_asyncip(req.val_asyncip);
        end
        
        begin
            `DRIV_IF.synchronousinput <= cfg_obj.get_val_syncip(req.val_syncip);              
          @(vif.driver_cb);
          
        end
        
        
      join

    
  endtask : drive
endclass : gpio_driver
