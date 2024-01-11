program automatic LC3_test(LC3_if.TEST LC3if);
	
	Environment env;
	
	
	initial
		begin
		env = new();
		env.build();
		env.run()
		env.wrap_up();
		
		
		@LC3if.cb;
		
		@LC3if.cb;
		$display("%0t", $time);
		
		@LC3if.cb;
		@LC3if.cb;
		@LC3if.cb;
		
		
		
		
		
		$finish;
		end
		
	task golden_ref();
	
	endtask

endprogram