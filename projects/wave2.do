onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/i_clk
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/i_rst_n
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/r_variables
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/r_words
add wave -noupdate -radix unsigned /top_tb/spi_hash/sha256_core_inst/r_round
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/r_coef
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/r_status
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/completed
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/run_signal
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/do_math
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/words
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/o_words
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/sigm0_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/sigm1_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/ch_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/maj_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/new_word
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/new_a
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/new_e
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/Kt_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh2/Kt_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh3/Kt_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh4/Kt_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh5/Kt_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh6/Kt_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh7/Kt_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh8/Kt_out
add wave -noupdate -radix unsigned /top_tb/spi_hash/sha256_core_inst/inst_sh2/r_coef
add wave -noupdate -radix unsigned /top_tb/spi_hash/sha256_core_inst/inst_sh3/r_coef
add wave -noupdate -radix unsigned /top_tb/spi_hash/sha256_core_inst/inst_sh4/r_coef
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {598825000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 326
configure wave -valuecolwidth 97
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
WaveRestoreZoom {598293149 ps} {599124363 ps}
