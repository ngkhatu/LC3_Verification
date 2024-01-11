//********************************************************************                                        
//  AUTHOR: Engineering Design Institute/ASIC Design and Verification	                                                     		
//  DESCRIPTION: 2 Bit Arbiter                                         
//  MODULE NAME: arbiter
//********************************************************************
 `timescale 10 ns / 1 ps

 module arbiter( clk,
				reset,
				grant,
				request);
 input clk;
 input reset;
 input [1:0] request;
output reg [1:0] grant;
 

  `pragma protect begin
 always @(posedge clk)
	begin
		if(!reset)
			begin
				case(request)
				 2'b00: begin grant<=2'b00; end
				 2'b01: begin grant<=2'b01; end
				 2'b10: begin grant<=2'b10; end
				 2'b11: begin grant<=2'b11; end
				endcase
				$display($time,"ns [DUT][MAIN] Request: %b| Grant: %b",request,grant);	
			end
		else
			begin
				grant<=0;
				$display($time,"ns [DUT][RESET] Reseting the DUT: %b",grant);	
			end
	end
 endmodule
 `pragma protect end
 
 
 

 
 
 
 
 