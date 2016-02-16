class gmii_monitor extends uvm_monitor;
  `uvm_component_utils(gmii_monitor)
  uvm_analysis_port #(ethernet_transaction) aport;

  virtual gmii_if gmii_vif;
  int 	  unsigned pkt_count;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction // new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(gmii_config)::get(this,"","gmii_config",
					    gmii_config_h));
    gmii_vif=gmii_config_h.gmii_vif;
    aport=new("gmii_mon_export",this);
  endfunction // build_phase

  task run_phase(uvm_phase phase);
    int count;
    ethernet_tranaction txn;
    forever begin
      count=0;
      @(gmii_vif.clk);
      if(gmii_vif.valid) begin
	`uvm_info(this.get_name(),"SOP",UVM_HIGH)
	txn=ethernet_transaction::type_id::create("txn");
	pkt.bytestream.push_back(gmii_vif.data);
	count++;
	@(gmii_vif.clk);
	while(gmii_vif.valid) begin
	  pkt.bytestream.push_back(gmii_vif.data);
	  @(gmii_vif.clk);
	end
	`uvm_info(get_name(),"******EOP*****",UVM_HIGH)
	txn.unpack();
	pkt_count++;
	aport.write(txn);
      end // if (gmii_vif.valid)
    end // forever begin
  endtask // run_phase
endclass // gmii_monitor
