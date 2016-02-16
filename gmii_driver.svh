class gmii_driver extends uvm_driver #(ethernet_transaction);
  `uvm_component_utils(gmii_driver)

  virtual gmii_if gmii_vif;
  ethernet_transaction txn;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction // new

  function void build_pahse(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(gmii_config)::get(this,"","gmii_config",
					    gmii_config_h));
    gmii_vif=gmii_config_h.gmii_vif;
  endfunction // build_pahse

  task run_phase(uvm_phase phase);
    fork
      gmii_vif.run_clk(gmii_vif.clkPeriod);
      forever begin
	gmii_vif.o_valid=0;
	gmii_vif.o_data=0;
	gmii_vif.o_err=0;
	
	//Wait for reset to finish
	wait(gmii_vif.config_busy==0);
	wait(gmii_vif.config_busy==1);
	wait(gmii_vif.config_busy==0);
	`uvm_info(get_name(),"Waiting for transaction...",UVM_HIGH);
	seq_item_port.get_next_item(txn);
	`uvm_info(get_name(),"Starting transaction",UVM_HIGH)
	drive(txn);
	seq_item_port.item_done(txn);
	
	//Inter packet gap
	repeat(200)@(gmii_vif.clk);
      end
    join
  endtask // run_phase

  task drive(ethernet_transaction txn);
    txn.pack();
    foreach(txn.bytestream[i]) begin
      @(gmii_vif.clk);
      gmii_vif.o_valid=1;
      gmii_vif.o_err=0;
      gmii_vif.o_data=txn.bytestream[i];
    end
    @(gmii_vif.clk);
    gmii_vif.o_valid=0;
  endtask // drive
endclass
