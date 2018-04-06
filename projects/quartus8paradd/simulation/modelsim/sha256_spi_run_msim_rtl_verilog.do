transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/workspace/sha256-core/src/altera/8\ round {C:/workspace/sha256-core/src/altera/8 round/sha256_core_clk.v}
vlog -vlog01compat -work work +incdir+C:/workspace/sha256-core/src/altera/8\ round {C:/workspace/sha256-core/src/altera/8 round/sha256_coefs_clk.v}
vlog -vlog01compat -work work +incdir+C:/workspace/sha256-core/src/sha/Vanilla {C:/workspace/sha256-core/src/sha/Vanilla/sha256_math.v}
vlog -vlog01compat -work work +incdir+C:/workspace/sha256-core/src/spi {C:/workspace/sha256-core/src/spi/spi_slave.v}
vlog -vlog01compat -work work +incdir+C:/workspace/sha256-core/src/top {C:/workspace/sha256-core/src/top/sha256_spi.v}
vlog -vlog01compat -work work +incdir+C:/workspace/sha256-core/projects/quartus {C:/workspace/sha256-core/projects/quartus/par_add_6.v}
vlog -vlog01compat -work work +incdir+C:/workspace/sha256-core/projects/quartus {C:/workspace/sha256-core/projects/quartus/par_add_7.v}
vlog -vlog01compat -work work +incdir+C:/workspace/sha256-core/projects/quartus {C:/workspace/sha256-core/projects/quartus/par_add_4.v}

