`ifdef DEFINES_TOP
    //skip
`else
    `define DEFINES_TOP
/*--------------------------------------------------*/
    //`define CSATREE
    //`define MIXED_CSA
    //`define KSA
    // `define CSLA_CLA
    // `define CSLA_RCA
    `define RTL_ADD
    //`define ALTERA_PAR
    //`define ALTERA_SNGL
    //`define CLA
    //`define REORDER
    `define ROUND_INC 1
    //`define MULTI_REORDER
    `define ROUND1BYPASS
    //`define USER_MEMORY
/*--------------------------------------------------*/    
    `define IDX32(x) (((x)+1)*(32)-1):((x)*(32))
    `define ROUND_END 64-`ROUND_INC
/*--------------------------------------------------*/

    parameter   [2:0] INIT = 3'b000,
                ROUND = 3'b001,
                MATH = 3'b010,
                BTC_1 = 3'b011,
                BTC_2 = 3'b100;

	parameter START_W_MEM_ADDR = 0;
	parameter END_W_MEM_ADDR = 79;  // Support 80 bytes (0-79 for Bitcoin block header)
	parameter WHO_AM_I = 7'd80;     // Moved to after message memory
	parameter STATUS_REG = 7'd81;
	parameter REVISION = 7'd82;
	parameter DAY = 7'd83;
	parameter MONTH = 7'd84;
	parameter YEAR = 7'd85;
	parameter WHO_AM_I_DATA = 8'h33;
	parameter REVISION_DATA = 8'd33;
	parameter DAY_DATA = 8'd10;
	parameter MONTH_DATA = 8'd11;
	parameter YEAR_DATA = 8'd25;
	parameter DIGEST_START_ADDR = 86;  // Start digest after status registers
	parameter DIGEST_END_ADDR = 117;   // 32 bytes digest (86-117)
    parameter MEM_END = 127;            // Remaining for user memory if needed

	//10 addresses left empty between digest and WHO_AM_I
	parameter HASH_INIT = 256'h6a09e667_bb67ae85_3c6ef372_a54ff53a_510e527f_9b05688c_1f83d9ab_5be0cd19;
    parameter [383:0] PADDED_BLOCK = 384'h80_000000000000000000000000000000000000000000000000000000000000000000000000000000_0000000000000280;
    parameter [255:0] SHA256_PAD = 256'h80_0000000000000000000000000000000000000000000000_0000000000000100;

    parameter [639:0] BTC_TEST = 640'h01000000_81cd02ab7e569e8bcd9317e2fe99f2de44d49ab2b8851ba4a308000000000000_e320b6c2fffc8d750423db8b1eb942ae710e951ed797f7affc8892b0f1fc122b_c7f5d74d_f2b9441a_42a14695;
    //parameter [639:0] BTC_TEST = 640'hdeadbeefdeadbeefdeadbeefdeadbeef_9f2a1c4b7de03e9a8c1fd0b6247ae9d33cb44e6a11d3f582c7b9e04fd9a182b47d61b3ef50ac7d9a13c4f0e692a14be0_33dc881cfa72e015a68c0f9e0db42a7f;
    parameter [255:0] BTC_TEST_RESULT_r1 = 256'hdb480bebf7261212b49532fff2eb9811fbefe36e7dca0801a18552ffa7bfb200;
    parameter [255:0] BTC_TEST_RESULT_r2 = 256'h4bb3e4d8b3e798f91473cf3dde81e843508a362d856b58b14aa63cba18a1a5d8;
    parameter [255:0] BTC_TEST_RESULT = 256'ha4972e32b24e4c7fbaa89cbdcf9494263292a22da3f68d68a864ab2e1b85b085;
	parameter ROUND_INC_DEF = `ROUND_INC;
	parameter ROUND_END_DEF = `ROUND_END;

    parameter STATUS_INIT_VALUE = 8'b1000_0000;
    parameter STATUS_START = 0;
    parameter STATUS_BITCOIN_MODE = 1;
    parameter STATUS_NONCE_SWEEP = 2;
    parameter STATUS_STATE_LO = 3;  // Lower bit of state field in r_status
    parameter STATUS_STATE_HI = 5;  // Upper bit of state field in r_status
    parameter STATUS_SECOND_ROUND = 6;
    parameter STATUS_COMPLETED = 7;

    `ifdef KSA
        `ifdef SIMPLE_ADD
            `error "multiple defs"
        `else
            `define SIMPLE_ADD
        `endif
    `endif

    `ifdef CSLA_CLA
        `ifdef SIMPLE_ADD
            `error "multiple defs"
        `else
            `define SIMPLE_ADD
        `endif
    `endif

    `ifdef CSLA_RCA
        `ifdef SIMPLE_ADD
            `error "multiple defs"
        `else
            `define SIMPLE_ADD
        `endif
    `endif

    `ifdef CLA
        `ifdef SIMPLE_ADD
            `error "multiple defs"
        `else
            `define SIMPLE_ADD
        `endif
    `endif

    `ifdef ALTERA_PAR
        `ifdef ALTERA_ADD
            `error "multiple defs"
        `else
            `define ALTERA_ADD
        `endif
    `endif

    `ifdef ALTERA_SNGL
        `ifdef ALTERA_ADD
            `error "multiple defs"
        `else
            `define SIMPLE_ADD
            `define ALTERA_SNGL_MF
        `endif
    `endif

    `ifdef RTL_ADD
        `ifdef SIMPLE_ADD
            `error "multiple defs"
        `else
        `endif
    `endif

    `ifdef CSATREE
        `ifdef SIMPLE_ADD
        `else
        	`ifdef ALTERA_ADD
           		`error "multiple defs"
        	`else
			`define CSATREE_ADD
		`endif            
        `endif 
    `endif

    `ifdef ALTERA_ADD
        `ifdef SIMPLE_ADD
            `error "multiple defs"
        `else
            `ifdef MODEL_TECH //we are in sim
            
                `define SIMPLE_ADD
                `define RTL_ADD //replace MF for sim
            `else
                `ifdef ALTERA_PAR
                    `define ALTERA_PAR_MF
                `endif
            `endif
        `endif
    `endif

    `ifdef SIMPLE_ADD
    `else
        `ifdef ALTERA_ADD
        `else
            `ifdef CSATREE_ADD
            `else
                `ifdef RTL_ADD
                `else
                //undefined both
                `error "no def"
                `endif
            
            `endif
        `endif
    `endif

`endif
