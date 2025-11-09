# Qwen Code Project Context

**Date**: Sunday, November 9, 2025

**Project Directory**: `/mnt/c/Users/Rico/projects/sha256-core`

## Project Overview
This is a hardware design project focused on SHA-256 implementation with various adder architectures. The project includes multiple FPGA vendor-specific implementations and testbenches.

## Directory Structure
```
/mnt/c/Users/Rico/projects/sha256-core/
├───.gitignore
├───readme.md
├───.git/...
├───src/
│   ├───adders/
│   │   ├───basic_add.v
│   │   ├───carry_look_ahead.v
│   │   ├───carry_save_tree.v
│   │   ├───carry_select.v
│   │   └───csa_tb.v
│   │   └───...
│   ├───altera/
│   ├───lattice/
│   ├───sha/
│   ├───spi/
│   └───top/
└───work/
    ├───fine_results.xlsx
    ├───lattice/
    ├───modelsim/
    └───quartus/
```
## TODO
1) Make changes to allow this project synthesized for TinyTapeout
    - For that unnecessary registers for SHA hash operation need to be optimized 
    - Replace SPI interface with 8bit bus interface 
    - Check how many TinyTapeout tiles needed (2, 3 or 4)
2) Check which kind of adder tree is best suited (best speed at selected number of tiles)
3) Add bitcoin compatible data frame storage, feed sha256 with this frame
4) Add FSM that will set nonce field, run sha calculations repeatedly from X to Y nonce value configured (like from nonce 0 to nonce 100)
5) Add a way to verify numbers of zeros in resulting cache (bitcoin block validation)
6) Expand one SHA256 core to multiple in case more tiles used, split nonce range between existing SHA256 cores (or do more that 1 round a clock)

## Key Components
- **Adders**: Various adder implementations (basic, carry-lookahead, carry-save, carry-select)
- **Vendor-specific code**: Altera and Lattice FPGA implementations
- **SHA module**: Core SHA-256 implementation
- **SPI**: Interface components
- **Top level**: Main design hierarchy

## Notes
- This is a hardware (Verilog/VHDL) project targeting FPGA implementations
- Multiple adder architectures are being evaluated for performance
- Work directory contains results and tool-specific files

## Qwen Added Memories
- SHA-256 Core Configuration Options from defines_top.vh:

- `CSATREE`: Carry Save Adder Tree implementation
- `MIXED_CSA`: Mixed Carry Save Adder
- `KSA`: Kogge-Stone Adder
- `CSLA_CLA`: Carry Select Look-Ahead Adder
- `CSLA_RCA`: Carry Select Ripple Carry Adder
- `CLA`: Carry Look-Ahead adder
- `RTL_ADD`: Standard RTL adder (default)
- `ALTERA_PAR`: Altera parallel adder
- `ALTERA_SNGL`: Altera single adder
- `REORDER`: Reordering optimization
- `ROUND_INC`: Round increment (set to 1)
- `MULTI_REORDER`: Multi-reordering
- `ROUND1BYPASS`: Round 1 bypass optimization
- `USER_MEMORY`: User memory space

Key configurations in current design:
- `RTL_ADD`: Using standard RTL adder
- `ROUND_INC 1`: Processing 1 round per cycle
- `ROUND1BYPASS`: Bypass optimization enabled
- `IDX32(x)`: Macro for 32-bit word indexing
- `ROUND_END`: Calculated as 64-ROUND_INC (for 64 rounds)
- Updated SHA-256 core to support 80-byte input for Bitcoin mining:

1. **Storage Optimization**: Changed from separate 640-bit message register + 512-bit words register to single unified 640-bit r_words register
2. **Memory Expansion**: Extended message memory from 64 bytes (addresses 0-63) to 80 bytes (addresses 0-79) for Bitcoin block headers
3. **Register Map**: Updated addressing - WHO_AMI=80, STATUS_REG=81, REVISION=82, MONTH=84, YEAR=85, DIGEST_START=86, DIGEST_END=117
4. **Testbench Fix**: Updated testbench to write start signal to correct STATUS_REG address (81 instead of old address 66)
5. **Interface Change**: Consolidated outputs from o_data_h/o_data_w to single o_data_mux

This design efficiently stores 80-byte input in upper 512 bits of r_words during initialization, leaving lower 128 bits available for padding data needed in Bitcoin double SHA-256 calculations, while maintaining full SHA-256 functionality.
