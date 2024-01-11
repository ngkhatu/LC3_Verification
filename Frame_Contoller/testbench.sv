program testbench(LC3_io.TB lc3io,dut_Probe_if dut_io);
Generator gen1;
Drive drive1;
Receiver rcv;
Scoreboard sb1;
int 	number_packets;

initial begin
number_packets = 1000;
gen1=new(number_packets);
$display ($time, "[SCOREBOARD] Scoreboard starting new ");
sb1=new();
$display ($time, "[SCOREBOARD] Driver starting new ");
drive1=new(lc3io,gen1.in_box,sb1.driver_mbox);
$display ($time, "[SCOREBOARD] Receiver starting new ");
rcv=new(sb1.receiver_mbox,lc3io,dut_io);
reset();
gen1.start();
drive1.start();
$display($time,"Start of Sb called");
sb1.start();
rcv.start();
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
