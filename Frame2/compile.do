# Compilation File for Modelsim

rm -fr mti_lib 
vlib mti_lib
vlog *.vp
vlog *.v
vlog -mfcu -sv -suppress 2217 Instruction.sv Gen.sv Drive.sv OutputPacket.sv Receiver.sv project.if.sv testbench.sv top.sv
vsim -novopt LC3_test_top &
