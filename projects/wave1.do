onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/i_clk
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/i_rst_n
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/r_variables
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/r_words
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/r_round
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
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/Kt_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/new_word
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/new_a
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/inst_sh1/new_e
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {598875000 ps} 0}
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
WaveRestoreZoom {598354816 ps} {599395184 ps}
