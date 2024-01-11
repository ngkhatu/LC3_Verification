
class Scoreboard;

Instruction pkt_sent= new(); // instruction from driver
// virtual LC3_io.TB lc3io; //remove
// Packet pkt_sent = new();	// Packet object from Driver
OutputPacket   pkt2cmp = new();		// Packet object from Receiver
typedef mailbox #(Instruction) out_box_type;
       out_box_type driver_mbox;		// mailbox for Instruction objects from Drivers

typedef mailbox #(OutputPacket) rx_box_type;
       rx_box_type 	receiver_mbox;		// mailbox for Packet objects from Receiver
	   
	   // Declare variables to buffer and compare		
	   //buffer for fetch
		reg [15:0] buf_pc=16'h3001;
		reg buf_enable_updatePC=1'b1;
		//buffer for Decode
		reg 	buf_enable_decode=1'b1;
		reg [15:0] buf_npc_out=0;
		reg[5:0] buf_E_control=0;
		reg[1:0] buf_W_control=0;
		reg buf_Mem_control=0;
		//buffer for WB
		reg [2:0] buf_wb_psr=0;
		//buffer for Controller
		reg [1:0] buf_control_mem_state=2'b11;
		reg [3:0] buf_control_opcode;
		integer react=0;
		integer	stage=0;
		integer updateFlag=0;
		//buffer for Execute 
		reg [15:0] buf_ex_aluout=0;
		reg [15:0] buf_ex_IR_exec=0;
		reg [1:0] buf_ex_W_Control_out=0;
		reg buf_ex_Mem_control_out=0;
		reg [15:0] buf_ex_M_data=0;
		reg [2:0] buf_ex_NZP=0;
		reg [2:0] buf_ex_dr=0;
	   	// Declare the signals to be used in SB stages over here
		//declaration for stage fetch
		reg [15:0] pc=16'h3000,npc=16'h3002,taddr=0;
		reg enable_updatePC=1'b1,br_taken=0,instrmem_rd=1,enable_fetch=1'b1;
		//declaration for stage decode
		reg [15:0] npc_in=0,Instr_dout=0,npc_out=0,IR=0;
		reg enable_decode=1'b1;
		reg[2:0] psr=0;
		reg[5:0] E_control=0;
		reg[1:0] W_control=0, pcselect1=0, alu_control=0;
		reg Mem_control=0, pcselect2=0, op2select=0;
		
		//declaration for stage Execute .......
		reg	[5:0] ex_E_control=0;
		reg[15:0] ex_IR=0, ex_npc_in=0,ex_VSR1=0,ex_VSR2=0,ex_alu_in1=0,ex_alu_in2=0;
		reg ex_bypass_alu_1=0,ex_bypass_alu_2=0,ex_bypass_mem_1=0,ex_bypass_mem_2=0,ex_Mem_control_in=0,ex_Mem_control_out=0,
		ex_enable_execute=1'b1,ex_pcselect2=0,ex_op2select=0;
		reg[1:0] ex_W_Control_in=0,ex_W_Control_out=0,ex_alu_control=0,ex_pcselect1=0;
		reg[15:0] ex_Mem_bypass_value=0, ex_M_data=0,ex_IR_exec=0,ex_aluout=0,ex_pcout=0;
		reg[2:0] ex_dr=0, ex_sr1=0, ex_sr2=0, ex_NZP=0;
		reg[15:0] ex_imm5=0,ex_offset6=0, ex_offset9=0 ,ex_offset11=0;
		
		//declaration for stage Controller
		reg 	[15:0]	control_IR;
		reg 	[15:0]	control_IR_Exec;
		reg 	[15:0]	control_IMem_dout;
		reg 	control_complete_data;
		reg 	control_complete_instr;
		reg 	[2:0]	control_nzp;
		reg 	[2:0] 	control_psr;
		reg 	control_br_taken=1'b0;
		reg 	[1:0] control_mem_state=2'b11;
		reg 	[2:0] reset_counter=3'd1;
		reg 	[3:0] br_counter=4'd0;
		reg 	[1:0] ld_counter=2'd0,st_counter=2'd0,ldi_counter=2'd0,sti_counter=2'd0;
		reg 	control_enable_updatePC=1'b1,  control_enable_decode=1'b0, control_enable_execute=1'b0, control_enable_writeback=1'b0, control_enable_fetch=1'b1;
		reg 	control_bypass_alu_1=1'b0;
		reg 	control_bypass_alu_2=1'b0;
		reg 	control_bypass_mem_1=1'b0;
		reg 	control_bypass_mem_2=1'b0;
		//declaration for writeback
		reg			enable_writeback;	
		reg	[15:0]	VSR1, VSR2, aluout, pcout,npc_writeback,DR_in=0;
		reg	[2:0] 	wb_psr=0,sr1,sr2,dr;
		reg [1:0]   W_control_in;
		reg [15:0] wb_regfile [7:0];
		
		//declaration of memory access
		// Inputs: 
		reg [15:0] memout,M_Data,M_Addr,DMem_dout,DMem_Addr,DMem_din;
		reg        DMem_rd,M_Control;
		reg [1:0] mem_state;
		
		// end of variables 
		extern function new( out_box_type driver_mbox = null, rx_box_type receiver_mbox = null);
		extern virtual task start();
		extern virtual task fetch();
		extern virtual task decode();
		
		extern virtual task execute();
		extern virtual task controller();
		extern virtual task writeback();
		extern virtual task memaccess();		
		extern virtual task checkvals_fetch();// common function to check values for all the blocks 
		extern virtual task checkvals_decode();
		extern virtual task checkvals_execute();
		extern virtual task checkvals_writeback();
		extern virtual task checkvals_memaccess();
		extern virtual task checkvals_controller();
endclass

function Scoreboard::new( out_box_type driver_mbox = null, rx_box_type receiver_mbox = null);
$display ($time, "[SCOREBOARD] Scoreboard NEW");
if(driver_mbox == null)
	driver_mbox=new();
if(receiver_mbox == null)
	receiver_mbox=new();
this.driver_mbox=driver_mbox;
this.receiver_mbox=receiver_mbox;
// this.lc3io=lc3io; //remove
endfunction

task Scoreboard::start();
       $display ($time, "[SCOREBOARD] Scoreboard Started");

       $display ($time, "[SCOREBOARD] Receiver Mailbox contents = %d", receiver_mbox.num());
	   fork
	       forever 
	       begin
				//$display(receiver_mbox.try_get(pkt2cmp));
		       if(receiver_mbox.try_get(pkt2cmp)) 
			   begin
				$display ("[SCOREBOARD]Packet Found");
			       $display ($time, "[SCOREBOARD] Grabbing Data From both Driver and Receiver");
			       driver_mbox.get(pkt_sent);
			       //write the fsm controller which calls different states as required
				   // fetch();
				   // checkvals_fetch();
				   // decode();
				   // checkvals_decode();
				   // execute();
				   // checkvals_execute();
				   // writeback();
				   // checkvals_writeback();
				   // memaccess();
				   // checkvals_memaccess();
				   controller();
				   checkvals_controller();
				   
		       end
		       else 
		       begin
			   //$display ("[SCOREBOARD]Packet not found");
			       #1;
		       end
	       end
       join_none
       $display ($time, "[SCOREBOARD] Forking of Process Finished");
	   
endtask
//instruction  => pkt_sent
// output packet => pkt2cmp
//************************************************FETCH*****************************************
task Scoreboard:: fetch();
logic[15:0] pc_a;

if(pkt_sent.reset==1'b1) //RESET HIGH behaviour
	begin
	pc=16'h3000;
	npc=16'h3001;	
	instrmem_rd=1'b1;
	// enable_updatePC=1'b1;
	// enable_fetch=1'b1;
	// br_taken=1'b0;
	end
else //RESET LOW behaviour
begin
// enable_updatePC=pkt2cmp.control_enable_updatePC;
// enable_fetch=pkt2cmp.control_enable_fetch;
// br_taken=pkt2cmp.control_br_taken;
// taddr=pkt2cmp.execute_pcout;

enable_updatePC=pkt2cmp.fetch_enable_updatePC;
enable_fetch=pkt2cmp.fetch_enable_fetch;
br_taken=pkt2cmp.fetch_br_taken;
taddr=pkt2cmp.fetch_taddr;

	
	npc=buf_pc+1'b1;
	pc_a=br_taken ? taddr : npc;
	pc=enable_updatePC? pc_a : buf_pc;
	instrmem_rd=enable_fetch?1:1'h0;
end
endtask

//***************************************DECODE*******************************************

task Scoreboard :: decode();

	if(pkt2cmp.reset==1'b1)//reset behaviour
		begin
		Mem_control=0;
		W_control=0;
		E_control=0;
		IR=0;
		npc_out=0;
		end
	else
	begin
	Mem_control=0;
	W_control=0;
	alu_control=0;
	pcselect1=0;
	pcselect2=0;
	op2select=0;
	npc_in=pkt2cmp.decode_npc_in;
	Instr_dout=pkt_sent.Instr_dout;
	enable_decode=pkt2cmp.decode_enable_decode;
	psr=pkt2cmp.decode_psr;
	if(enable_decode==1'b1)
		npc_out=npc_in;
	if(enable_decode==1'b1 && buf_enable_decode==1'b1)
		begin
		IR=Instr_dout;		
		end
	else if(buf_enable_decode==1'b1 && enable_decode==1'b0)
		begin
		IR=Instr_dout;
		end
	else if(buf_enable_decode==1'b0 && enable_decode==1'b1)
		begin
		IR=IR;
		end
	// else
		// begin
		// IR=IR;
		// npc_out=npc_out;
		// end
	//Set W_control as per Instr_dout[15:12]
	if(IR[15:12]==`ADD ||IR[15:12]==`AND ||IR[15:12]==`NOT ||
	IR[15:12]==`ST ||IR[15:12]==`STR ||IR[15:12]==`STI || 
	IR[15:12]==`BR || IR[15:12]==`JMP)
		begin
		W_control=2'b00;
		end
	else if(IR[15:12]==`LD || IR[15:12]==`LDR || IR[15:12]==`LDI)
		begin
		W_control=2'b01;
		end
	else if (IR[15:12]==`LEA)
		begin
		W_control=2'b10;
		end
	//set Mem_control as per IR[15:12] 
	if(IR[15:12]==`LDI || IR[15:12]==`STI)
		begin
		Mem_control=1'b1;
		end
	else if(IR[15:12]==`LD || IR[15:12]==`LDR || IR[15:12]==`ST || IR[15:12]==`STR)
		begin
		Mem_control=1'b0;
		end
	//set E_control as per Instr_dout[15:12] and Instr_dout[5]
	//set alu_control and op2select
	if(IR[15:12]==`ADD && IR[5]==0) // ADD and 0
		begin
		alu_control=0;
		op2select=1;//Instr_dout[1];//1;//doubt VSR2
		end
	else if(IR[15:12]==`ADD && IR[5]==1) // ADD and 1
		begin
		alu_control=0;
		op2select=0;//Instr_dout[0];//0;//doubt imm5
		end
	else if(IR[15:12]==`AND && IR[5]==0) // AND and 0
		begin
		alu_control=1;
		op2select=1;//Instr_dout[1];//1;//doubt VSR2
		end
	else if(IR[15:12]==`AND && IR[5]==1) // AND and 1
		begin
		alu_control=1;
		op2select=0;//Instr_dout[0];//0;//doubt imm5
		end
	else if(IR[15:12]==`NOT) // NOT 
		begin
		alu_control=2'b10;
		end
	//set pcselect1 and pcselect2
	if(IR[15:12]==`BR) // BR
		begin
		pcselect1=2'b01;//Instr_dout[1];//2'b01;//doubt offset9
		pcselect2=1'b1;//Instr_dout[10];//1'b1;//doubt npc
		end
	else if(IR[15:12]==`JMP) // JMP
		begin
		pcselect1=2'b11;//2'b11;//doubt 0
		pcselect2=1'b0;//Instr_dout[6];//1'b0;//doubt VSR1
		end
	else if(IR[15:12]==`LD) // LD
		begin
		pcselect1=2'b01;//Instr_dout[1];//2'b01;//doubt offset9
		pcselect2=1'b1;//npc_in[1];//1'b1;//doubt npc
		end
	else if(IR[15:12]==`LDR) // LDR
		begin
		pcselect1=2'b10;//Instr_dout[2];//2'b11;//doubt offset6
		pcselect2=1'b0;//Instr_dout[6];//1'b0;//doubt VSR1
		end
	else if(IR[15:12]==`LDI) // LDI
		begin
		pcselect1=2'b01;//Instr_dout[1];//2'b11;//doubt offset9
		pcselect2=1'b1;//npc_in[1];//1'b0;//doubt npc
		end
	else if(IR[15:12]==`LEA) // LEA
		begin
		pcselect1=2'b01;//Instr_dout[1];//2'b11;//doubt offset9
		pcselect2=1'b1;//npc_in[1];//1'b0;// doubt npc
		end
	else if(IR[15:12]==`ST) // ST
		begin
		pcselect1=2'b01;//Instr_dout[1];//2'b11;//doubt offset9
		pcselect2=1'b1;//npc_in[1];//1'b0;//doubt npc
		end
	else if(IR[15:12]==`STR) // STR
		begin
		pcselect1=2'b10;//Instr_dout[2];//2'b11;//doubt offset6
		pcselect2=1'b0;//Instr_dout[6];//1'b0;//doubt VSR1
		end
	else if(IR[15:12]==`STI	) // STI
		begin
		pcselect1=2'b01;//Instr_dout[1];//2'b11;//doubt offset9
		pcselect2=1'b1;//npc_in[1];//1'b0;//doubt npc
		end
	E_control={alu_control,pcselect1,pcselect2,op2select};
	end//else
buf_enable_decode=enable_decode;
endtask:decode

//***************************************EXECUTE******************************************
task Scoreboard :: execute();
if(pkt2cmp.reset==1'b1)
begin
ex_aluout=0;//doubt
ex_pcout=0;//doubt
ex_dr=0;//doubt
ex_NZP=0;//doubt
ex_M_data=0; //doubt
ex_W_Control_out=0;
ex_Mem_control_out=0;
end
else 
begin
//inputs
ex_E_control=pkt2cmp.ex_E_control;
ex_IR=pkt2cmp.ex_IR;
ex_npc_in=pkt2cmp.ex_npc_in;
ex_VSR1=pkt2cmp.ex_VSR1;
ex_VSR2=pkt2cmp.ex_VSR2;
ex_bypass_alu_1=pkt2cmp.ex_bypass_alu_1;
ex_bypass_alu_2=pkt2cmp.ex_bypass_alu_2;
ex_bypass_mem_1=pkt2cmp.ex_bypass_mem_1;
ex_bypass_mem_2=pkt2cmp.ex_bypass_mem_2;
ex_Mem_control_in=pkt2cmp.ex_Mem_control_in;
ex_W_Control_in=pkt2cmp.ex_W_Control_in;
ex_Mem_bypass_value=pkt2cmp.ex_Mem_bypass_value;
ex_enable_execute=pkt2cmp.ex_enable_execute;
// sr1
ex_sr1 = ex_IR[8:6];
//sr2
if(ex_IR[15:12]==`BR || ex_IR[15:12]==`JMP || ex_IR[15:12]==`LEA || ex_IR[15:12]==`LD || ex_IR[15:12]==`LDR || ex_IR[15:12]==`LDI) 
ex_sr2 = 0;
else if(ex_IR[15:12]==`ST || ex_IR[15:12]==`STR || ex_IR[15:12]==`STI)
ex_sr2 = ex_IR[11:9];
else if(ex_IR[15:12]==`ADD || ex_IR[15:12]==`AND || ex_IR[15:12]==`NOT) 
ex_sr2 = ex_IR[2:0];
else $display("Execute Instruction Invalid!");
//enable starts
if(ex_enable_execute==1'b1)
begin
ex_imm5 = {{11{ex_IR[4]}}, ex_IR[4:0]};
ex_offset6 = {{10{ex_IR[5]}}, ex_IR[5:0]};
ex_offset9 = {{7{ex_IR[8]}}, ex_IR[8:0]};
ex_offset11 = {{5{ex_IR[10]}},ex_IR[10:0]};
// W_Control_out
ex_W_Control_out = ex_W_Control_in;
// Mem_Control_out
ex_Mem_control_out = ex_Mem_control_in;
// IR_Exec
ex_IR_exec[15:0] = ex_IR[15:0];
// 
//calculate aluin1
if(ex_bypass_alu_1) ex_alu_in1 = ex_aluout;
else if(ex_bypass_mem_1) ex_alu_in1 = ex_Mem_bypass_value;
else ex_alu_in1 = ex_VSR1;
//calculate aluin2
if(ex_bypass_alu_2) ex_alu_in2 = ex_aluout;
else if(ex_bypass_mem_2) ex_alu_in2 = ex_Mem_bypass_value;
else if(ex_IR[5]==1'b0) ex_alu_in2 = ex_VSR2;
else if(ex_IR[5]==1'b1) ex_alu_in2 = ex_imm5;
//calculate pcout
ex_alu_control=ex_E_control[5:4];
ex_pcselect1=ex_E_control[3:2];
ex_pcselect2=ex_E_control[1];
ex_op2select=ex_E_control[0];
if(ex_pcselect1==0 && ex_pcselect2==0) ex_pcout = ex_alu_in1 + ex_offset11;
else if(ex_pcselect1==1 && ex_pcselect2==0) ex_pcout = ex_alu_in1 + ex_offset9;
else if(ex_pcselect1==2 && ex_pcselect2==0) ex_pcout = ex_alu_in1 + ex_offset6;
else if(ex_pcselect1==3 && ex_pcselect2==0) ex_pcout = ex_alu_in1 + 0;
else if(ex_pcselect1==0 && ex_pcselect2==1) ex_pcout = ex_npc_in + ex_offset11;
else if(ex_pcselect1==1 && ex_pcselect2==1) ex_pcout = ex_npc_in + ex_offset9;
else if(ex_pcselect1==2 && ex_pcselect2==1) ex_pcout = ex_npc_in + ex_offset6;
else if(ex_pcselect1==3 && ex_pcselect2==1) ex_pcout = ex_npc_in + 0;
else  
begin
ex_pcout = 0;
$display("Error! Incorrect pc_select1 or pc_select2 value detected");
end
//for load and store donot do -1 from pcout but for rest of the time do -1???
if((ex_IR[15:12]==`BR)||(ex_IR[15:12]==`STI)||(ex_IR[15:12]==`LEA)||(ex_IR[15:12]==`LD)||(ex_IR[15:12]==`LDI)||(ex_IR[15:12]==`ST))
                ex_pcout=ex_pcout-1;
              else
                ex_pcout=ex_pcout;
//calculate alu out
if(ex_alu_control == 0) ex_aluout = ex_alu_in1 + ex_alu_in2; //aluout ADD
else if(ex_alu_control == 1) ex_aluout = ex_alu_in1 & ex_alu_in2; //aluout AND
else if(ex_alu_control == 2) ex_aluout = ~ex_alu_in1; // aluout NOT
//else ex_aluout = ex_pcout;//change
//calculate DR	
if(ex_IR[15:12]==`LD || ex_IR[15:12]==`LDR || ex_IR[15:12]==`LDI || ex_IR[15:12]==`LEA || ex_IR[15:12]==`ADD || ex_IR[15:12]==`AND || ex_IR[15:12]==`NOT) ex_dr = ex_IR[11:9];
else ex_dr = 0;
// calculate NZP
if(ex_IR[15:12]==`BR) ex_NZP = ex_IR[11:9];
else if(ex_IR[15:12]==`JMP) ex_NZP = 3'b111;
else ex_NZP = 3'b000;
//calculate M_data
if (ex_bypass_alu_2) ex_M_data = ex_alu_in2;
else ex_M_data = ex_VSR2;
end
else if(ex_enable_execute==1'b0)
begin
ex_NZP = 3'b000;
end
if((ex_IR[15:12]==`ADD)||(ex_IR[15:12]==`AND)||(ex_IR[15:12]==`NOT))
begin
ex_pcout=ex_aluout;
end
else
begin
ex_aluout=ex_pcout;
end
end
    

endtask

//+++++++++++++++++++++++++++++++++++++++++++++CONTROLLER+++++++++++++++++++++++++++++++++
task Scoreboard :: controller();
// input variables init
if(pkt2cmp.reset==1'b1)//reset behaviour
	begin
	// Reset behaviour
	control_enable_updatePC=1'b1;
	control_enable_fetch=1'b1;
	control_enable_decode=1'b0;
	control_enable_execute=1'b0;
	control_enable_writeback=1'b0;	
	control_mem_state=2'b11; // As init state should be 3
	reset_counter=3'd1;
	control_br_taken=1'b0;
	end
	
else
	begin
	if(reset_counter==3'd1)
		begin
			control_enable_decode=1'b1;
			reset_counter=3'd2;
		end
	else if(reset_counter==3'd2)
		begin
			control_enable_execute=1'b1;
			reset_counter=3'd3;
		end
	else if(reset_counter==3'd3)
		begin
			control_enable_writeback=1'b1;
			reset_counter=3'd0;
		end
		control_bypass_alu_1=1'b0;
		control_bypass_alu_2=1'b0;
		control_bypass_mem_1=1'b0;
		control_bypass_mem_2=1'b0;
		control_IR=pkt2cmp.control_IR;
		control_IR_Exec=pkt2cmp.control_IR_Exec;
		control_IMem_dout=pkt2cmp.control_IMem_dout;
		control_complete_data=pkt2cmp.control_complete_data;
		control_complete_instr=pkt2cmp.control_complete_instr;
		control_nzp=pkt2cmp.control_nzp;
		control_psr=pkt2cmp.control_psr;
		
	if(control_IMem_dout[15:12]==`BR || control_IMem_dout[15:12]== `JMP )
			begin				
				control_br_taken= |(control_psr & control_nzp);
				$display("Br Taken value = %d, Control_psr = %d , Control_nzp=%d",control_br_taken,control_psr,control_nzp);
			end
			else
			begin
			control_br_taken=1'b0;
			$display("Br Taken value = %d, Control_psr = %d , Control_nzp=%d",control_br_taken,control_psr,control_nzp);			
			end
	
			
		// Logic for handling dependencies (bypass)
		$display("Before First if");
		if(control_IR[15:12]==`ADD || control_IR[15:12]==`AND || control_IR[15:12]==`NOT )// if ALU
			begin
			$display("Inside First if");
			if(control_IR_Exec[15:12]==`ADD || control_IR_Exec[15:12]==`AND || control_IR_Exec[15:12]==`NOT ||
				control_IR_Exec[15:12]==`LEA)// IF ALU or LEA
					begin
					$display("Inside 2nd if");
					if(control_IR_Exec[11:9]==control_IR[8:6]) // IF dest=src1
						begin
						$display("Inside 3rd if");
						control_bypass_alu_1=1'b1;
						end
					if(control_IR_Exec[11:9]==control_IR[2:0] && control_IR[5]==1'b0)// IF dest=src2 && bit5=0
						begin
						control_bypass_alu_2=1'b1;
						end
					end
			if(control_IR_Exec[15:12]==`LD )
				begin
				if(control_IR_Exec[11:9]==control_IR[8:6])// IF dest=src1
					begin
					control_bypass_mem_1=1'b1;
					end
				if(control_IR_Exec[11:9]==control_IR[2:0] && control_IR[5]==1'b0)// IF dest=src2 && bit5=0
					begin
					control_bypass_mem_2=1'b1;
					end
				end
			end // if ALU
			if(control_IR[15:12]== `LDR)// IF LDR			
				begin
					if(control_IR_Exec[15:12]==`ADD || control_IR_Exec[15:12]==`AND || control_IR_Exec[15:12]==`NOT)// if ALU
						begin
						if(control_IR_Exec[11:9]==control_IR[8:6])// dest =base reg
							begin
							$display("Inside LDR if");
							control_bypass_alu_1=1'b1;
							end
						end
				end
			if(control_IR[15:12]== `STR)// IF STR			
				begin
					if(control_IR_Exec[15:12]==`ADD || control_IR_Exec[15:12]==`AND || control_IR_Exec[15:12]==`NOT)// if ALU
						begin
							if(control_IR_Exec[11:9]==control_IR[8:6]) // dest =sr1 reg
								begin
								$display("Inside STR if");
								control_bypass_alu_1=1'b1;
								end
							if(control_IR_Exec[11:9]==control_IR[11:9]) // dest =sr2 reg
								begin
								control_bypass_alu_2=1'b1;
								end
						end
					
				end
			if(control_IR[15:12]== `ST || control_IR[15:12]== `STI)// IF ST or STI			
				begin
					if(control_IR_Exec[15:12]==`ADD || control_IR_Exec[15:12]==`AND || control_IR_Exec[15:12]==`NOT)// if ALU
						begin
							if(control_IR_Exec[11:9]==control_IR[11:9]) // dest =src2/base reg
								begin
								control_bypass_alu_2=1'b1;
								end
						end
				end	
			if(control_IR[15:12]== `JMP)// IF JMP			
				begin
					if(control_IR_Exec[15:12]==`ADD || control_IR_Exec[15:12]==`AND || control_IR_Exec[15:12]==`NOT)// if ALU
						begin
							if(control_IR_Exec[11:9]==control_IR[8:6])// dest = src1 
								begin
								$display("Inside STR if");
								control_bypass_alu_1=1'b1;
								end
						end
				end		
		// Logic for mem_state		
		if(control_mem_state==2'b11)// init state 3
			begin
				case (control_IR[15:12])
					`ST  	:	control_mem_state=2'b10; //2
					`STR 	:	control_mem_state=2'b10; //2
					`LD		:	control_mem_state=2'b00; //0
					`LDR	:	control_mem_state=2'b00; //0
					`STI	:	control_mem_state=2'b01; //1
					`LDI	:	control_mem_state=2'b01; //1
					default :	control_mem_state=2'b11;		
				endcase
			buf_control_opcode=control_IR[15:12];
			end
		else if(control_mem_state==2'b10)// state 2
			begin
				control_mem_state=2'b11; // decays to state 3
			end
		else if(control_mem_state==2'b01) // state 1
			begin
				if(buf_control_opcode==`STI)
					begin
					control_mem_state=2'b10; // decays to state 2
					end
				else if (buf_control_opcode==`LDI)
					begin
					control_mem_state=2'b00; // decays to state 0
					end				
			end
		else if(control_mem_state==2'b00) //state 0
			begin
				control_mem_state=2'b11; // decays to state 3
			end
		// Logic for br_taken
		
		// if(control_nzp[2] & control_psr[2] || control_nzp[1] & control_psr[1]  || control_nzp[0] & control_psr[0]  )
			// begin
			// control_br_taken=1'b1;
			// end
		// else
			// begin
			// control_br_taken=1'b0;
			// end
		// Logic for controlling all the enable signals
		// Sub logic for Load and store instructions 
		if(control_IR[15:12]==`LD || control_IR[15:12]==`LDR)
			begin
			if(ld_counter==2'd0)
				begin
					control_enable_updatePC=1'b0;
					control_enable_decode=1'b0;
					control_enable_execute=1'b0;
					control_enable_writeback=1'b0;
					control_enable_fetch=1'b0;
					ld_counter=2'd1;
				end
			else if(ld_counter==2'd1)
				begin
				control_enable_updatePC=1'b1;
					control_enable_decode=1'b1;
					control_enable_execute=1'b1;
					control_enable_writeback=1'b1;
					control_enable_fetch=1'b1;
					ld_counter=2'd0;
				end
			end
		if(control_IR[15:12]==`ST || control_IR[15:12]==`STR)
			begin
			if(st_counter==2'd0)
				begin
					control_enable_updatePC=1'b0;
					control_enable_decode=1'b0;
					control_enable_execute=1'b0;
					control_enable_writeback=1'b0;
					control_enable_fetch=1'b0;
					st_counter=2'd1;
				end
			else if(st_counter==2'd1)
				begin
					control_enable_updatePC=1'b1;
					control_enable_decode=1'b1;
					control_enable_execute=1'b1;
					control_enable_writeback=1'b0;
					control_enable_fetch=1'b1;
					st_counter=2'd2;
				end
			else if(st_counter==2'd2)
				begin
					control_enable_writeback=1'b1;
					st_counter=2'd0;
				end
			end
		if(control_IR[15:12]==`LDI)
			begin
				if(ldi_counter==2'd0)
					begin
					control_enable_updatePC=1'b0;
					control_enable_decode=1'b0;
					control_enable_execute=1'b0;
					control_enable_writeback=1'b0;
					control_enable_fetch=1'b0;
					ldi_counter=2'd1;
					end
				else if(ldi_counter==2'd1)
					begin
					ldi_counter=2'd2;
					end
				else if(ldi_counter==2'd1)
					begin
					control_enable_updatePC=1'b1;
					control_enable_decode=1'b1;
					control_enable_execute=1'b1;
					control_enable_writeback=1'b1;
					control_enable_fetch=1'b1;
					ldi_counter=2'd0;
					end
			end
		if(control_IR[15:12]==`STI)
			begin
				if(sti_counter==2'd0)
					begin
						control_enable_updatePC=1'b0;
						control_enable_decode=1'b0;
						control_enable_execute=1'b0;
						control_enable_writeback=1'b0;
						control_enable_fetch=1'b0;
						sti_counter=2'd1;
					end
				else if(sti_counter==2'd1)
					begin
						sti_counter=2'd2;
					end
				else if(sti_counter==2'd2)
					begin
						control_enable_updatePC=1'b1;
						control_enable_decode=1'b1;
						control_enable_execute=1'b1;
						control_enable_writeback=1'b0;
						control_enable_fetch=1'b1;
						sti_counter=2'd3;
					end
				else if(sti_counter==2'd3)
					begin
						control_enable_writeback=1'b1;
						sti_counter=2'd0;
					end
			end
			
		if((control_IMem_dout[15:12]==`BR || control_IMem_dout[15:12]== `JMP )&& stage==0)
			begin
			control_enable_updatePC=1'b0; //disable update and fetch 
			control_enable_fetch=1'b0;
			control_enable_decode=1'b0;
			control_enable_execute=1'b1;
			control_enable_writeback=1'b1;
			stage=2;			
			end
		else if(stage==1)
				begin
				control_enable_updatePC=1'b0; //disable Decode stage as we have reached br/jmp in exe
				control_enable_fetch=1'b0;
				control_enable_decode=1'b0;
				control_enable_execute=1'b1;
				control_enable_writeback=1'b1;
				stage=2;
				end
		else if (stage==2)
				begin
				// control_enable_updatePC=1'b0; //disable Exe and Wb
				control_enable_fetch=1'b0;
				control_enable_decode=1'b0;
				control_enable_execute=1'b0;
				control_enable_writeback=1'b0;
				if(control_br_taken==1'b1)
					begin
					control_enable_updatePC=1'b1;
					updateFlag=0;
					end
				else 
					begin
					control_enable_updatePC=1'b0;
					updateFlag=1;
					end
				stage=3;	
				end
		else if(stage==3)
				begin
				if(react==0)
				begin
					if(updateFlag==1)
						begin
						control_enable_updatePC=1'b1;
						end
					react=1;
					control_enable_updatePC=1'b1; //reactivate Fetch
					control_enable_fetch=1'b1;
					control_enable_decode=1'b0;
					control_enable_execute=1'b0;
					control_enable_writeback=1'b0;
				end
				else if(react==1)
					begin
					react=2;
					control_enable_updatePC=1'b0; //reactivate Decode
					control_enable_fetch=1'b0;
					control_enable_decode=1'b1;
					control_enable_execute=1'b0;
					control_enable_writeback=1'b0;
					end
				else if(react==2)
					begin
					react=3;
					control_enable_updatePC=1'b0; //reactivate Execute
					control_enable_fetch=1'b0;
					control_enable_decode=1'b0;
					control_enable_execute=1'b1;
					control_enable_writeback=1'b0;
					end
				else if(react==3)
					begin					
					control_enable_updatePC=1'b1; //reactivate UpdatePC
					control_enable_fetch=1'b0;
					control_enable_decode=1'b0;
					control_enable_execute=1'b0;
					control_enable_writeback=1'b0;
					react=4;					
					end
				else if(react==4)
					begin
					control_enable_updatePC=1'b1; //reactivate Chain
					control_enable_fetch=1'b1;
					control_enable_decode=1'b0;
					control_enable_execute=1'b0;
					control_enable_writeback=1'b0;
					react=0;
					stage=0; // end
					end
					
				end
	end
	
endtask:controller

//************************************WRITE BACK********************************************
task Scoreboard :: writeback();
if(pkt2cmp.reset==1'b1)//reset behaviour
		begin
		wb_psr=0;
		end
else
	begin
		wb_regfile[0]=pkt2cmp.wr_R0;
		wb_regfile[1]=pkt2cmp.wr_R1;
		wb_regfile[2]=pkt2cmp.wr_R2;
		wb_regfile[3]=pkt2cmp.wr_R3;
		wb_regfile[4]=pkt2cmp.wr_R4;
		wb_regfile[5]=pkt2cmp.wr_R5;
		wb_regfile[6]=pkt2cmp.wr_R6;
		wb_regfile[7]=pkt2cmp.wr_R7;
		enable_writeback=pkt2cmp.writeback_enable_writeback;
		W_control=pkt2cmp.writeback_W_control;
		aluout=pkt2cmp.writeback_aluout;
		memout=pkt2cmp.writeback_memout;
		pcout=pkt2cmp.writeback_pcout;
		sr1=pkt2cmp.writeback_sr1;
		sr2=pkt2cmp.writeback_sr2;
		dr=pkt2cmp.writeback_dr;
		case(sr1)
				3'd0: VSR1=pkt2cmp.wr_R0;
				3'd1: VSR1=pkt2cmp.wr_R1;
				3'd2: VSR1=pkt2cmp.wr_R2;
				3'd3: VSR1=pkt2cmp.wr_R3;
				3'd4: VSR1=pkt2cmp.wr_R4;
				3'd5: VSR1=pkt2cmp.wr_R5;
				3'd6: VSR1=pkt2cmp.wr_R6;
				3'd7: VSR1=pkt2cmp.wr_R7;
			endcase
			
			case(sr2)
				3'd0: VSR2=pkt2cmp.wr_R0;
				3'd1: VSR2=pkt2cmp.wr_R1;
				3'd2: VSR2=pkt2cmp.wr_R2;
				3'd3: VSR2=pkt2cmp.wr_R3;
				3'd4: VSR2=pkt2cmp.wr_R4;
				3'd5: VSR2=pkt2cmp.wr_R5;
				3'd6: VSR2=pkt2cmp.wr_R6;
				3'd7: VSR2=pkt2cmp.wr_R7;
			endcase
		$display("[INSIDE THE WB STAGE] W_control = %b memout value = %b aluout = %b  pcout = %b",W_control,memout,aluout,pcout);
		
		if(enable_writeback==1'b1)
			begin
			case(W_control)
			2'b00: DR_in=aluout; 
			2'b01: DR_in=memout;
			2'b10: DR_in=pcout;
			default: DR_in=aluout;
			endcase
			// if(W_control==2'b00)
				// begin
				// DR_in=aluout;
				// end
			// else if(W_control==2'b01)
				// begin
				// DR_in=memout;
				// end
			// else if(W_control==2'b10)
				// begin
				// DR_in=pcout;
				// end
			// VSR1=wb_regfile[sr1];//async
			
			// VSR2=wb_regfile[sr2];//async
			//doubt --> psr is async or sync?
			if(DR_in===16'hx)
				wb_psr=3'b010;//dont cares
			if(DR_in==16'd0)
				wb_psr=3'b010;//NZP		
			else if(DR_in[15]==1'b0)
				begin				
					wb_psr=3'b001;//NZP
				end
			else if(DR_in[15]==1'b1)
				begin
					wb_psr=3'b100;//NZP
				end
		end
	end
endtask:writeback

//************************************MEMORY ACCESS********************************************
task Scoreboard :: memaccess();
//asynchronous block No reset behaviour
//inputs
M_Data=pkt2cmp.MemAccess_M_Data;
M_Addr=pkt2cmp.MemAccess_M_Addr;
M_Control=pkt2cmp.MemAccess_M_Control;
mem_state=pkt2cmp.MemAccess_mem_state;
DMem_dout=pkt2cmp.MemAccess_DMem_dout;

//logic
if(mem_state==2'b00) //read mem
	begin
	DMem_rd=1'b1;
	DMem_din=0;
	if(M_Control==1'b1)
	 DMem_Addr=DMem_dout;
	else
	 DMem_Addr=M_Addr;
	end
if(mem_state==2'b01) //read mem indirect
	begin
	DMem_rd=1'b1;
	DMem_din=0;
	DMem_Addr=M_Addr;
	end
if(mem_state==2'b10)// write mem //doubt specs
	begin
	DMem_rd=1'b0;
	DMem_din=M_Data;
	DMem_Addr=M_Addr;
	end
if(mem_state==2'b11) //init state
	begin
	DMem_rd=1'hz;
	DMem_din=16'dz;
	DMem_Addr=16'hz;
	end

//outputs

endtask

//************************************FETCH CHECK*******************************************
task Scoreboard :: checkvals_fetch();

assert(pkt2cmp.fetch_pc==buf_pc)else
	$display($time,"ns: [CHECKER_FETCH_BUG] PC VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.fetch_pc,buf_pc);
	
assert(pkt2cmp.fetch_npc_out==npc)else
	$display($time,"ns: [CHECKER_FETCH_BUG] NPC VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.fetch_npc_out,npc);
	
assert(pkt2cmp.fetch_instrmem_rd==instrmem_rd)else
	$display($time,"ns: [CHECKER_FETCH_BUG] INSTRMEM_RD VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.fetch_instrmem_rd,instrmem_rd);
	
// assert(pkt2cmp.fetch_taddr==taddr)else
	// $display($time,"ns: [CHECKER_FETCH_BUG] TADDR VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.fetch_taddr,taddr);
	
// assert(pkt2cmp.fetch_enable_updatePC==enable_updatePC)else
	// $display($time,"ns: [CHECKER_FETCH_BUG] ENABLE_UPDATE_PC VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.fetch_enable_updatePC,enable_updatePC);
// assert(pkt2cmp.fetch_enable_fetch==enable_fetch)else
	// $display($time,"ns: [CHECKER_FETCH_BUG] ENABLE_FETCH VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.fetch_enable_fetch,enable_fetch);
	
// assert(pkt2cmp.fetch_br_taken==br_taken)else
	// $display($time,"ns: [CHECKER_FETCH_BUG] BR_TAKEN VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.fetch_br_taken,br_taken);
	
$display($time,"ns: [CHECKER] pc value DUT = %x",pkt2cmp.fetch_pc);
$display($time,"ns: [CHECKER] pc value SB = %x",buf_pc);
$display($time,"ns: [CHECKER] npc value DUT = %x",pkt2cmp.fetch_npc_out);
$display($time,"ns: [CHECKER] npc value SB = %x",npc);
$display($time,"ns: [CHECKER] instrmem_rd value DUT = %x",pkt2cmp.fetch_instrmem_rd);
$display($time,"ns: [CHECKER] instrmem_rd value SB = %x",instrmem_rd);
$display($time,"ns: [CHECKER] taddr value DUT = %x",pkt2cmp.fetch_taddr);
$display($time,"ns: [CHECKER] taddr value SB = %x",taddr);
$display($time,"ns: [CHECKER] enable_updatePC value DUT = %x",pkt2cmp.fetch_enable_updatePC);
$display($time,"ns: [CHECKER] enable_updatePC value SB = %x",enable_updatePC);
$display($time,"ns: [CHECKER] enable_fetch value DUT = %x",pkt2cmp.fetch_enable_fetch);
$display($time,"ns: [CHECKER] enable_fetch value SB = %x",enable_fetch);
$display($time,"ns: [CHECKER] br_taken value DUT = %x",pkt2cmp.fetch_br_taken);
$display($time,"ns: [CHECKER] br_taken value SB = %x",br_taken);

//fetch assignment 
if(enable_updatePC)
	buf_pc=pc;

buf_enable_updatePC=enable_updatePC;
endtask

//**********************************************************DECODE CHECK *********************************


task Scoreboard :: checkvals_decode();
// assert(pkt2cmp.decode_enable_decode==enable_decode)else
	// $display($time,"ns: [CHECKER_DECODE_BUG] ENABLE_DECODE VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.decode_enable_decode,enable_decode);
	
// assert(pkt2cmp.decode_Instr_dout==Instr_dout)else
	// $display($time,"ns: [CHECKER_DECODE_BUG] INSTR_DOUT VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.decode_Instr_dout,Instr_dout);
	
assert(pkt2cmp.decode_npc_out==buf_npc_out)else
	$display($time,"ns: [CHECKER_DECODE_BUG] NPC_OUT VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.decode_npc_out,buf_npc_out);
	
assert(pkt2cmp.decode_IR==IR || pkt2cmp.decode_IR==0)else
	$display($time,"ns: [CHECKER_DECODE_BUG] IR VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.decode_IR,IR);
	
// assert(pkt2cmp.decode_npc_in==npc_in)else
	// $display($time,"ns: [CHECKER_DECODE_BUG] NPC_IN VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.decode_npc_in,npc_in);

assert(pkt2cmp.decode_Mem_control==Mem_control)else
	$display($time,"ns: [CHECKER_DECODE_BUG] MEM_CONTROL VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.decode_Mem_control,Mem_control);
	
assert(pkt2cmp.decode_E_control==E_control)else
	$display($time,"ns: [CHECKER_DECODE_BUG] E_CONTROL VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.decode_E_control,E_control);
	
assert(pkt2cmp.decode_W_control==W_control)else
	$display($time,"ns: [CHECKER_DECODE_BUG] W_CONTROL VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.decode_W_control,W_control);
	
// assert(pkt2cmp.decode_psr==psr)else
	// $display($time,"ns: [CHECKER_DECODE_BUG] PSR VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.decode_psr,psr);
	
$display($time,"ns: [CHECKER] decode_enable_decode value DUT = %x",pkt2cmp.decode_enable_decode);
$display($time,"ns: [CHECKER] decode_enable_decode value SB = %x",enable_decode);
$display($time,"ns: [CHECKER] decode_Instr_dout value DUT = %x",pkt2cmp.decode_Instr_dout);
$display($time,"ns: [CHECKER] decode_Instr_dout value SB = %x",Instr_dout);
$display($time,"ns: [CHECKER] decode_npc_out value DUT = %x",pkt2cmp.decode_npc_out);
$display($time,"ns: [CHECKER] decode_npc_out value SB = %x",buf_npc_out);
$display($time,"ns: [CHECKER] decode_IR value DUT = %x",pkt2cmp.decode_IR);
$display($time,"ns: [CHECKER] decode_IR value SB = %x",IR);
$display($time,"ns: [CHECKER] decode_npc_in value DUT = %x",pkt2cmp.decode_npc_in);
$display($time,"ns: [CHECKER] decode_npc_in value SB = %x",npc_in);
$display($time,"ns: [CHECKER] decode_Mem_control value DUT = %b",pkt2cmp.decode_Mem_control);
$display($time,"ns: [CHECKER] decode_Mem_control value SB = %b",Mem_control);
$display($time,"ns: [CHECKER] decode_E_control value DUT = %b",pkt2cmp.decode_E_control);
$display($time,"ns: [CHECKER] decode_E_control value SB = %b",E_control);
$display($time,"ns: [CHECKER] decode_W_control value DUT = %b",pkt2cmp.decode_W_control);
$display($time,"ns: [CHECKER] decode_W_control value SB = %b",W_control);

		// assignment to buffers
		buf_npc_out=npc_out;
		buf_E_control=E_control;
		buf_Mem_control=Mem_control;
		buf_W_control=W_control;
endtask

//*******************************************************EXECUTE CHECK *******************
task Scoreboard :: checkvals_execute();

assert(pkt2cmp.ex_aluout===buf_ex_aluout)else
	$display($time,"ns: [CHECKER_EXECUTE_BUG] ex_aluout VALUE MISMATCH B/N DUT = %b  GoldenRef = %b \n",pkt2cmp.ex_aluout,buf_ex_aluout);
	
assert(pkt2cmp.ex_IR_exec===buf_ex_IR_exec)else
	$display($time,"ns: [CHECKER_EXECUTE_BUG] ex_IR_exec VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.ex_IR_exec,buf_ex_IR_exec);
	
assert(pkt2cmp.ex_W_Control_out===buf_ex_W_Control_out)else
	$display($time,"ns: [CHECKER_EXECUTE_BUG] ex_W_Control_out VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.ex_W_Control_out,buf_ex_W_Control_out);

assert(pkt2cmp.ex_Mem_control_out===buf_ex_Mem_control_out)else
	$display($time,"ns: [CHECKER_EXECUTE_BUG] ex_Mem_control_out VALUE MISMATCH B/N DUT = %b  GoldenRef = %b \n",pkt2cmp.ex_Mem_control_out,buf_ex_Mem_control_out);
	
assert(pkt2cmp.ex_M_data===buf_ex_M_data)else
	$display($time,"ns: [CHECKER_EXECUTE_BUG] ex_M_data VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.ex_M_data,buf_ex_M_data);
	
assert(pkt2cmp.ex_NZP===buf_ex_NZP)else
	$display($time,"ns: [CHECKER_EXECUTE_BUG] ex_NZP VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.ex_NZP,buf_ex_NZP);
	
assert(pkt2cmp.ex_sr1===ex_sr1)else
	$display($time,"ns: [CHECKER_EXECUTE_BUG] ex_sr1 VALUE MISMATCH B/N DUT = %b  GoldenRef = %b \n",pkt2cmp.ex_sr1,ex_sr1);
	
assert(pkt2cmp.ex_dr===buf_ex_dr)else
	$display($time,"ns: [CHECKER_EXECUTE_BUG] ex_dr VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.ex_dr,buf_ex_dr);
	
assert(pkt2cmp.ex_sr2===ex_sr2)else
	$display($time,"ns: [CHECKER_EXECUTE_BUG] ex_sr2 VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.ex_sr2,ex_sr2);
	
$display($time,"ns: [CHECKER] ex_IR value DUT = %b",pkt2cmp.ex_IR);
	
	
	
//assignment of synchronous signals
buf_ex_aluout=ex_aluout;
buf_ex_IR_exec=ex_IR_exec;
buf_ex_W_Control_out=ex_W_Control_out;
buf_ex_Mem_control_out=ex_Mem_control_out;
buf_ex_M_data=ex_M_data;
buf_ex_NZP=ex_NZP;
buf_ex_dr=ex_dr;



$display($time,"ns: [CHECKER] ex_E_control value INPUT = %b",ex_E_control);		
$display($time,"ns: [CHECKER] ex_IR value INPUT = %b",ex_IR);
$display($time,"ns: [CHECKER] ex_npc_in value INPUT = %b",ex_npc_in);
$display($time,"ns: [CHECKER] ex_VSR1 value INPUT = %b",ex_VSR1);
$display($time,"ns: [CHECKER] ex_VSR2 value INPUT = %b",ex_VSR2);
$display($time,"ns: [CHECKER] ex_bypass_alu_1 value INPUT = %b",ex_bypass_alu_1);
$display($time,"ns: [CHECKER] ex_bypass_alu_2 value INPUT = %b",ex_bypass_alu_2);
$display($time,"ns: [CHECKER] ex_bypass_mem_1 value INPUT = %b",ex_bypass_mem_1);
$display($time,"ns: [CHECKER] ex_bypass_mem_2 value INPUT = %b",ex_bypass_mem_2);
$display($time,"ns: [CHECKER] ex_Mem_control_in value INPUT = %b",ex_Mem_control_in);
$display($time,"ns: [CHECKER] ex_W_Control_in value INPUT = %b",ex_W_Control_in);
$display($time,"ns: [CHECKER] ex_Mem_bypass_value value INPUT = %b",ex_Mem_bypass_value);
$display($time,"ns: [CHECKER] ex_enable_execute value INPUT = %b",ex_enable_execute);

$display($time,"ns: [CHECKER] buf_ex_aluout value Output = %b",buf_ex_aluout);
$display($time,"ns: [CHECKER] buf_ex_IR_exec value Output = %b",buf_ex_IR_exec);
$display($time,"ns: [CHECKER] buf_ex_W_Control_out value Output = %b",buf_ex_W_Control_out);
$display($time,"ns: [CHECKER] buf_ex_Mem_control_out value Output = %b",buf_ex_Mem_control_out);
$display($time,"ns: [CHECKER] buf_ex_M_data value Output = %b",buf_ex_M_data);
$display($time,"ns: [CHECKER] buf_ex_NZP value Output = %b",buf_ex_NZP);
$display($time,"ns: [CHECKER] buf_ex_dr value Output = %b",buf_ex_dr);

endtask 


//*******************************************************WRITEBACK CHECK *******************
task Scoreboard :: checkvals_writeback();
assert(pkt2cmp.writeback_psr==buf_wb_psr)else
	$display($time,"ns: [CHECKER_WRITEBACK_BUG] PSR VALUE MISMATCH B/N DUT = %b  GoldenRef = %b \n",pkt2cmp.writeback_psr,buf_wb_psr);
	
assert(pkt2cmp.writeback_VSR1===VSR1)else
	$display($time,"ns: [CHECKER_WRITEBACK_BUG] VSR1 VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.writeback_VSR1,VSR1);
	
assert(pkt2cmp.writeback_VSR2===VSR2)else
	$display($time,"ns: [CHECKER_WRITEBACK_BUG] VSR2 VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.writeback_VSR2,VSR2);

	
$display($time,"ns: [CHECKER] writeback_psr value DUT = %b",pkt2cmp.writeback_enable_writeback);
$display($time,"ns: [CHECKER] writeback_W_control value DUT = %b",pkt2cmp.writeback_W_control);
$display($time,"ns: [CHECKER] writeback_aluout value DUT = %b",pkt2cmp.writeback_aluout);
$display($time,"ns: [CHECKER] pkt2cmp.writeback_memout value DUT = %b",pkt2cmp.writeback_memout);
$display($time,"ns: [CHECKER] pkt2cmp.writeback_sr1 value DUT = %b",pkt2cmp.writeback_sr1);
$display($time,"ns: [CHECKER] pkt2cmp.writeback_sr2 value DUT = %b",pkt2cmp.writeback_sr2);
$display($time,"ns: [CHECKER] pkt2cmp.pkt2cmp.writeback_dr value DUT = %b",pkt2cmp.writeback_dr);
$display($time,"ns: [CHECKER]enable_writeback value DUT = %b",pkt2cmp.writeback_enable_writeback);
$display($time,"ns: [CHECKER] DR_in value SB = %b",DR_in);
$display($time, "ns: [CHECKER] Value for wb_regfile = %b \n %b \n %b \n %b \n %b \n %b \n %b \n %b \n ",wb_regfile[0],wb_regfile[1],wb_regfile[2],wb_regfile[3],wb_regfile[4],wb_regfile[5],wb_regfile[6],wb_regfile[7]);
$display($time,"ns: [CHECKER] writeback_psr value DUT = %b",pkt2cmp.writeback_psr);
$display($time,"ns: [CHECKER] writeback_psr value SB = %b",buf_wb_psr);
$display($time,"ns: [CHECKER] writeback_psr value DUT = %b",pkt2cmp.writeback_VSR1);
$display($time,"ns: [CHECKER] writeback_VSR1 value SB = %b",VSR1);
$display($time,"ns: [CHECKER] writeback_psr value DUT = %b",pkt2cmp.writeback_VSR2);
$display($time,"ns: [CHECKER] writeback_VSR2 value SB = %b",VSR2);	

buf_wb_psr=wb_psr;
endtask 

//*******************************************************MEMACCESS CHECK *******************
task Scoreboard :: checkvals_memaccess();
assert(pkt2cmp.MemAccess_DMem_addr===DMem_Addr)else
	$display($time,"ns: [CHECKER_MEMACCESS_BUG] DMEM_ADDR VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.MemAccess_DMem_addr,DMem_Addr);
	
assert(pkt2cmp.MemAccess_DMem_din===DMem_din)else
	$display($time,"ns: [CHECKER_MEMACCESS_BUG] DMEM_DIN VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.MemAccess_DMem_din,DMem_din);
	
assert(pkt2cmp.MemAccess_DMem_rd===DMem_rd)else
	$display($time,"ns: [CHECKER_MEMACCESS_BUG] DMEM_RD VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.MemAccess_DMem_rd,DMem_rd);
	//assigning the psr synchronously
	buf_wb_psr=wb_psr;

$display("M_Data = %x",M_Data);
$display("M_Addr = %x",M_Addr);
$display("M_Control = %x",M_Control);
$display("mem_state = %x",mem_state);
$display("output DMem_rd = %x",DMem_rd);
$display("output DMem_din = %x",DMem_din);
$display("output DMem_Addr = %x",DMem_Addr);

endtask 
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CONTROLLER CHECK <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
task Scoreboard :: checkvals_controller();

assert(pkt2cmp.control_enable_fetch===control_enable_fetch)else
	$display($time,"ns: [CHECKER_CONTROLLER_BUG] control_enable_fetch VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.control_enable_fetch,control_enable_fetch);
	
assert(pkt2cmp.control_enable_updatePC===control_enable_updatePC)else
	$display($time,"ns: [CHECKER_CONTROLLER_BUG] control_enable_updatePC VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.control_enable_updatePC,control_enable_updatePC);
	
assert(pkt2cmp.control_enable_decode===control_enable_decode)else
	$display($time,"ns: [CHECKER_CONTROLLER_BUG] control_enable_decode VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.control_enable_decode,control_enable_decode);

assert(pkt2cmp.control_enable_execute===control_enable_execute)else
	$display($time,"ns: [CHECKER_CONTROLLER_BUG] control_enable_execute VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.control_enable_execute,control_enable_execute);
	
assert(pkt2cmp.control_enable_writeback===control_enable_writeback)else
	$display($time,"ns: [CHECKER_CONTROLLER_BUG] control_enable_writeback VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.control_enable_writeback,control_enable_writeback);
	
assert(pkt2cmp.control_br_taken===control_br_taken)else
	$display($time,"ns: [CHECKER_CONTROLLER_BUG] control_br_taken VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.control_br_taken,control_br_taken);
		
assert(pkt2cmp.control_bypass_alu_1===control_bypass_alu_1)else
	$display($time,"ns: [CHECKER_CONTROLLER_BUG] control_bypass_alu_1 VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.control_bypass_alu_1,control_bypass_alu_1);
	
assert(pkt2cmp.control_bypass_alu_2===control_bypass_alu_2)else
	$display($time,"ns: [CHECKER_CONTROLLER_BUG] control_bypass_alu_2 VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.control_bypass_alu_2,control_bypass_alu_2);
			
assert(pkt2cmp.control_bypass_mem_1===control_bypass_mem_1)else
	$display($time,"ns: [CHECKER_CONTROLLER_BUG] control_bypass_mem_1 VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.control_bypass_mem_1,control_bypass_mem_1);
		
assert(pkt2cmp.control_bypass_mem_2===control_bypass_mem_2)else
	$display($time,"ns: [CHECKER_CONTROLLER_BUG] control_bypass_mem_2 VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.control_bypass_alu_2,control_bypass_alu_2);
		
assert(pkt2cmp.control_mem_state===buf_control_mem_state)else
	$display($time,"ns: [CHECKER_CONTROLLER_BUG] control_mem_state VALUE MISMATCH B/N DUT = %x  GoldenRef = %x \n",pkt2cmp.control_mem_state,buf_control_mem_state);
					

$display("INPUT control_IR = %x",control_IR);
$display("INPUT control_IR_Exec = %x",control_IR_Exec);
$display("INPUT control_IMem_dout = %x",control_IMem_dout);
$display("INPUT control_complete_data = %x",control_complete_data);
$display("INPUT control_complete_instr = %x",control_complete_instr);
$display("INPUT control_nzp = %x",control_nzp);
$display("INPUT control_psr = %x",control_psr);
$display("INPUT DUT Mem State = %x",pkt2cmp.control_mem_state);
$display("INPUT DUT control_br_taken = %x",pkt2cmp.control_br_taken);
$display("INPUT DUT control_enable_fetch = %x",pkt2cmp.control_enable_fetch);
$display("INPUT DUT control_enable_updatePC = %x",pkt2cmp.control_enable_updatePC);
$display("INPUT DUT control_enable_decode = %x",pkt2cmp.control_enable_decode);
$display("INPUT DUT control_enable_execute = %x",pkt2cmp.control_enable_execute);
$display("INPUT DUT control_enable_writeback = %x",pkt2cmp.control_enable_writeback);
$display("control_enable_fetch = %x",control_enable_fetch);
$display("control_enable_updatePC = %x",control_enable_updatePC);
$display("control_enable_decode = %x",control_enable_decode);
$display("control_enable_execute = %x",control_enable_execute);
$display("output control_enable_writeback = %x",control_enable_writeback);
$display("output control_br_taken = %x",control_br_taken);
$display("output control_bypass_alu_1 = %x",control_bypass_alu_1);	
$display("output control_bypass_alu_2 = %x",control_bypass_alu_2);
$display("output control_bypass_mem_1 = %x",control_bypass_mem_1);
$display("output control_bypass_mem_2 = %x",control_bypass_mem_2);
$display("output control_mem_state = %x",buf_control_mem_state);
buf_control_mem_state=control_mem_state;
endtask 
