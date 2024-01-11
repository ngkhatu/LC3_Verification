interface LC3_io(input bit clock);
  	
	logic reset, instrmem_rd, complete_instr, complete_data, Data_rd; 
	logic [15:0] pc, Instr_dout, Data_addr,  Data_dout, Data_din;
  	

  	clocking cb @(posedge clock);
 	default input #1 output #0;

		// instruction memory side
		input	pc; 
   		input	instrmem_rd;  
   		output Instr_dout;

		// data memory side
		input Data_din;
		input Data_rd;
		input Data_addr;		
		output Data_dout;		
		output reset;
		
		
  	endclocking

  	modport TB(clocking cb, output complete_data, output complete_instr);   //modify to include reset
endinterface


interface dut_Probe_if(	
					// fetch block interface signals
					input   logic 				fetch_enable_updatePC,fetch_enable_fetch,fetch_br_taken, 
					input   logic 		[15:0] 		fetch_taddr,
					input   logic 				fetch_instrmem_rd,
					input   logic		[15:0]		fetch_pc,fetch_npc_out,
					//decode block interface signals
					input   logic 				decode_enable_decode, 
					input   logic 		[15:0] 		decode_Instr_dout,decode_npc_out,decode_IR,decode_npc_in,
					input   logic 				decode_Mem_control,
					input   logic		[5:0]		decode_E_control,
					input	logic		[1:0]	decode_W_control,
					// input 	logic 		[2:0] 	decode_psr,
					// controller internal signals
					input	logic 	[15:0]	control_IR,
					input	logic 	[15:0]	control_IR_Exec,
					input	logic 	[15:0]	control_IMem_dout,
					input	logic 	control_complete_data,
					input 	logic 	control_complete_instr,
					input 	logic 	[2:0]	control_nzp,
					input 	logic 	[2:0] 	control_psr,
					input	logic 	control_enable_fetch,
					input	logic 	control_enable_updatePC,
					input	logic 	control_enable_decode,
					input	logic 	control_enable_execute,
					input	logic 	control_enable_writeback,					
					input 	logic 	control_br_taken,
					input 	logic 	control_bypass_alu_1,
					input 	logic 	control_bypass_alu_2,
					input 	logic 	control_bypass_mem_1,
					input 	logic 	control_bypass_mem_2,
					input 	logic 	[1:0] control_mem_state,
					//Execute signals				
					input 	logic		[5:0]	ex_E_control,
					input 	logic		[15:0] 	ex_IR,
					input 	logic		[15:0]  ex_npc_in,
					input 	logic		[15:0]  ex_VSR1,
					input 	logic		[15:0]  ex_VSR2,
					input	logic 				ex_bypass_alu_1,
					input	logic 				ex_bypass_alu_2,
					input	logic 				ex_bypass_mem_1,
					input	logic 				ex_bypass_mem_2,
					input	logic 				ex_Mem_control_in,
					input	logic 				ex_Mem_control_out,
					input	logic 				ex_enable_execute,
					input	logic		[1:0] 	ex_W_Control_in,
					input	logic		[1:0] 	ex_W_Control_out,
					input	logic		[15:0]	ex_Mem_bypass_value,
					input	logic		[15:0]	ex_M_data,
					input	logic		[15:0]	ex_IR_exec,
					input	logic		[15:0]	ex_aluout,
					input	logic		[15:0]	ex_pcout,
					input 	logic		[2:0]	ex_dr,
					input 	logic		[2:0]	ex_sr1,
					input 	logic		[2:0]	ex_sr2,
					input 	logic		[2:0]	ex_NZP,					
					//execute signal 
					input	logic [15:0]	execute_pcout,
					//writeback internal signals
					input	logic writeback_enable_writeback,
					input	logic [2:0] writeback_sr1,writeback_sr2,writeback_dr,writeback_psr,
					input	logic [15:0] writeback_aluout,writeback_memout,writeback_pcout,writeback_VSR1,writeback_VSR2,
					input 	logic [15:0] wr_R0,wr_R1,wr_R2,wr_R3,wr_R4,wr_R5,wr_R6,wr_R7,
					//memaccess internal signals
					input	logic [15:0] MemAccess_M_Data,MemAccess_M_Addr,MemAccess_DMem_dout,MemAccess_DMem_addr,MemAccess_DMem_din,
					input	logic        MemAccess_DMem_rd,MemAccess_M_Control,
					input 	logic [1:0]	 MemAccess_mem_state,writeback_W_control					
					);
endinterface

