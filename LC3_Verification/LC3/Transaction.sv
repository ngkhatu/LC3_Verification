class Transaction;
	rand bit [31:0] src, dst, data[8];
	bit [31:0] csm;

	virtual function void calc_csm();
	
	
	endfunction

	virtual function  void display();
	
	endfunction

endclass