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
					input   logic		[15:0]		fetch_pc,fetch_npc_out
					);
endinterface
