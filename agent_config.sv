class agent_config extends uvm_object;
  int size_syncip[];
  string name_syncip[];
  bit[`MAX_SYNCOP-1:0] resetval_syncip[string];
  
  
   int size_asyncip[];
  string name_asyncip[]; 
  bit[`MAX_ASYNCOP-1:0] resetval_asyncip[string];
  
  int size_syncop[];
  string name_syncop[];
  
   int size_asyncop[];
  string name_asyncop[]; 
  
  bit reset_agent;
  `uvm_object_utils(agent_config)
  function new(string name = "agent_config");
    super.new(name);
  endfunction
        
 //------------------------------------------------------------------------     
//Function for mapping synchronous user-input signals to interface/TB signals        //----------------------------------------------------------------------                    
  function bit [`MAX_SYNCINPUT-1:0] get_val_syncip(bit [`MAX_SYNCOP-1:0] val_syncip[string]);
    //the return type is bit and range is [`MAX_SYNCINPUT-1:0] which is the same as on the interface, so this function will be returning to the interface signal, and we are passing val_syncip to this function, val_syncip is user-input signal as it is used to take input from user.
        begin

          bit [`MAX_SYNCINPUT-1:0] totip;
          int temp=0;
          for (int i=0;i<this.size_syncip.size();i++)
            begin
              	begin
              if(reset_agent==1)
                totip+=2**(temp)*resetval_syncip[name_syncip[i]];
              else
                 totip+=2**(temp)*val_syncip[name_syncip[i]];
                end
              //$display("Value of synchronousinput %0b",totip);
              temp+=size_syncip[i];
            end
          //synchronousinput=totip;
          return(totip);
          
        end
  endfunction
  //------------------------------------------------------------------
  //Function for mapping asynchronous user-input signals to interface/TB signals  
  //------------------------------------------------------------------
  function bit [`MAX_ASYNCINPUT-1:0] get_val_asyncip(bit [`MAX_ASYNCOP-1:0] val_asyncip[string]);
        begin
          bit [`MAX_ASYNCINPUT-1:0] totop;
          int temp=0;
          for (int i=0;i<size_asyncip.size();i++)
            begin
              	begin
              if(reset_agent==1)
                totop+=2**(temp)*this.resetval_asyncip[name_asyncip[i]];
              else
                totop+=2**(temp)*val_asyncip[name_asyncip[i]];
                end
              //$display("Value of asynchronousinput %0b",totop);
              temp+=size_asyncip[i];
            end
          //asynchronousinput=totop;
          return(totop);
          
        end
  endfunction
  
  //---------------------------
  //OUTPUT OPERATIONS
  //---------------------------
  
  
  //--------------------------------------------------------------------
  //Function for mapping synchronous TB/interface signals to user-input signals
  //----------------------------------------------------------------
  function gpio_trans_item put_val_syncop(logic [`MAX_SYNCOUTPUT-1:0] synchronousoutput, ref gpio_trans_item trans);
    if(size_syncop.sum()>`MAX_SYNCOUTPUT)
      `uvm_fatal("EXCEEDS_BUSWIDTH",{"User given size of synchronous outputs exceeds synchronous output bus width ","trans.syncop"});
        begin
          bit [`MAX_SYNCOUTPUT-1:0] totop=synchronousoutput;         
        
          for (int i=0;i<trans.size_syncop.size();i++)
            begin
              trans.val_syncop[trans.name_syncop[i]]=totop % (2**trans.size_syncop[i]);
              totop/=2**trans.size_syncop[i];                            
            end
        end
    return(trans);
  endfunction
   //--------------------------------------------------------------------
  //Function for mapping asynchronous TB/interface signals to user-input signals
  //-------------------------------------------------------------
  function gpio_trans_item put_val_asyncop(logic [`MAX_ASYNCOUTPUT-1:0] asynchronousoutput, ref gpio_trans_item trans);
    if(size_asyncop.sum()>`MAX_ASYNCOUTPUT)
      `uvm_fatal("EXCEEDS_BUSWIDTH",{"User given size of asynchronous outputs exceeds asynchronous output bus width ","trans.asyncop"});
        begin
          bit [`MAX_ASYNCOUTPUT-1:0] totop1=asynchronousoutput;     

          for (int i=0;i<trans.size_asyncop.size();i++)
            begin
              trans.val_asyncop[trans.name_asyncop[i]]=totop1 % (2**this.size_asyncop[i]);
              totop1/=2**trans.size_asyncop[i];                            
            end
        end
    return(trans);
  endfunction
  //-----------------------------------------------------------
  virtual task run();
    $display("Inside Configuration agent class");
  endtask

    
  endclass: agent_config
