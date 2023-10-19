class gpio_seq_item_ext extends gpio_seq_item;
  //now this class will have all the items of it's parent class gpio_Seq_item, so the stuff here will be an add-on
  
  
  //structure for change value operation
  struct{
    string name;
    bit [`MAX_SYNCOP-1:0] val;
    time at_time;  
  } change_syncip,change_asyncip;
  
  
  function new(string name = "gpio_seq_item_ext");
    super.new(name);
    //-----------------------------------------
    //User has to enter name,value and time for
    //value change operation here
    change_syncip='{"camma",2'hFF,140};
    change_asyncip='{"edward",2'hFF,60};
    //----------------------------------------
  endfunction
  
  
  `uvm_object_utils(gpio_seq_item_ext)
  
  //below two functions don't have anything except super.func, but its needed because we need the parent's functions too! So the super does exactly that, it accesses the parent class gpio_seq_item's pre_randomize and post_randomize function
  
  function void pre_randomize();
    super.pre_randomize();

  endfunction
  
    function void post_randomize();
    super.post_randomize();

  endfunction
  
  
endclass

  
  
