class Generator;
		logic [3:0]op;
		logic [2:0]dr;
		logic [2:0] sr1;
		logic bit5;
		logic [4:0] im_sr2;
		logic [8:0] pcof;
		integer sel; // stores the generated random number that selects the kind of instruction to be sent to the DUT/TEST
		integer lastCM;// Stores the number of instructions since the last Mem or Control instruction
		integer limit;// Stores the minimum number of ALU instruction b/n 2 Mem or Control instruction
		
		function new();
		op=4'b0000;
		dr=3'b000;
		sr1=3'b000;
		bit5=1'b0;
		im_sr2=5'b00000;
		limit=4;
		lastCM=0; // So that the first 4 instructions are ALU type
		endfunction: new
		
		function void gen_add();
		op=4'b0001;
		dr=$urandom_range(7,0);
		sr1=$urandom_range(7,0);
		bit5=$urandom_range(1,0);
		if(bit5==1'b0)
			begin
			im_sr2={2'b00,$urandom_range(7,0)};		
			end
		else
			begin
			im_sr2=$urandom_range(31,0);
			end
		endfunction: gen_add
		
		function void gen_and();
		op=4'b0101;
		dr=$urandom_range(7,0);
		sr1=$urandom_range(7,0);
		bit5=$urandom_range(1,0);
		if(bit5==1'b0)
			begin
			im_sr2={2'b00,$urandom_range(7,0)};		
			end
		else
			begin
			im_sr2=$urandom_range(31,0);
			end
		endfunction: gen_and
		
		function void gen_not();
			op=4'b1001;
			dr=$urandom_range(7,0);
			sr1=$urandom_range(7,0);
			bit5=1'b1;
			im_sr2=5'b11111;
		endfunction: gen_not
		
		function void gen_ld();
			//logic [8:0]pcof;
			op=4'b0010;
			dr=$urandom_range(7,0);	
			pcof=$urandom_range(511,0);
			sr1=pcof[8:6];
			bit5=pcof[5];
			im_sr2=pcof[4:0];
		endfunction : gen_ld
		
		function void gen_ldr();
		//	logic [8:0] pcof;
			op=4'b0110;
			dr=$urandom_range(7,0);	
			pcof=$urandom_range(511,0);
			sr1=pcof[8:6];
			bit5=pcof[5];
			im_sr2=pcof[4:0];
		endfunction : gen_ldr
		
		function void gen_ldi();
			//logic [8:0]pcof;
			op=4'b1010;
			dr=$urandom_range(7,0);	
			pcof=$urandom_range(511,0);
			sr1=pcof[8:6];
			bit5=pcof[5];
			im_sr2=pcof[4:0];
		endfunction : gen_ldi
		
		function void gen_lea();
			//logic [8:0]pcof;
			op=4'b1110;
			dr=$urandom_range(7,0);	
			pcof=$urandom_range(511,0);
			sr1=pcof[8:6];
			bit5=pcof[5];
			im_sr2=pcof[4:0];
		endfunction : gen_lea
			
		function void gen_st();
			//logic [8:0]pcof;
			op=4'b0011;
			dr=$urandom_range(7,0);	
			pcof=$urandom_range(511,0);
			sr1=pcof[8:6];
			bit5=pcof[5];
			im_sr2=pcof[4:0];
		endfunction : gen_st
		
		function void gen_str();
			//logic [8:0]pcof;
			op=4'b0111;
			dr=$urandom_range(7,0);	
			pcof=$urandom_range(511,0);
			sr1=pcof[8:6];
			bit5=pcof[5];
			im_sr2=pcof[4:0];
		endfunction : gen_str
		
		function void gen_sti();
			//logic [8:0]pcof;
			op=4'b1011;
			dr=$urandom_range(7,0);	
			pcof=$urandom_range(511,0);
			sr1=pcof[8:6];
			bit5=pcof[5];
			im_sr2=pcof[4:0];
		endfunction : gen_sti
		
		function void gen_br();
			//logic [8:0]pcof;
			op=4'b0000;
			dr=$urandom_range(7,0);		
			pcof=$urandom_range(511,0);
			sr1=pcof[8:6];
			bit5=pcof[5];
			im_sr2=pcof[4:0];
		endfunction : gen_br
			
		function void gen_jmp();
			//logic [8:0]pcof;
			op=4'b1100;
			dr=3'b000;			
			sr1=pcof[8:6];
			bit5=1'b0;
			im_sr2=5'b00000;
		endfunction : gen_jmp
		
		function logic[15:0] inst_gen();
			sel=$urandom_range(12,1);// can have values from 1 to 12 as there are 12 type of instructions
			if(sel>3)// check if the sel is more than 3 (ADD,AND,NOT)
				begin
				//if more than 3 need to check if lastCM < limit
					if(lastCM < limit)
					begin			
					sel=$urandom_range(3,1); // Restrict the Instruction type to ALU only
					end		
				end
			//Switch case to generate the required Instr according to the 'sel' gen/calc
			unique case(sel)
				1: gen_add();
				2: gen_and();
				3: gen_not();
				4: gen_ld();
				5: gen_ldr();
				6: gen_ldi();
				7: gen_lea();
				8: gen_st();
				9: gen_str();
				10: gen_sti();
				11: gen_br();
				12:	gen_jmp();
			endcase	
		
		return {op,dr,sr1,bit5,im_sr2}; // returning the generated Instruction
		endfunction : inst_gen 
	endclass
