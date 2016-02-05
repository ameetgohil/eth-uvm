class ethernet_transaction extends uvm_sequence_item;
  `uvm_object_utils(ethernet_transaction)


  static int pkt_count=0;

  rand bit [55:0] preamble;
  rand byte sfd;
  rand bit [47:0] da;
  rand bit [47:0] sa;
  rand bit length;
  rand byte data[$];
  rand bit [31:0] fcs;
  rand bit [31:0] calc_fcs;

  rand int payload_length;

  constraint preamble_c { preamble == 56'h55555555555555555;};
  constraint sfd_c {sfd==8'hd5;};
  constraint payload_length_c { 
    payload _legnth inside {[46:1500]};
    data.size() == payload_length;};

  function new(string name="");
    super.new(name);
  endfunction // new

  virtual function string convert2string();
    string msg;
    $sformat(msg,
	     "preamble:0x%h\n
sfd:0x%h\n
da:0x%h\n
sa:0x%h\n
length:0x%h\n
data-size:0x%h\n
fcs:0x%h\n
calc_fcs:0x%h\n
payload_length:0x%h
",preamble,
	     sfd,
	     da,
	     sa,
	     length,
	     data.size(),
	     fcs,
	     calc_fcs,
	     payload_length);
    return msg;
  endfunction // convert2string

  virtual  function void do_print(uvm_printer printer);
    if(printer.knobs.sprint==0)
      $display(covert2string());
    else
      printer.m_string=convert2string();
  endfunction // do_print

  function void post_randomize();
    length=payload_length;
    do_calc_fcs;
    fcs=calc_fcs;
  endfunction // post_randomize

  task do_calc_fcs();
    byte unsigned byte_array[];
    int  unsigned num_bytes;
    bit [31:0] tmp;

    this.pack_bytes(byte_array);
    num_bytes=byte_array.size();

    calc_fcs='1;
    for(int i=8;i<num_bytes-4;i++)
      calc_fcs=nextCRC32(byte_arrary{i],calc_fcs);
    //Invert
    calc_fcs=~calc_fcs;
    //Bit Reverse
    calc_fcs={<<{calc_fcs}};
    //Byte Reverse
    calc_fcs={<<8{calc_fcs}};
  endtask // do_calc_fcs

  task pack();
    bytestream={>>{preamble,sfd,da,sa,length,data,fcs}};
  endtask // pack

  task unpack();
    {>>{preamble,sfd,da,sa,length,data,fcs}}=bytestream;
    do_calc_fcs();
  endtask // unpack

  virtual  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    ethernet_transaction RHS;
    if(!$cast(RHS,rhs)) return 0;
    else return (super.do_compare(rhs,comparer) &&
		 (this.da==RHS.da) &&
		 (this.sa==RHS.sa) &&
		 (this.length==RHS.length) &&
		 compare_data(RHS) &&
		 (this.fcs==RHS.fcs)
		 );
  endfunction // do_compare

  function bit compare_data(byte data[$]);
    bit    comp=1;
    if(this.data.size()!=data.size())
      return 0;
    foreach(data[i])
      if(this.data[i]!=data[i])
	return 0;
  endfunction // compare_data
  

  virtual  function void add_to_wave(int transaction_viewing_stream_h);
    if(transaction_view_h==0)
      transaction_view_h=$beginTransaction(transaction_viewing_stream_h,get_name(),start_time);
    $addColor(transaction_view_h,"red");
    
    $addAttribute(transaction_view_h,da,"da");
    $addAttribute(transaction_view_h,sa,"sa");
    $addAttribute(transaction_view_h,length,"length");
    $addAttribute(transaction_view_h,data,"data");
    $addAttribute(transaction_view_h,data,"fcs");
    $endTransaction(transaction_view_h,end_time);
    $freeTransaction(transaction_view_h);
  endfunction // add_to_wave

endclass // ethernet_trasaction

