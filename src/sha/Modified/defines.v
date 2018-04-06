`define IDX32(x) (((x)+1)*(32)-1):((x)*(32))
`define IDX8(x) (((x)+1)*(8)-1):((x)*(8))
`define BASE_VERSION 2
`define REVIS_ID 51
//`define MF_PAR_ADD
//`define MF_PAR_ADD
`define LPM_ADD
//`define RC_ADDER
//`define CLA_ADDER
//`define CSLA_ADDER_16
`define MULTIPLE_ROUNDS



`define START_W_MEM_ADDR = 0;
`define END_W_MEM_ADDR = 63;
`define WHO_AM_I = 7'd64;
`define STATUS_REG = 7'd65;
`define REVISION = 7'd66;
`define DAY = 7'd67;
`define MONTH = 7'd68;
`define YEAR = 7'd69;
`define WHO_AM_I_DATA = 7'd7;
`define REVISION_DATA = 8'd51;
`define DAY_DATA = 8'd19;
`define MONTH_DATA = 8'd03;
`define YEAR_DATA = 8'd19;
`define DIGEST_START_ADDR = 70;
`define DIGEST_END_ADDR = 101;