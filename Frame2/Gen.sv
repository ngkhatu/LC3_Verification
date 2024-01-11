
class Generator;
Instruction Ival;
typedef mailbox#(Instruction) in_box_type;
in_box_type in_box;
int number_of_packets;

function new(int number_of_packets);
this.in_box=new;
this.Ival=new();
this.number_of_packets=number_of_packets;
endfunction


		
task gen_instr();
// Ival.randomize();
if (!Ival.randomize()) 
	begin
		$display(" \n%m\n[ERROR]%0d gen(): Randomization Failed!", $time);
		$finish;	
	end
endtask

task start();
	fork
		  for (int i=0; i<number_of_packets || number_of_packets <= 0; i++) 
		  begin
			  gen_instr();
			  begin 	
				  Instruction iv = new Ival;
			      in_box.put(iv); // FUNNY .. 
				  $display("Packets value is ",iv.Instr_dout);
			  end
		  end
		  $display($time, "ns:  [GENERATOR] Generation Finished Creating %d Packets  ", number_of_packets);
      join_none
// $display($time,"In generate start");
// gen_instr();
// $display($time,"Opcode",Ival.Instr_dout.op);
//// Instruction ins = new Ival;
// mail_instr1.put(Ival);
// $display($time, "Sent ot mailbox");

endtask

 
endclass

// task gen_add();
		// Ival.Instr_dout.op=4'b0001;
		// Ival.Instr_dout.dr=$urandom_range(7,0);
		// Ival.Instr_dout.sr1=$urandom_range(7,0);
		// Ival.Instr_dout.bit5=$urandom_range(1,0);
		// if(Ival.Instr_dout.bit5==1'b0)
			// begin
			// Ival.Instr_dout.im_sr2={2'b00,$urandom_range(7,0)};		
			// end
		// else
			// begin
			// Ival.Instr_dout.im_sr2=$urandom_range(31,0);
			// end
// endtask