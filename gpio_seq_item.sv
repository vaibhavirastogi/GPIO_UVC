typedef class agent_config;
class gpio_seq_item extends uvm_sequence_item;
 
  //Associative arrays for holding values of user-inputs
  //associative array indexed by strings
  //[`MAX_SYNCOP-1:0] denotes the bit limits
  bit[`MAX_SYNCOP-1:0] val_syncip[string];  //string being mod, value being 10, for example
  bit[`MAX_ASYNCOP-1:0] val_asyncip[string];
  
  rand bit[`MAX_SYNCOP-1:0] val_sync[int];  
  rand bit[`MAX_ASYNCOP-1:0] val_async[int]; //now these are rand 
  //The basic idea is that for input operation, initially reset values will apply that the user has provided, then these randomized values will apply, then later at a certain time some other hardcoded values will apply which is again given by user in gpio_Seq_item_Ext class
  
  //Dynamic arrays for holding size divisions of each interface bus
  //as well as name assigned to each division
  
  //dynamic integer/string arrays
  static int size_syncip[];  //can hold stuff like {2, 5, 7} which is size of mod, ip1, ip2, etc
  static string name_syncip[];  //can hold stuff like {mod, ip1, ip2}
  static int size_asyncip[];
  static string name_asyncip[]; 
  

  //---------------------------------------
  //Constructor
  //Initializing the value-holding arrays to 0
  //in order to randomize them with constraints
  //---------------------------------------
  function new(string name = "gpio_seq_item");
    super.new(name);
    for(int i=0;i<name_syncip.size();i++)
      val_sync[i]=0;
    for(int i=0;i<name_asyncip.size();i++)
      val_async[i]=0;    
  endfunction
  
  
  //If bus size is 16 bits, and you're providing 4 interrupts with sizes 4, 5, 2 and 8 then it cannot be accomodated in the bus, so below fatal error will show
  function void pre_randomize();
    if(size_syncip.sum()>`MAX_SYNCINPUT)
      `uvm_fatal("EXCEEDS_BUSWIDTH",{"User given size of synchronous inputs exceeds synchronous input bus width ",get_full_name(),".syncip"});
    if(size_syncip.sum()>`MAX_SYNCINPUT)
      `uvm_fatal("EXCEEDS_BUSWIDTH",{"User given size of asynchronous inputs exceeds asynchronous input bus width ",get_full_name(),".asyncip"});  
                            
  endfunction
  
  function void post_randomize();
    foreach(name_syncip[i]) 
      begin
        val_syncip[name_syncip[i]]=val_sync[i];
      end
    foreach(name_asyncip[i]) 
      begin
        val_asyncip[name_asyncip[i]]=val_async[i];
      end
  endfunction
  
  
  //set constraints that, for each field in the bus, limits its value 
  //to 2^(size)
//so "mode" which is 2 bits should be less than 4
  constraint limit_async{foreach(val_async[i]){val_async[i]<(2**size_asyncip[i]);}}
    constraint limit_sync{foreach(val_sync[i]){val_sync[i]<(2**size_syncip[i]);}}
      
  
endclass
  


