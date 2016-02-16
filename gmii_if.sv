interface gmii_drv_intf(clk,
			data,
			valid,
			err,
			config_busy
			);
  inout tri clk;
  inout tri [7:0] data;
  inout tri valid;
  inout tri err;
  inout tri config_busy;

  bit	    i_clk,o_clk;
  bit [7:0] i_data,o_data;
  bit 	    i_valid,o_valid;
  bit 	    i_err,o_err;
  bit 	    i_config_busy,o_config_busy;

  bit 	    active;

  assign clk = (active)?o_clk:b'z;
  assign data = (active)?o_data:b'z;
  assign valid = (active)?o_valid:b'z;
  assign err = (active)?o_err:b'z;
  assign config_busy = (active)?o_config_busy:b'z;

  assign i_clk=clk;
  assign i_data=data;
  assign i_valid=valid;
  assign i_err=valid;
  assign i_config_busy;

  clocking cb @(posedge i_clk);
    input   i_data;
    input   i_valid;
    input   i_err;
    input   i_config_busy;
    output  o_data;
    output  o_valid;
    output  o_err;
    output  o_config_busy;
  endclocking // cb

endinterface // gmii_drv_intf

