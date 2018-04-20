onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/i_clk
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/r_variables
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/r_round
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/completed
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/run_signal
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/do_math
add wave -noupdate -radix hexadecimal /top_tb/golden_hash
add wave -noupdate /top_tb/win
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {601625000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 273
configure wave -valuecolwidth 376
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
WaveRestoreZoom {0 ps} {1260 us}
run 800 us
