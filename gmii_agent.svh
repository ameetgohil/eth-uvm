class gmii_agent extends uvm_agent;
  `uvm_component_utils(gmii_agent)

  uvm_analysis_port #(ethernet_transaction) aport;

  gmii_sequencer gmii_sequencer_h;
  gmii_driver gmii_driver_h;
  gmii_monitor gmii_monitor_h;
  gmii_config gmii_config_h;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction // new

  function void build_phase(uvm_phase phase);
    aport=new("gmii_agent_export",this);
    gmii_sequencer_h=gmii_sequencer::type_id:create("gmii_sequencer_h",this);
    gmii_driver_h=gmii_driver::type_id::create("gmii_driver_h",this);
    gmii_monitor_h=gmii_monitor::type_id::create("gmii_monitor_h",this);

    assert(uvm_config_db #(gmii_conifg)::get(this,"","gmii_config",gmii_config_h));
    if(!uvm_config_db #(virtual gmii_if)::get(this,"","gmii_vif",gmii_config_h.gmii_vif))
      `uvm_fatal("NOVIF","No virtual interface set")
  endfunction // build_phase

  function void connect_phase(uvm_phase phase);
    gmii_driver_h.seq_item_port.connect(gmii_sequencer_h.seq_item_export);
    gmii_monitor_h.aport.connect(aport);
  endfunction // connect_phase

endclass // gmii_agent
