
program testbench(LC3_io.TB lc3io,dut_Probe_if dut_io);
Generator gen1;
Drive drive1;
int 	number_packets;

initial begin
number_packets = 100;
gen1=new(number_packets);
drive1=new(lc3io,gen1.in_box);
reset();
gen1.start();
drive1.start();
repeat(number_packets+1) @(lc3io.cb);
$display($time,"End of test reached");
end

task reset();
	$display ($time, "ns:  [RESET]  Design Reset Start");
	lc3io.cb.reset 			<= 1'b1; 
	repeat(5) @(lc3io.cb);
	lc3io.cb.reset 			<= 1'b0;
	$display ($time, "ns:  [RESET]  Design Reset End");
endtask

endprogram
