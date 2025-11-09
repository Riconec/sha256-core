# Verilator file list for SHA-256 core
# Generated for top_tb.v testbench (SPI wrapper testbench)

# Include directories
+incdir+src/top
+incdir+src/sha
+incdir+src/spi
+incdir+src/adders

# Definitions
src/top/defines_top.vh

# Top level testbench
src/top/top_tb.v

# SPI wrapper (instantiated in testbench)
src/top/sha256_spi.v

# Main SHA-256 core (instantiated inside SPI wrapper)
src/sha/sha256_core_clk.v

# SHA-256 mathematical functions
src/sha/sha256_math.v

# SHA-256 constants
src/sha/sha256_coefs.v

# SHA-256 adder module
src/adders/sha_adder_top.v

# SPI slave implementation (used by SPI wrapper)
src/spi/spi_slave.v

# Basic adder implementations (dependencies)
src/adders/basic_add.v

# Other adder implementations (for various configurations)
src/adders/carry_look_ahead.v
src/adders/carry_save_tree.v
src/adders/carry_select.v
src/adders/ripple_carry.v

# Adder testbench (contains definitions used by other modules)
src/adders/csa_tb.v

--binary
--timing
--top-module top_tb
--trace-vcd