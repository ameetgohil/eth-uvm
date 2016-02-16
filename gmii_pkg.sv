`include "gmii_if.sv"
package gmii_pkg
`include "`uvm_macros.svh"
  import uvm_pkg::*;
  typedef uvm_sequencer#(ethernet_transaction) gmii_sequencer;

`include "gmii_config.svh"
`include "gmii_driver.svh"
`include "gmii_monitor.svh"
`include "gmii_agent.svh"
`include "gmii_sequence_lib.sv"
endpackage // gmii_pkg
  
