class Generator
	mailbox#(Transaction) gen2drv;
	Transaction tr;
	
	function new(input mailbox#(Transaction) gen2drv);
		this.gen2drv = gen2drv;
	endfunction
	
	virtual task run (input int num_tr = 10);
		repeat (num_tr)
			begin
			tr = new();
			'SV_RAND_CHECK(tr.randomize());
			gen2drv.put(tr.copy());
			end
	endtask
	
endclass
