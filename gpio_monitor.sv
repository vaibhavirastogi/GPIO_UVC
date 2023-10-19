class gpio_monitor extends uvm_monitor;
  agent_config cfg_obj;
  virtual sideband_if vif;

  uvm_analysis_port #(gpio_trans_item) item_collected_port;

  gpio_trans_item trans; //now here we are instantiating the output vala txn item, not the driving one

  `uvm_component_utils(gpio_monitor)

  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sideband_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    uvm_config_db#(agent_config)::get(null, "", "cfg_obj", cfg_obj);

  endfunction: build_phase
  
  virtual task run_phase(uvm_phase phase);
    //names and sizes are being assigned to trans_item, the actual values will be picked from interface
    gpio_trans_item::size_syncop=cfg_obj.size_syncop;
    gpio_trans_item::size_asyncop=cfg_obj.size_asyncop;
    gpio_trans_item::name_syncop=cfg_obj.name_syncop;
    gpio_trans_item::name_asyncop=cfg_obj.name_asyncop;
    forever begin
    fork
        begin
          @(vif.asynchronousoutput)
          trans = cfg_obj.put_val_asyncop(vif.MONITOR.asynchronousoutput,trans);
          
        end
        begin
          @(vif.driver_cb)
          trans  =  cfg_obj.put_val_syncop(vif.MONITOR.monitor_cb.synchronousoutput,trans);
          
         
        end       
      join
       item_collected_port.write(trans);
      
      //printing the values collected from interface and stored in txn item
      foreach(trans.name_syncop[i]) 
        `uvm_info("mon",$sformatf("syncop %s = %h", trans.name_syncop[i], trans.val_syncop[trans.name_syncop[i]]),UVM_LOW);
      foreach(trans.name_asyncop[i]) 
        `uvm_info("mon",$sformatf("asyncop %s = %h", trans.name_asyncop[i], trans.val_asyncop[trans.name_asyncop[i]]),UVM_LOW);
      
                  
            
    end 
  endtask : run_phase

endclass : gpio_monitor
