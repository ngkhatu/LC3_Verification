class ReceiverBase;
virtual LC3_io.TB lc3io;	// interface signals
virtual dut_Probe_if Prober; // Probe signals
OutputPacket   pkt2cmp;

// define all the signals that are o/p of lc3
logic reset, instrmem_rd, complete_instr, complete_data, Data_rd; 
logic [15:0] pc, Instr_dout, Data_addr,  Data_dout, Data_din;
// define all the fetch internal signals that come from the probe
logic  fetch_enable_updatePC,fetch_enable_fetch,fetch_br_taken; 
logic [15:0] 		fetch_taddr;
logic 				fetch_instrmem_rd;
logic [15:0]		fetch_pc,fetch_npc_out;
// define all the fetch internal signals that come from the probe
logic [15:0] decode_npc_in,decode_Instr_dout,decode_npc_out,decode_IR;
logic decode_enable_decode;
// logic[2:0] decode_psr;
logic[5:0] decode_E_control;
logic[1:0] decode_W_control, decode_pcselect1, decode_alu_cobtrol;
logic decode_Mem_control, decode_pcselect2, decode_op2select;

//controller signals 
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

// Execute signals 
logic [15:0]  execute_pcout;

logic[5:0] ex_E_control;
logic[15:0] ex_IR, ex_npc_in,ex_VSR1,ex_VSR2;
logic ex_bypass_alu_1,ex_bypass_alu_2,ex_bypass_mem_1,ex_bypass_mem_2,ex_Mem_control_in,ex_Mem_control_out,ex_enable_execute;
logic[1:0] ex_W_Control_in,ex_W_Control_out;
logic[15:0] ex_Mem_bypass_value, ex_M_data,ex_IR_exec,ex_aluout,ex_pcout;
logic[2:0] ex_dr, ex_sr1, ex_sr2, ex_NZP;

//define all the writeback internal signals that come from the probe
logic writeback_enable_writeback;
logic [2:0] writeback_sr1,writeback_sr2,writeback_dr,writeback_psr;
logic [15:0] writeback_aluout,writeback_memout,writeback_pcout,writeback_VSR1,writeback_VSR2;
logic [15:0] wr_R0,wr_R1,wr_R2,wr_R3,wr_R4,wr_R5,wr_R6,wr_R7;
//define all the mem access signals that come from the probe
logic [15:0] MemAccess_M_Data,MemAccess_M_Addr,MemAccess_DMem_dout,MemAccess_DMem_addr,MemAccess_DMem_din;
logic        MemAccess_DMem_rd,MemAccess_M_Control;
logic [1:0]	 MemAccess_mem_state,writeback_W_control;



extern function new(virtual LC3_io.TB lc3io, virtual dut_Probe_if Prober);
extern virtual task recv();
extern virtual task get_payload();

endclass

function ReceiverBase::new(virtual LC3_io.TB lc3io, virtual dut_Probe_if Prober);
this.lc3io=lc3io;
this.Prober=Prober;
pkt2cmp=new();
endfunction

task ReceiverBase:: recv();
int pkt_cnt = 0;
get_payload();
pkt2cmp.reset = reset;
pkt2cmp.instrmem_rd = instrmem_rd;
pkt2cmp.complete_instr = complete_instr;
pkt2cmp.complete_data = complete_data;
pkt2cmp.Data_rd = Data_rd;

pkt2cmp.pc = pc;
pkt2cmp.Instr_dout = Instr_dout;
pkt2cmp.Data_addr = Data_addr;
pkt2cmp.Data_dout = Data_dout;
pkt2cmp.Data_din = Data_din;

//internal signals 
//controller
pkt2cmp.control_IR=control_IR;
pkt2cmp.control_IR_Exec=control_IR_Exec;
pkt2cmp.control_IMem_dout=control_IMem_dout;
pkt2cmp.control_complete_data=control_complete_data;
pkt2cmp.control_complete_instr=control_complete_instr;
pkt2cmp.control_nzp=control_nzp;
pkt2cmp.control_psr=control_psr;
pkt2cmp.control_enable_fetch=control_enable_fetch;
pkt2cmp.control_enable_updatePC=control_enable_updatePC;
pkt2cmp.control_enable_decode=control_enable_decode;
pkt2cmp.control_enable_execute=control_enable_execute;
pkt2cmp.control_enable_writeback=control_enable_writeback;
pkt2cmp.control_br_taken=control_br_taken;

pkt2cmp.control_bypass_alu_1=control_bypass_alu_1;
pkt2cmp.control_bypass_alu_2=control_bypass_alu_2;
pkt2cmp.control_bypass_mem_1=control_bypass_mem_1;
pkt2cmp.control_bypass_mem_2=control_bypass_mem_2;
pkt2cmp.control_mem_state=control_mem_state;

//fetch
pkt2cmp.fetch_enable_updatePC=fetch_enable_updatePC;
pkt2cmp.fetch_enable_fetch=fetch_enable_fetch;
pkt2cmp.fetch_br_taken=fetch_br_taken;
pkt2cmp.fetch_taddr=fetch_taddr;
pkt2cmp.fetch_instrmem_rd=fetch_instrmem_rd;
pkt2cmp.fetch_pc=fetch_pc;
pkt2cmp.fetch_npc_out=fetch_npc_out;

//decode
pkt2cmp.decode_npc_in=decode_npc_in;
pkt2cmp.decode_Instr_dout=decode_Instr_dout;
pkt2cmp.decode_npc_out=decode_npc_out;
pkt2cmp.decode_IR=decode_IR;
pkt2cmp.decode_enable_decode=decode_enable_decode;
pkt2cmp.decode_E_control=decode_E_control;
pkt2cmp.decode_W_control=decode_W_control; 
pkt2cmp.decode_Mem_control=decode_Mem_control; 
// pkt2cmp.decode_psr=decode_psr;
//Execute 
pkt2cmp.execute_pcout=execute_pcout;

//Execute final
pkt2cmp.ex_E_control=ex_E_control;
pkt2cmp.ex_IR=ex_IR;
pkt2cmp.ex_npc_in=ex_npc_in;
pkt2cmp.ex_VSR1=ex_VSR1;
pkt2cmp.ex_VSR2=ex_VSR2;
pkt2cmp.ex_bypass_alu_1=ex_bypass_alu_1;
pkt2cmp.ex_bypass_alu_2=ex_bypass_alu_2;
pkt2cmp.ex_bypass_mem_1=ex_bypass_mem_1;
pkt2cmp.ex_bypass_mem_2=ex_bypass_mem_2;
pkt2cmp.ex_Mem_control_in=ex_Mem_control_in;
pkt2cmp.ex_Mem_control_out=ex_Mem_control_out;
pkt2cmp.ex_enable_execute=ex_enable_execute;
pkt2cmp.ex_W_Control_in=ex_W_Control_in;
pkt2cmp.ex_W_Control_out=ex_W_Control_out;
pkt2cmp.ex_Mem_bypass_value=ex_Mem_bypass_value;
pkt2cmp.ex_M_data=ex_M_data;
pkt2cmp.ex_IR_exec=ex_IR_exec;
pkt2cmp.ex_aluout=ex_aluout;
pkt2cmp.ex_pcout=ex_pcout;
pkt2cmp.ex_dr=ex_dr;
pkt2cmp.ex_sr1=ex_sr1;
pkt2cmp.ex_sr2=ex_sr2;
pkt2cmp.ex_NZP=ex_NZP;

//Write Back
pkt2cmp.writeback_enable_writeback=writeback_enable_writeback;
pkt2cmp.writeback_W_control=writeback_W_control;
pkt2cmp.writeback_aluout=writeback_aluout;
pkt2cmp.writeback_memout=writeback_memout;
pkt2cmp.writeback_pcout=writeback_pcout;
pkt2cmp.writeback_sr1=writeback_sr1;
pkt2cmp.writeback_sr2=writeback_sr2;
pkt2cmp.writeback_dr=writeback_dr;
pkt2cmp.writeback_psr=writeback_psr;
pkt2cmp.writeback_VSR1=writeback_VSR1;
pkt2cmp.writeback_VSR2=writeback_VSR2;
pkt2cmp.wr_R0=wr_R0;
pkt2cmp.wr_R1=wr_R1;
pkt2cmp.wr_R2=wr_R2;
pkt2cmp.wr_R3=wr_R3;
pkt2cmp.wr_R4=wr_R4;
pkt2cmp.wr_R5=wr_R5;
pkt2cmp.wr_R6=wr_R6;
pkt2cmp.wr_R7=wr_R7;


//Mem Access
pkt2cmp.MemAccess_M_Data=MemAccess_M_Data;
pkt2cmp.MemAccess_M_Addr=MemAccess_M_Addr;
pkt2cmp.MemAccess_DMem_dout=MemAccess_DMem_dout;
pkt2cmp.MemAccess_DMem_addr=MemAccess_DMem_addr;
pkt2cmp.MemAccess_DMem_din=MemAccess_DMem_din;
pkt2cmp.MemAccess_DMem_rd=MemAccess_DMem_rd;
pkt2cmp.MemAccess_M_Control=MemAccess_M_Control;
pkt2cmp.MemAccess_mem_state=MemAccess_mem_state;


endtask

task ReceiverBase:: get_payload();

//loading values from the LC3_io interface
reset = lc3io.cb.reset;
instrmem_rd = lc3io.cb.instrmem_rd;
complete_instr = lc3io.complete_instr;
complete_data = lc3io.complete_data;
Data_rd = lc3io.cb.Data_rd;

pc = lc3io.cb.pc;
Instr_dout = lc3io.cb.Instr_dout;
Data_addr = lc3io.cb.Data_addr;
Data_dout = lc3io.cb.Data_dout;
Data_din = lc3io.cb.Data_din;

//loading values from the Prober
// controller
control_IR=Prober.control_IR;
control_IR_Exec=Prober.control_IR_Exec;
control_IMem_dout=Prober.control_IMem_dout;
control_complete_data=Prober.control_complete_data;
control_complete_instr=Prober.control_complete_instr;
control_nzp=Prober.control_nzp;
control_psr=Prober.control_psr;
control_enable_fetch=Prober.control_enable_fetch;
control_enable_updatePC=Prober.control_enable_updatePC;
control_enable_decode=Prober.control_enable_decode;
control_enable_execute=Prober.control_enable_execute;
control_enable_writeback=Prober.control_enable_writeback;
control_br_taken=Prober.control_br_taken;
control_bypass_alu_1=Prober.control_bypass_alu_1;
control_bypass_alu_2=Prober.control_bypass_alu_2;
control_bypass_mem_1=Prober.control_bypass_mem_1;
control_bypass_mem_2=Prober.control_bypass_mem_2;
control_mem_state=Prober.control_mem_state;

//fetch
fetch_enable_updatePC=Prober.fetch_enable_updatePC;
fetch_enable_fetch=Prober.fetch_enable_fetch;
fetch_br_taken=Prober.fetch_br_taken;
fetch_taddr=Prober.fetch_taddr;
fetch_instrmem_rd=Prober.fetch_instrmem_rd;
fetch_pc=Prober.fetch_pc;
fetch_npc_out=Prober.fetch_npc_out;

//decode
// #1 ;
decode_npc_in=Prober.decode_npc_in;
decode_Instr_dout=Prober.decode_Instr_dout;
decode_npc_out=Prober.decode_npc_out;
decode_IR=Prober.decode_IR;
decode_enable_decode=Prober.decode_enable_decode;
// decode_psr=Prober.decode_psr;
decode_E_control=Prober.decode_E_control;
decode_W_control=Prober.decode_W_control; 
decode_Mem_control=Prober.decode_Mem_control; 
// Execute 
execute_pcout=Prober.execute_pcout;

//Execute final
ex_E_control=Prober.ex_E_control;
ex_IR=Prober.ex_IR;
ex_npc_in=Prober.ex_npc_in;
ex_VSR1=Prober.ex_VSR1;
ex_VSR2=Prober.ex_VSR2;
ex_bypass_alu_1=Prober.ex_bypass_alu_1;
ex_bypass_alu_2=Prober.ex_bypass_alu_2;
ex_bypass_mem_1=Prober.ex_bypass_mem_1;
ex_bypass_mem_2=Prober.ex_bypass_mem_2;
ex_Mem_control_in=Prober.ex_Mem_control_in;
ex_Mem_control_out=Prober.ex_Mem_control_out;
ex_enable_execute=Prober.ex_enable_execute;
ex_W_Control_in=Prober.ex_W_Control_in;
ex_W_Control_out=Prober.ex_W_Control_out;
ex_Mem_bypass_value=Prober.ex_Mem_bypass_value;
ex_M_data=Prober.ex_M_data;
ex_IR_exec=Prober.ex_IR_exec;
ex_aluout=Prober.ex_aluout;
ex_pcout=Prober.ex_pcout;
ex_dr=Prober.ex_dr;
ex_sr1=Prober.ex_sr1;
ex_sr2=Prober.ex_sr2;
ex_NZP=Prober.ex_NZP;

//writeback
writeback_enable_writeback=Prober.writeback_enable_writeback;
writeback_W_control=Prober.writeback_W_control;
writeback_aluout=Prober.writeback_aluout;
writeback_memout=Prober.writeback_memout;
writeback_pcout=Prober.writeback_pcout;
writeback_sr1=Prober.writeback_sr1;
writeback_sr2=Prober.writeback_sr2;
writeback_dr=Prober.writeback_dr;
writeback_psr=Prober.writeback_psr;
writeback_VSR1=Prober.writeback_VSR1;
writeback_VSR2=Prober.writeback_VSR2;
wr_R0=Prober.wr_R0;
wr_R1=Prober.wr_R1;
wr_R2=Prober.wr_R2;
wr_R3=Prober.wr_R3;
wr_R4=Prober.wr_R4;
wr_R5=Prober.wr_R5;
wr_R6=Prober.wr_R6;
wr_R7=Prober.wr_R7;
//Mem Access
MemAccess_M_Data=Prober.MemAccess_M_Data;
MemAccess_M_Addr=Prober.MemAccess_M_Addr;
MemAccess_DMem_dout=Prober.MemAccess_DMem_dout;
MemAccess_DMem_addr=Prober.MemAccess_DMem_addr;
MemAccess_DMem_din=Prober.MemAccess_DMem_din;
MemAccess_DMem_rd=Prober.MemAccess_DMem_rd;
MemAccess_M_Control=Prober.MemAccess_M_Control;
MemAccess_mem_state=Prober.MemAccess_mem_state;

@ (lc3io.cb);
$display ($time, "[RECEIVER]  Getting Payload");
//check if there are some signals that need to be moved here as they have not settled?

endtask
