class gmii_config extends uvm_object;
  `uvm_object_utils(gmii_config)

  bit enableClk;
  time clkPeriod;
  
  function new(string name="");
    super.new(name);
  endfunction // new

endclass // gmii_config
