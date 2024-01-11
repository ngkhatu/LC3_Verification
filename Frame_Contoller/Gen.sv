
class Generator;
Instruction Ival;
typedef mailbox#(Instruction) in_box_type;
in_box_type in_box;
int number_of_packets;
bit [2:0] count;
bit [4:0] lbflag;
function new(int number_of_packets);
this.in_box=new;
this.Ival=new();
this.number_of_packets=number_of_packets;
this.count=3'b0;
this.lbflag=5'd0;
endfunction


		
task gen_lb(bit [4:0] lbflag);
// Ival.randomize();
// Ival.constraint_mode(0);
if(lbflag==5'b10100)
	begin
		Ival.Alu.constraint_mode(0);
		Ival.BR.constraint_mode(0);
		Ival.LS.constraint_mode(1);
	end
else if(lbflag==5'b01010)
	begin
		Ival.Alu.constraint_mode(0);
		Ival.BR.constraint_mode(1);
		Ival.LS.constraint_mode(0);
	end
else 
	begin
		Ival.Alu.constraint_mode(1);
		Ival.BR.constraint_mode(0);
		Ival.LS.constraint_mode(0);
	end

if (!Ival.randomize()) 
	begin
		$display(" \n%m\n[ERROR]%0d gen(): Randomization Failed!", $time);
		$finish;	
	end

$display("Opcode in the Ival for LB = %d",Ival.op);
if(Ival.op==2 || Ival.op==10|| Ival.op==14| Ival.op==3 || Ival.op==11|| Ival.op==0 )
	begin
	Ival.Instr_dout={Ival.op,Ival.dr,Ival.pcof};
	end
if(Ival.op==6 || Ival.op==7 || Ival.op==12)
	begin
	Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	end	
if(Ival.op==1 || Ival.op==5 || Ival.op==9 )//for ALU
	begin
	Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	end
$display(" INSTR DOUT",Ival.Instr_dout);
$display ($time, " [GENERATOR] Instruction Generation done .. Now to put it in Driver mailbox");	
endtask

task gen_init(bit [2:0] count); 
// Ival.randomize();
	if(count==3'b000)
	begin	
		Ival.op=4'b0101;
		Ival.dr=count;
		Ival.sr1=count;
		Ival.bit5=1'b1;
		Ival.im_sr2=5'b00000;	
		Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	end
	else
		begin
		Ival.op=4'b0101;
		Ival.dr=count-1'b1;
		Ival.sr1=count-1'b1;
		Ival.bit5=1'b1;
		Ival.im_sr2=5'b00000;	
		Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
		end
	

$display ($time, " [GENERATOR] Register Initialization done .. Now to put it in Driver mailbox");	
endtask
task gen_fetch_dir(integer i);
// ADD R0, R0, 10
// ADD R1, R1, 10
// ADD R2, R1, R0
// ADD R4, R2, R1
// ADD R5, R0, R0
// BRA if positive to label_1

if(i==14)
	begin
		Ival.op=4'b0000;
		Ival.dr=3'b001;
		Ival.pcof=9'b000000011;
		Ival.Instr_dout={Ival.op,Ival.dr,Ival.pcof};
	end
else if (i==9)
	begin
		Ival.op=`ADD;
		Ival.dr=3'b000;
		Ival.sr1=3'b000;
		Ival.bit5=1'b1;
		Ival.im_sr2=5'b00010;	
		Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	end
else if (i==10)
	begin
		Ival.op=`ADD;
		Ival.dr=3'b001;
		Ival.sr1=3'b001;
		Ival.bit5=1'b1;
		Ival.im_sr2=5'b00010;	
		Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end
else if (i==11)
	begin
		Ival.op=`ADD;
		Ival.dr=3'b010;
		Ival.sr1=3'b010;
		Ival.bit5=1'b0;
		Ival.im_sr2=5'b00001;	
		Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end
else if (i==12)
	begin
		Ival.op=`ADD;
		Ival.dr=3'b100;
		Ival.sr1=3'b001;
		Ival.bit5=1'b0;
		Ival.im_sr2=5'b00000;	
		Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end
else if (i==13)
	begin
		Ival.op=`ADD;
		Ival.dr=3'b101;
		Ival.sr1=3'b000;
		Ival.bit5=1'b0;
		Ival.im_sr2=5'b00000;	
		Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end
// ADD R0, R0, 10 
// ADD R1, R1, 10 
// ADD R2, R1, R0 
// ADD R4, R2, R1 
// ADD R5, R0, R0
else if (i==15)
	begin
		// Ival.op=4'b0000;
		// Ival.dr=3'b001;
		// Ival.pcof=9'b000000011;
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.pcof};
		// Ival.op=`ADD;
		// Ival.dr=3'b000;
		// Ival.sr1=3'b000;
		// Ival.bit5=1'b1;
		// Ival.im_sr2=5'b01010;	
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end
else if (i==16)
	begin
		// Ival.op=4'b0000;
		// Ival.dr=3'b001;
		// Ival.pcof=9'b000000011;
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.pcof};
		// Ival.op=`ADD;
		// Ival.dr=3'b001;
		// Ival.sr1=3'b001;
		// Ival.bit5=1'b1;
		// Ival.im_sr2=5'b01010;	
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end
else if (i==17)
	begin
		// Ival.op=4'b0000;
		// Ival.dr=3'b001;
		// Ival.pcof=9'b000000011;
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.pcof};
		// Ival.op=`ADD;
		// Ival.dr=3'b001;
		// Ival.sr1=3'b001;
		// Ival.bit5=1'b1;
		// Ival.im_sr2=5'b01010;	
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end
else if (i==16)
	begin
		// Ival.op=4'b0000;
		// Ival.dr=3'b001;
		// Ival.pcof=9'b000000011;
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.pcof};
		// Ival.op=`ADD;
		// Ival.dr=3'b001;
		// Ival.sr1=3'b001;
		// Ival.bit5=1'b1;
		// Ival.im_sr2=5'b01010;	
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end
else if (i==18)
	begin
		// Ival.op=4'b0000;
		// Ival.dr=3'b001;
		// Ival.pcof=9'b000000011;
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.pcof};
		// Ival.op=`ADD;
		// Ival.dr=3'b001;
		// Ival.sr1=3'b001;
		// Ival.bit5=1'b1;
		// Ival.im_sr2=5'b01010;	
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end
else if (i==19)
	begin
		// Ival.op=4'b0000;
		// Ival.dr=3'b001;
		// Ival.pcof=9'b000000011;
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.pcof};
		// Ival.op=`ADD;
		// Ival.dr=3'b001;
		// Ival.sr1=3'b001;
		// Ival.bit5=1'b1;
		// Ival.im_sr2=5'b01010;	
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end
else if (i==20)
	begin
		// Ival.op=4'b0000;
		// Ival.dr=3'b001;
		// Ival.pcof=9'b000000011;
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.pcof};
		// Ival.op=`ADD;
		// Ival.dr=3'b001;
		// Ival.sr1=3'b001;
		// Ival.bit5=1'b1;
		// Ival.im_sr2=5'b01010;	
		// Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end
else if (i==21)
	begin
		Ival.op=`ADD;
		Ival.dr=3'b010;
		Ival.sr1=3'b001;
		Ival.bit5=1'b0;
		Ival.im_sr2=5'b00000;	
		Ival.Instr_dout={Ival.op,Ival.dr,Ival.sr1,Ival.bit5,Ival.im_sr2};
	
	end

endtask

task start();
	$display ($time, "ns:  [GENERATOR] Generator Started");

	fork
		  for (int i=0; i<number_of_packets || number_of_packets <= 0; i++) 
		  begin
				
				if(lbflag==5'b10101)
					begin
						lbflag=5'b00000;
					end
				if(i<=8)//initialization
					begin
					gen_init(count);
					count=count+1'b1;
					end
				else if(i>8 && i<22)
					begin
					//directed for fetch
					gen_fetch_dir(i);
					end
				else 
				begin
				gen_lb(lbflag);	
				lbflag=lbflag+1'b1;
				end			
				begin 	
				  Instruction iv = new Ival;
			      in_box.put(iv); // FUNNY .. 
				  //$display("Packets value is ",iv.Instr_dout);
			  end	
			end
		  $display($time, "ns:  [GENERATOR] Generation Finished Creating %d Packets  ", number_of_packets);
      join_none
endtask

 
endclass
