
class DriveBase;
virtual LC3_io.TB lc3io; // define the virtual type interface 
Instruction Ival; // define the instruction 
logic [3:0] drive_op;
logic [2:0] drive_dr;
logic [2:0] drive_sr1;
logic drive_bit5;
logic [4:0] drive_im_sr2;
logic [8:0] drive_pcof;
logic [15:0] drive_Instr_dout;
logic [15:0]  drive_Data_dout; // 16 bits		
logic  drive_reset;// 1 bit
logic drive_complete_data; // 1 bit
logic drive_complete_instr; // 1 bit
	
function new(virtual LC3_io.TB lc3io);
this.lc3io=lc3io;
endfunction

virtual task send();
sendload();
endtask

virtual task sendload();
if(drive_op==1 || drive_op==5 || drive_op==9 )//for ALU
	begin
	drive_Instr_dout={drive_op,drive_dr,drive_sr1,drive_bit5,drive_im_sr2};
	end
lc3io.cb.Instr_dout <= drive_Instr_dout;
lc3io.cb.Data_dout <= drive_Data_dout;
lc3io.complete_data <= 1'b1;
lc3io.complete_instr <= 1'b1;
lc3io.cb.reset <= 1'b0;

endtask
endclass

