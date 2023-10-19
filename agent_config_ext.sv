class agent_config_ext extends agent_config;
  `uvm_object_utils(agent_config_ext)
  function new(string name = "agent_config_ext");
    super.new(name);
  endfunction
    
  task run();
    //-----------------------------------------------------
    //---GPIO USAGE AS INPUT-----
    //---USER HAS TO ENTER INPUT HERE-----
    
    //synchronous input
    this.name_syncip='{"alpha","beta","camma"};
    this.size_syncip='{4,4,8};
    this.resetval_syncip='{"alpha":1'hA, "beta":1'hB, "camma":2'hAB};
    //asynchronous input
    this.name_asyncip='{"bella","jacob","edward"};
    this.size_asyncip='{4, 4, 8};
    this.resetval_asyncip='{"bella":1'hD, "jacob":1'hE, "edward":2'hDE};
    //-----------------------------------------------------
	//---GPIO USAGE AS OUTPUT-----
    //synchronous output
    this.name_syncop='{"alpha","beta","camma"};
    this.size_syncop='{4,4,8};
    //asynchronous output
 	this.name_asyncop='{"bella","jacob","edward"};
    this.size_asyncop='{4, 4, 8};
    //-----------------------------------------------------

    //#14 this.reset_agent=1;
    endtask : run

    
    
  endclass: agent_config_ext

