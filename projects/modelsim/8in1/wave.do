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
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/variables_out1
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/variables_out2
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/variables_out3
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/variables_out4
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/variables_out5
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/variables_out6
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/variables_out7
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/variables_out8
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/words_out1
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/words_out2
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/words_out3
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/words_out4
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/words_out5
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/words_out6
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/words_out7
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/words_out8
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/sum0_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/sum1_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/sigm0_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/sigm1_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/ch_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/maj_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/Kt_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/new_a
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/new_e
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/words
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/variables
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/o_variables
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/o_words
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/var_a
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/var_b
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/var_c
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/var_d
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/var_e
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/var_f
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/var_g
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/var_h
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/o_var_a
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/o_var_b
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/o_var_c
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/o_var_d
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/o_var_e
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/o_var_f
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/o_var_g
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/o_var_h
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/sum0_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/sum1_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/sigm0_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/sigm1_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/ch_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/maj_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/Kt_out
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/new_word
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/new_a
add wave -noupdate /top_tb/spi_hash/sha256_core_inst/inst_sh1/new_e
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/par_add_6_inst/data0x
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/par_add_6_inst/data1x
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/par_add_6_inst/data2x
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/par_add_6_inst/data3x
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/par_add_6_inst/data4x
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/par_add_6_inst/data5x
add wave -noupdate -radix hexadecimal /top_tb/spi_hash/sha256_core_inst/inst_sh1/par_add_6_inst/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {598415127 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 381
configure wave -valuecolwidth 287
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
WaveRestoreZoom {598227648 ps} {598691372 ps}
