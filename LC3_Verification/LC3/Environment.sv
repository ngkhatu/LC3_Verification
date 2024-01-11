class Environment;
	Generator gen;
	Agent age;
	Driver drv;
	Scoreboard s_board;
	Assertions asser;
	Checker check;
	Monitor mon;
	
	mailbox#(Transaction) gen2drv;

	virtual function void build();
		gen2drv = new();
		gen = new(gen2drv);
		drv = new(gen2drv);
	
	endfunction
	
	
	virtual task run();
		fork
			gen.run();
			drv.run();
		join	
	endtask
	
	virtual task wrap_up();
	
	endtask
	

endclass