onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/r_variables
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/r_words
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/r_round
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/completed
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/run_signal
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/do_math
add wave -noupdate -radix hexadecimal /top_tb/golden_hash
add wave -noupdate -radix hexadecimal /top_tb/win
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sha/sh_add_inst/o_d
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sha/sh_add_inst/o_a
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sha/sh_add_inst/o_word
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sha/inst_coef_clk/o_coef_value
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sha/inst_coef_clk_prec/i_coef_num
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sha/inst_coef_clk_prec/o_coef_value
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sha/inst_coef_clk/i_coef_num
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sha/inst_coef_clk/o_coef_value
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sha/r_t3_precalculated
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sha/r_round_prec
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sha/Kt_out_prec
add wave -noupdate {/top_tb/spi_hash/sha256_core_inst/r_status[5]}
add wave -noupdate {/top_tb/spi_hash/sha256_core_inst/r_status[4]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {598425000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 399
configure wave -valuecolwidth 61
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
WaveRestoreZoom {595946220 ps} {600903780 ps}
