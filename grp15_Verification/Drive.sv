`include "DriveBase.sv"
class Drive extends DriveBase;
typedef mailbox #(Instruction) in_box_type; //gen to driver
in_box_type in_box = new;
// outbox mailbox for scoreboard
typedef mailbox #(Instruction) out_box_type;
out_box_type out_box = new;
  
int packets_sent;

function new(virtual LC3_io.TB lc3io,in_box_type in_box,out_box_type out_box);
super.new(lc3io);
this.in_box=in_box;
this.out_box=out_box;
endfunction

task start();
packets_sent=0;
$display ($time, "ns:  [DRIVER] Driver Started");
fork
	    forever
	    begin
			in_box.get(Ival);
			packets_sent++;
			$display ($time, "[DRIVER] Sending in new packet BEGIN");			
			this.drive_op = Ival.op;
			this.drive_dr= Ival.dr;
			this.drive_sr1= Ival.sr1;
			this.drive_bit5= Ival.bit5;
			this.drive_im_sr2= Ival.im_sr2;
			this.drive_pcof= Ival.pcof;
			this.drive_Data_dout=Ival.Data_dout; // 16 bits		
			this.drive_reset=Ival.reset;// 1 bit
			this.drive_complete_data=Ival.complete_data; // 1 bit
			this.drive_complete_instr=Ival.complete_instr; // 1 bit
			send();
			$display ($time, "ns:  [DRIVER] Sending in new packet END");
			$display ($time, "ns:  [DRIVER] Number of packets sent = %d", packets_sent);
			out_box.put(Ival);	
			$display ($time, "ns:  [DRIVER] Number of packets in generator mailbox = %d",in_box.num());			
			if(in_box.num() == 0)
			begin
				break;
			end
		  	@(lc3io.cb);
		end
join_none	
	$display ($time,  "[DRIVER] DRIVER Forking of process is finished");	


endtask 
endclass