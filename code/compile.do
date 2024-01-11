# Compilation File for Modelsim

vlog -sv test_arbiter.sv
vlog arbiter.v
vlog arbiter_interface.sv
vlog top.sv
vsim -novopt top
#log -r /*
run -all
$stop


