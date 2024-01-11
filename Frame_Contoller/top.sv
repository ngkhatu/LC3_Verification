
module LC3_test_top;
	parameter simulation_cycle = 20;

	reg  SysClock;
	LC3_io top_io(SysClock);  // Instantiate the top level interface of the testbench to be used for driving the LC3 and reading the LC3 outputs.
	
	// Instantiating and Connecting the probe signals for the Fetch block with the DUT fetch block signals using the "dut" instantation of LC3 below.
	dut_Probe_if dut_io (	
					//fetch signals
					.fetch_enable_updatePC(dut.Fetch.enable_updatePC), 
					.fetch_enable_fetch(dut.Fetch.enable_fetch), 
					.fetch_pc(dut.Fetch.pc), 
					.fetch_npc_out(dut.Fetch.npc_out),
					.fetch_instrmem_rd(dut.Fetch.instrmem_rd),
					.fetch_taddr(dut.Fetch.taddr),
					.fetch_br_taken(dut.Fetch.br_taken),
					//decode signals
					.decode_npc_in(dut.Dec.npc_in),
					.decode_Instr_dout(dut.Dec.dout),
					.decode_npc_out(dut.Dec.npc_out),					
					.decode_enable_decode(dut.Dec.enable_decode),					
					.decode_E_control(dut.Dec.E_Control),
					.decode_W_control(dut.Dec.W_Control), 
					.decode_Mem_control(dut.Dec.Mem_Control),
					.decode_IR(dut.Dec.IR),	
					//control signals
					.control_IR(dut.Ctrl.IR),
					.control_IR_Exec(dut.Ctrl.IR_Exec),
					.control_IMem_dout(dut.Ctrl.Instr_dout),
					.control_complete_data(dut.Ctrl.complete_data),
					.control_complete_instr(dut.Ctrl.complete_instr),
					.control_nzp(dut.Ctrl.NZP),
					.control_psr(dut.Ctrl.psr),					
					.control_enable_fetch(dut.Ctrl.enable_fetch),
					.control_enable_updatePC(dut.Ctrl.enable_updatePC),
					.control_br_taken(dut.Ctrl.br_taken),
					.control_enable_decode(dut.Ctrl.enable_decode),
					.control_enable_execute(dut.Ctrl.enable_execute),
					.control_enable_writeback(dut.Ctrl.enable_writeback),					
					.control_bypass_alu_1(dut.Ctrl.bypass_alu_1),
					.control_bypass_alu_2(dut.Ctrl.bypass_alu_2),
					.control_bypass_mem_1(dut.Ctrl.bypass_mem_1),
					.control_bypass_mem_2(dut.Ctrl.bypass_mem_2),
					.control_mem_state(dut.Ctrl.mem_state),
					.execute_pcout(dut.Ex.pcout),
					// execute final signals					
					.ex_E_control(dut.Ex.E_Control),
					.ex_IR(dut.Ex.IR), 
					.ex_npc_in(dut.Ex.npc),
					.ex_VSR1(dut.Ex.VSR1),
					.ex_VSR2(dut.Ex.VSR2),
					.ex_bypass_alu_1(dut.Ex.bypass_alu_1),
					.ex_bypass_alu_2(dut.Ex.bypass_alu_2),
					.ex_bypass_mem_1(dut.Ex.bypass_mem_1),
					.ex_bypass_mem_2(dut.Ex.bypass_mem_2),
					.ex_Mem_control_in(dut.Ex.Mem_Control_in),
					.ex_Mem_control_out(dut.Ex.Mem_Control_out),
					.ex_enable_execute(dut.Ex.enable_execute),
					.ex_W_Control_in(dut.Ex.W_Control_in),
					.ex_W_Control_out(dut.Ex.W_Control_out),
					.ex_Mem_bypass_value(dut.Ex.Mem_Bypass_Val), 
					.ex_M_data(dut.Ex.M_Data),
					.ex_IR_exec(dut.Ex.IR_Exec),
					.ex_aluout(dut.Ex.aluout),
					.ex_pcout(dut.Ex.pcout),
					.ex_dr(dut.Ex.dr), 
					.ex_sr1(dut.Ex.sr1), 
					.ex_sr2(dut.Ex.sr2), 
					.ex_NZP(dut.Ex.NZP),					
					//writeback signals
					.writeback_enable_writeback(dut.WB.enable_writeback),
					.writeback_W_control(dut.WB.W_Control),
					.writeback_aluout(dut.WB.aluout),
					.writeback_memout(dut.WB.memout),
					.writeback_pcout(dut.WB.pcout),
					.writeback_sr1(dut.WB.sr1),
					.writeback_sr2(dut.WB.sr2),
					.writeback_dr(dut.WB.dr),
					.writeback_psr(dut.WB.psr),
					.writeback_VSR1(dut.WB.d1),
					.writeback_VSR2(dut.WB.d2),
					.wr_R0(dut.WB.RF.R0),.wr_R1(dut.WB.RF.R1),.wr_R2(dut.WB.RF.R2),.wr_R3(dut.WB.RF.R3),.wr_R4(dut.WB.RF.R4),
					.wr_R5(dut.WB.RF.R5),.wr_R6(dut.WB.RF.R6),.wr_R7(dut.WB.RF.R7),
					//memaccess signals
					.MemAccess_M_Data(dut.MemAccess.M_Data),
					.MemAccess_M_Addr(dut.MemAccess.M_Addr),
					.MemAccess_DMem_dout(dut.MemAccess.Data_dout),
					.MemAccess_DMem_addr(dut.MemAccess.Data_addr),
					.MemAccess_DMem_din(dut.MemAccess.Data_din),
					.MemAccess_DMem_rd(dut.MemAccess.Data_rd),
					.MemAccess_M_Control(dut.MemAccess.M_Control),
					.MemAccess_mem_state(dut.MemAccess.mem_state)					
				);
				
	// Passing the top level interface and probe interface to the testbench.
	testbench test(top_io,dut_io); 
	 
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

