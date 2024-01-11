class ReceiverBase;
virtual LC3_io.TB lc3io;	// interface signals
virtual DUT_probe_if Prober; // Probe signals
OutputPacket   pkt2cmp;

// define all the signals that are o/p of lc3
logic reset, instrmem_rd, complete_instr, complete_data, Data_rd; 
logic [15:0] pc, Instr_dout, Data_addr,  Data_dout, Data_din;
// define all the internal signals that come from the probe
logic  fetch_enable_updatePC,fetch_enable_fetch,fetch_br_taken; 
logic [15:0] 		fetch_taddr;
logic 				fetch_instrmem_rd;
logic [15:0]		fetch_pc,fetch_npc_out;
extern function new(virtual LC3_io.TB lc3io, virtual DUT_probe_if Prober);
extern virtual task recv();
extern virtual task get_payload();

endclass

function ReceiverBase::new(virtual LC3_io.TB lc3io, virtual DUT_probe_if Prober);
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
//fetch
pkt2cmp.fetch_enable_updatePC=fetch_enable_updatePC;
pkt2cmp.fetch_enable_fetch=fetch_enable_fetch;
pkt2cmp.fetch_br_taken=fetch_br_taken;
pkt2cmp.fetch_taddr=fetch_taddr;
pkt2cmp.fetch_instrmem_rd=fetch_instrmem_rd;
pkt2cmp.fetch_pc=fetch_pc;
pkt2cmp.fetch_npc_out=fetch_npc_out;


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
fetch_enable_updatePC=Prober.fetch_enable_updatePC;
fetch_enable_fetch=Prober.fetch_enable_fetch;
fetch_br_taken=Prober.fetch_br_taken;
fetch_taddr=Prober.fetch_taddr;
fetch_instrmem_rd=Prober.fetch_instrmem_rd;
fetch_pc=Prober.fetch_pc;
fetch_npc_out=Prober.fetch_npc_out;

@ (lc3io.cb);
$display ($time, "[RECEIVER]  Getting Payload");
//check if there are some signals that need to be moved here as they have not settled?

endtask
