onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /mp2_tb/clk
add wave -noupdate -label data0 /mp2_tb/dut/the_cache/the_c_datapath/data_0/data
add wave -noupdate -label data1 /mp2_tb/dut/the_cache/the_c_datapath/data_1/data
add wave -noupdate -label c_index /mp2_tb/dut/the_cache/the_c_datapath/c_index
add wave -noupdate -label tag0 /mp2_tb/dut/the_cache/the_c_datapath/tag_0/data
add wave -noupdate -label tag1 /mp2_tb/dut/the_cache/the_c_datapath/tag_1/data
add wave -noupdate -label lru /mp2_tb/dut/the_cache/the_c_datapath/lru/data
add wave -noupdate -label is_hit /mp2_tb/dut/the_cache/the_c_datapath/check_hit/is_hit
add wave -noupdate -label hit_sel /mp2_tb/dut/the_cache/the_c_datapath/check_hit/hit_sel
add wave -noupdate -label Dout_Valid0 /mp2_tb/dut/the_cache/the_c_datapath/Dout_Valid0
add wave -noupdate -label Dout_Valid1 /mp2_tb/dut/the_cache/the_c_datapath/Dout_Valid1
add wave -noupdate -label valid_out /mp2_tb/dut/the_cache/the_c_datapath/valid_out
add wave -noupdate -label dirty_out /mp2_tb/dut/the_cache/the_c_datapath/dirty_out
add wave -noupdate -label r0 {/mp2_tb/dut/the_cpu/the_datapath/the_regfile/data[0]}
add wave -noupdate -label r1 {/mp2_tb/dut/the_cpu/the_datapath/the_regfile/data[1]}
add wave -noupdate -label r2 {/mp2_tb/dut/the_cpu/the_datapath/the_regfile/data[2]}
add wave -noupdate -label r3 {/mp2_tb/dut/the_cpu/the_datapath/the_regfile/data[3]}
add wave -noupdate -label r4 {/mp2_tb/dut/the_cpu/the_datapath/the_regfile/data[4]}
add wave -noupdate -label r5 {/mp2_tb/dut/the_cpu/the_datapath/the_regfile/data[5]}
add wave -noupdate -label r6 {/mp2_tb/dut/the_cpu/the_datapath/the_regfile/data[6]}
add wave -noupdate -label r7 {/mp2_tb/dut/the_cpu/the_datapath/the_regfile/data[7]}
add wave -noupdate -label {CPU state} /mp2_tb/dut/the_cpu/the_control/state
add wave -noupdate -label {cache state} /mp2_tb/dut/the_cache/the_c_control/state
add wave -noupdate -label opcode /mp2_tb/dut/the_cpu/the_control/opcode
add wave -noupdate -label mem_address /mp2_tb/dut/the_cpu/mem_address
add wave -noupdate -label pmem_address /mp2_tb/pmem_address
add wave -noupdate -label pmem_rdata /mp2_tb/pmem_rdata
add wave -noupdate -label mem_rdata /mp2_tb/dut/the_cache/the_c_datapath/mem_rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {229296 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 146
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
WaveRestoreZoom {0 ps} {330688 ps}
