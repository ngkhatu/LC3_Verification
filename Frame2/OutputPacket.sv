class OutputPacket;
// define all the signals that are o/p of lc3
logic reset, instrmem_rd, complete_instr, complete_data, Data_rd; 
logic [15:0] pc, Instr_dout, Data_addr,  Data_dout, Data_din;
// define all the internal signals that come from the probe
logic  fetch_enable_updatePC,fetch_enable_fetch,fetch_br_taken; 
logic [15:0] 		fetch_taddr;
logic 				fetch_instrmem_rd;
logic [15:0]		fetch_pc,fetch_npc_out;

endclass