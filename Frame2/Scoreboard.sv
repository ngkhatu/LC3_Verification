class Scoreboard;
Instruction Ival= new(); // instruction from driver
typedef mailbox #(Instruction) out_box_type;
       out_box_type driver_mbox;		// mailbox for Instruction objects from Drivers

typedef mailbox #(OutputPacket) rx_box_type;
       rx_box_type 	receiver_mbox;		// mailbox for Packet objects from Receiver
	   
	   	// Declare the signals to be compared over here.
		extern function new( out_box_type driver_mbox = null, rx_box_type receiver_mbox = null);
		extern virtual task start();
		extern virtual task fetch();
		// extern virtual task decode();
		// extern virtual task execute();
		// extern virtual task writeback();
		// extern virtual task memacc();
		// extern virtual task controller();
		extern virtual task checkfetch();
endclass