
//********************************************************************                                        
//  AUTHOR: Engineering Design Institute/ASIC Design and Verification	                                                     		
//  DESCRIPTION: Arbiter Interface                                        
//  MODULE NAME: arb_if
//********************************************************************
 `timescale 10 ns / 1 ps

 interface LC3_if(input bit clk);
	
	// Testbench Inputs
	logic instrmem_rd, Data_rd;
	logic [15:0] pc, Data_addr, Data_din;
	
	// Testbench Outputs
	logic reset, complete_instr, complete_data;
	logic [15:0] Instr_dout, Data_dout;
	
	
	
	
	logic [1:0] grant, request;
	logic reset;
	
	
	
	
	clocking cb @(posedge clk);

	
	endclocking
	
	modport TEST (clocking cb, reset, pc, , Instr_dout, Data_addr, complete_instr_complete_data, Data_din, Data_dout, Data_rd);
	
	modport Fetch (clk, reset, enable_updatePC, enable_fetch, pc, npc_out, instrmem_rd, pcout, br_taken);
	modport Decode (clk, reset, enable_decode, Instr_dout, E_Control, npc_out_fetch, Mem_Control, W_Control, IR, npc_out_dec);
	modport Execute (clk, reset, E_Control, bypass_alu_1, bypass_alu_2, IR, npc_out_dec, W_Control, Mem_Control, VSR1, VSR2, bypass_mem_1, bypass_mem_2, memout, enable_execute, W_Control_out, Mem_Control_out, aluout_pcout, sr1, sr2, dr, M_Data, NZP, IR_Exec);
	modport MemAccess (mem_state, Mem_Control_out, M_Data, pcout, memout, Data_addr, Data_din, Data_dout, Data_rd);
	modport Writeback (clk, reset, enable_writeback, W_Control_out, aluout, memout, pcout, npc_out_dec, sr1, sr2, dr, VSR1, VSR2, psr);
	modport Controller (clk, reset, IR, complete_data, complete_instr, bypass_alu_1, bypass_alu_2, bypass_mem_1, bypass_mem_2, enable_fetch, enable_decode, enable_execute, enable_writeback, enable_updatePC, mem_state, NZP, psr, IR_Exec, Instr_dout, br_taken);
	
 endinterface: arb_if

 

 
 
 