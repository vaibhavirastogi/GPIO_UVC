class gpio_sequence extends uvm_sequence#(gpio_seq_item_ext);
  `uvm_object_utils(gpio_sequence)
  gpio_seq_item_ext req;
  //here an instance is created of gpio_seq_item_ext and not it's parent class. as the child class will have both the child and parent members
  
  function new(string name = "gpio_sequence");
    super.new(name);
  endfunction
  
  `uvm_declare_p_sequencer(gpio_sequencer)
  

  task body();
    req = gpio_seq_item_ext::type_id::create("req");
    
  repeat(`NO_TRANSCATION) begin
      
 
      wait_for_grant();
    //if current time is greater than time mentioned by user where modification
    //is required, then disable rand mode for value array and then change value
    if(($time>req.change_syncip.at_time || $time>req.change_asyncip.at_time) )
      //now change_syncip is a struct member of gpio_seq_item_ext so its being used here
      begin
        if($time>req.change_syncip.at_time)
          begin
            req.val_sync.rand_mode(0);
            req.randomize();
            //req.val_syncip.rand_mode(1);
            req.val_syncip[req.change_syncip.name]=req.change_syncip.val; 

          end
        if($time>req.change_asyncip.at_time)
          begin
            req.val_async.rand_mode(0);
            req.randomize();
            //req.val_asyncip.rand_mode(1);
            req.val_asyncip[req.change_asyncip.name]=req.change_asyncip.val; 

          end
      end
    else
      //if the user doesn't want any modification yet, or its not yet time for that modification, then do regular randomization for each transaction
      begin
        req.rand_mode(1);
        req.randomize(); //this will randomize the members from the parent class
      end
    //`uvm_info("in seq",$sformatf("syncip=%0p", req.val_syncip),UVM_LOW);
      //`uvm_info("in seq",$sformatf("asyncip=%0p", req.val_asyncip),UVM_LOW);
    send_request(req);
    wait_for_item_done();
  end 
  endtask
endclass
