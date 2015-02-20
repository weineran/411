onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /mp1_tb/clk
add wave -noupdate -label pc_out /mp1_tb/dut/the_datapath/pc/out
add wave -noupdate -label mem_addr /mp1_tb/mem_address
add wave -noupdate -label mem_read /mp1_tb/mem_read
add wave -noupdate -label mem_rdata /mp1_tb/mem_rdata
add wave -noupdate -label mem_write /mp1_tb/mem_write
add wave -noupdate -label mem_byte_enable /mp1_tb/mem_byte_enable
add wave -noupdate -label mem_wdata /mp1_tb/mem_wdata
add wave -noupdate -label {register file} -expand /mp1_tb/dut/the_datapath/the_regfile/data
add wave -noupdate -label opcode /mp1_tb/dut/the_datapath/instr_reg/opcode
add wave -noupdate -label regfilemux_sel /mp1_tb/dut/the_datapath/regfilemux/sel
add wave -noupdate -label state /mp1_tb/dut/the_control/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {44185050 ps} 0}
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
WaveRestoreZoom {44083866 ps} {45235528 ps}
