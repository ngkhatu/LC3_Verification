class OutputPacket;
// define all the signals that are o/p of lc3
logic reset, instrmem_rd, complete_instr, complete_data, Data_rd; 
logic [15:0] pc, Instr_dout, Data_addr,  Data_dout, Data_din;
// define all the internal signals that come from the probe
//define signals for stage fetch
logic  fetch_enable_updatePC,fetch_enable_fetch,fetch_br_taken; 
logic [15:0] 		fetch_taddr;
logic 				fetch_instrmem_rd;
logic [15:0]		fetch_pc,fetch_npc_out;
//define signals for stage decode
logic 				decode_enable_decode; 
logic 		[15:0] 		decode_Instr_dout,decode_npc_out,decode_IR,decode_npc_in;
logic 				decode_Mem_control;
logic		[5:0]		decode_E_control;
logic		[1:0]	decode_W_control;
logic 		[2:0] 	decode_psr;

// Execute signals
logic	[5:0]	ex_E_control;
logic	[15:0] 	ex_IR, ex_npc_in,ex_VSR1,ex_VSR2;
logic 			ex_bypass_alu_1,ex_bypass_alu_2,ex_bypass_mem_1,ex_bypass_mem_2,ex_Mem_control_in,ex_Mem_control_out,ex_enable_execute;
logic	[1:0] 	ex_W_Control_in,ex_W_Control_out;
logic	[15:0]	ex_Mem_bypass_value, ex_M_data,ex_IR_exec,ex_aluout,ex_pcout;
logic	[2:0]	ex_dr, ex_sr1, ex_sr2, ex_NZP;

// controller signals 
logic 	[15:0]	control_IR;
logic 	[15:0]	control_IR_Exec;
logic 	[15:0]	control_IMem_dout;
logic 	control_complete_data;
logic 	control_complete_instr;
logic 	[2:0]	control_nzp;
logic 	[2:0] 	control_psr;
logic 	control_enable_fetch;
logic 	control_enable_updatePC;
logic 	control_enable_decode;
logic 	control_enable_execute;
logic 	control_enable_writeback;					
logic 	control_br_taken;
logic 	control_bypass_alu_1;
logic 	control_bypass_alu_2;
logic 	control_bypass_mem_1;
logic 	control_bypass_mem_2;
logic [1:0] control_mem_state;


//define signals for stage writeback
logic writeback_enable_writeback;
logic [2:0] writeback_sr1,writeback_sr2,writeback_dr,writeback_psr;
logic [15:0] writeback_aluout,writeback_memout,writeback_pcout,writeback_VSR1,writeback_VSR2;
logic [15:0] wr_R0,wr_R1,wr_R2,wr_R3,wr_R4,wr_R5,wr_R6,wr_R7;
//define signals for stage memaccess
logic [15:0] MemAccess_M_Data,MemAccess_M_Addr,MemAccess_DMem_dout,MemAccess_DMem_addr,MemAccess_DMem_din;
logic        MemAccess_DMem_rd,MemAccess_M_Control;
logic [1:0]	 MemAccess_mem_state,writeback_W_control;

//execute signals 
logic [15:0] execute_pcout;

endclass