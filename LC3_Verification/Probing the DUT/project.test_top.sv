
module LC3_test_top;
	parameter simulation_cycle = 20;

	reg  SysClock;
	LC3_io top_io(SysClock);  // Instantiate the top level interface of the testbench to be used for driving the LC3 and reading the LC3 outputs.
	
	// Instantiating and Connecting the probe signals for the Fetch block with the DUT fetch block signals using the "dut" instantation of LC3 below.
	dut_Probe_if dut_io (	
					.fetch_enable_updatePC(dut.Fetch.enable_updatePC), 
					.fetch_enable_fetch(dut.Fetch.enable_fetch), 
					.fetch_pc(dut.Fetch.pc), 
					.fetch_npc_out(dut.Fetch.npc_out),
					.fetch_instrmem_rd(dut.Fetch.instrmem_rd),
					.fetch_taddr(dut.Fetch.taddr),
					.fetch_br_taken(dut.Fetch.br_taken)
				);

	// Passing the top level interface and probe interface to the testbench.
	LC3_test test(top_io,dut_io); 
	 
	// Instatiating the top-level DUT.
	LC3 dut(
		.clock(top_io.clock), 
		.reset(top_io.reset), 
		.pc(top_io.pc), 
		.instrmem_rd(top_io.instrmem_rd), 
		.Instr_dout(top_io.Instr_dout), 
		.Data_addr(top_io.Data_addr), 
		.complete_instr(top_io.complete_instr), 
		.complete_data(top_io.complete_data),
		.Data_din(top_io.Data_din),
		.Data_dout(top_io.Data_dout),
		.Data_rd(top_io.Data_rd)

		);

	initial 
	begin
		SysClock = 0;
		forever 
		begin
			#(simulation_cycle/2)
			SysClock = ~SysClock;
		end
	end
endmodule

