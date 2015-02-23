onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /mp2_tb/clk
add wave -noupdate -label Dout_Data0 /mp2_tb/dut/the_cache/the_c_datapath/Dout_Data0
add wave -noupdate -label Dout_Data1 /mp2_tb/dut/the_cache/the_c_datapath/Dout_Data1
add wave -noupdate -label Dout_LRU /mp2_tb/dut/the_cache/the_c_datapath/Dout_LRU
add wave -noupdate -label registers -expand /mp2_tb/dut/the_cpu/the_datapath/the_regfile/data
add wave -noupdate -label {CPU state} /mp2_tb/dut/the_cpu/the_control/state
add wave -noupdate -label {cache state} /mp2_tb/dut/the_cache/the_c_control/state
add wave -noupdate -label opcode /mp2_tb/dut/the_cpu/the_control/opcode
add wave -noupdate -label pmem_address /mp2_tb/pmem_address
add wave -noupdate -label pmem_rdata /mp2_tb/pmem_rdata
add wave -noupdate -label mem_rdata /mp2_tb/dut/the_cache/the_c_datapath/mem_rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14935122 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 159
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2457180 ps} {2529028 ps}
