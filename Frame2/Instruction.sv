class Instruction;
	logic [15:0] Instr_dout;
	rand logic [3:0]op;
	rand logic [2:0]dr;
	rand logic [2:0] sr1;
	rand logic bit5;
	rand logic [4:0] im_sr2;
	rand logic [8:0] pcof;
	
	// typedef struct packed{ // define d a packed structure to hold the instructions 
	// logic [3:0]op;
	// logic [2:0]dr;
	// logic [2:0] sr1;
	// logic bit5;
	// logic [4:0] im_sr2;
	// logic [8:0] pcof;
	// }Instr;
	// Instr Instr_dout;
	rand logic [15:0]  Data_dout; // 16 bits		
	logic  reset;// 1 bit
	logic complete_data; // 1 bit
	logic complete_instr; // 1 bit
	
	constraint Limit {
		op inside{1};// Stuck at ADD for now
		// op inside{[0:3],[5:7],[9:12],14} // includes all the opcodes 
		dr inside {[0:7]};
		sr1 inside{[0:7]};
		if(op==1 || op==5 || op==9)// for all ALU
		{
			bit5 inside{[0:1]};
				if(bit5==1'b0){
				im_sr2 inside{[0:7]};
				}
				else if(bit5==1'b1){
					im_sr2 inside{[0:31]}; 
					}
		}
		
	}
	
	extern function new();	

endclass

function Instruction::new();
	complete_data=1'b1;
	complete_instr=1'b1;
	reset=1'b0;
endfunction
	