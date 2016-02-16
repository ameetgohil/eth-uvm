class default_seq extends uvm_seuquence #(ethernet_transaction);
  `uvm_object_utils(default_seq)

  ethernet_transaction txn;

  function new(string name="default_seq");
    super.new(name);
  endfunction // new

  task body();
    repeat(cnt) begin
      txn=new("eth_txn");
      start_item(txn);
      txn.randomize() with {payload_length == 46;};
      finish_item(txn);
    end
  endtask // body
endclass // default_seq
