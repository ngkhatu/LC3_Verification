`include "ReceiverBase.sv"
class Receiver extends ReceiverBase;
//  mailbox out_box;	// Scoreboard mailbox
  	typedef mailbox #(OutputPacket) rx_box_type;
  	rx_box_type 	rx_out_box;		// mailbox for Packet objects To Scoreboard

   	extern function new(rx_box_type rx_out_box, virtual LC3_io.TB lc3io, virtual dut_Probe_if Prober);
   	extern virtual task start();
endclass

function Receiver::new( rx_box_type rx_out_box, virtual LC3_io.TB lc3io, virtual dut_Probe_if Prober);
  super.new(lc3io, Prober);  
  this.rx_out_box = rx_out_box;
endfunction

task Receiver::start();
	int i;
	i = 0;  
	$display($time, "[RECEIVER]  RECEIVER STARTED");
	@ (lc3io.cb); // to cater to the one cycle delay in the pipeline
	fork
		forever
		begin
			recv(); // calling the super function 
			rx_out_box.put(pkt2cmp);
			$display($time, "[RECEIVER]  Payload Obtained");
			i++;
			//if (i == numpackets)
			//begin
			//	break;
			//end
		end	
	join_none
	$display ($time, "[RECEIVER] Forking of Process Finished");
endtask