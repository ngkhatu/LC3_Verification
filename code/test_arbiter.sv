//********************************************************************                                        
//  AUTHOR: Engineering Design Institute/ASIC Design and Verification	                                                     		
//  DESCRIPTION: Test bench for Arbiter (filename=xor_design.v)                                       
//  MODULE NAME: test_arbiter
//********************************************************************
 `timescale 10 ns / 1 ps
 module test_arbiter(arb_if arbif);
 logic [1:0] grant=2'b0;
 int test_passed=0;
 int test_failed=0;
 int total_test=0;
 initial 
	begin
		$display($time,"ns [TB] Start Testing");
		@(posedge arbif.clk);
		arbif.reset=1'b1;
		grant=2'b0;
		arbif.request=2'b0;
		$display($time,"ns [TB][RESET] Asserting Reset: %b",arbif.reset);
		repeat (5) @(posedge arbif.clk);
		$display($time,"ns [TB][RESET] Clearing Reset: %b",arbif.reset);
		arbif.reset=1'b0;
		@(posedge arbif.clk);
		repeat(40)
			begin
				arbif.request=$urandom_range(0,3);
				$display($time,"ns------------------------------------------------------");
				$display($time,"ns [TB][DRIVER] Drove Request: %b",arbif.request);
				golden_ref();
				repeat (2) @(posedge arbif.clk);
				if(arbif.grant==grant)
					begin
						$display($time,"[TB][CHECKER] Test Passed: %b", arbif.grant);
						test_passed=test_passed+1;
					end
				else
					begin
						$display($time,"[TB][CHECKER] Test Failed: %b", arbif.grant);
						test_failed=test_failed+1;
					end
				total_test=total_test+1;
			end
			$display($time,"----------[TB][FINAL] TEST STATS---------");
			$display($time,"TEST PASSED: %d",test_passed);
			$display($time,"TEST FAILED: %d",test_failed);
			$display($time,"TEST TOTAL: %d",total_test);
		$finish;
	end

	task golden_ref();
		case(arbif.request)
				 2'b00: begin grant=2'b00; end
				 2'b01: begin grant=2'b01; end
				 2'b10: begin grant=2'b10; end
				 2'b11: begin grant=2'b11; end
		endcase
		$display($time,"ns [TB][GOLD REF] Request: %b| Grant: %b",arbif.request,grant);	
	endtask
 endmodule
