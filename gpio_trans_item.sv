class gpio_trans_item extends uvm_sequence_item;
  
  //this sequence item class is for GPIO as output operation
  //to hold onto the values to be monitored after reverse-mapping
  bit[`MAX_SYNCOP-1:0] val_syncop[string];
  
  bit[`MAX_ASYNCOP-1:0] val_asyncop[string]; 
  
 	static int size_syncop[];
	static string name_syncop[];
	static int size_asyncop[];
	static string name_asyncop[];
  
  
  `uvm_object_utils(gpio_trans_item)
  function new(string name = "gpio_trans_item");
    super.new(name);
  endfunction
 endclass
