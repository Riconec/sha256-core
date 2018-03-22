onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/spi_hash/i_clk
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/r_variables
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/r_words
add wave -noupdate -radix unsigned /top_tb/spi_hash/sha256_core_inst/r_round
add wave -noupdate -radix unsigned /top_tb/spi_hash/sha256_core_inst/r_coef
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/r_status
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_coef_clk/o_coef_value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {598493999 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 281
configure wave -valuecolwidth 117
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
configure wave -timelineunits ps
update
WaveRestoreZoom {598253014 ps} {599396986 ps}
