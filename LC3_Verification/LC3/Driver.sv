class Driver
	mailbox#(Transaction) gen2drv;
	
	function new(input mailbox$(Transaction) gen2drv);
		this.gen2drv = gen2drv;
	endfunction
	
	
	virtual task run();
		Transaction tr;
		
		forever
			begin
			
			gen2drv.get(tr);
			tr.calc_csm();
		
			end
	endtask
	
	
	
endclass

