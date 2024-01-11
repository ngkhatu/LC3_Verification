//********************************************************************                                        
//  AUTHOR: Engineering Design Institute/ASIC Design and Verification	                                                     		
//  DESCRIPTION: Test bench for Arbiter (filename=xor_design.v)                                       
//  MODULE NAME: test_arbiter
//********************************************************************
 `timescale 10 ns / 1 ps
 module top();
 bit clk;
 always #5 clk=~clk;
 
 arb_if arbif(clk);
 
arbiter a1 (.clk(arbif.clk),
			.reset(arbif.reset),
			.request(arbif.request),
			.grant(arbif.grant));
			
 test_arbiter test(arbif);
 endmodule
