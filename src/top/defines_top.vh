`ifdef DEFINES_TOP
    //skip
`else
    `define DEFINES_TOP
/*--------------------------------------------------*/
    `define CSATREE
    `define MIXED_CSA
    //`define KSA
    // `define CSLA_CLA
    // `define CSLA_RCA
    //`define RTL_ADD
    //`define ALTERA_PAR
    //`define ALTERA_SNGL
    //`define CLA

    `define ROUND_INC 1
    `define ROUND1BYPASS
    //`define USER_MEMORY
/*--------------------------------------------------*/    
    `define IDX32(x) (((x)+1)*(32)-1):((x)*(32))
    `define ROUND_END 64-`ROUND_INC
/*--------------------------------------------------*/
    
    `ifdef KSA
        `ifdef SIMPLE_ADD
            `error multiple defs
        `else
            `define SIMPLE_ADD
        `endif
    `endif

    `ifdef CSLA_CLA
        `ifdef SIMPLE_ADD
            `error multiple defs
        `else
            `define SIMPLE_ADD
        `endif
    `endif

    `ifdef CSLA_RCA
        `ifdef SIMPLE_ADD
            `error multiple defs
        `else
            `define SIMPLE_ADD
        `endif
    `endif

    `ifdef CLA
        `ifdef SIMPLE_ADD
            `error multiple defs
        `else
            `define SIMPLE_ADD
        `endif
    `endif

    `ifdef ALTERA_PAR
        `ifdef ALTERA_ADD
            `error multiple defs
        `else
            `define ALTERA_ADD
        `endif
    `endif

    `ifdef ALTERA_SNGL
        `ifdef ALTERA_ADD
            `error multiple defs
        `else
            `define SIMPLE_ADD
            `define ALTERA_SNGL_MF
        `endif
    `endif

    `ifdef RTL_ADD
        `ifdef SIMPLE_ADD
            `error multiple defs
        `else
        `endif
    `endif

    `ifdef CSATREE
        `ifdef SIMPLE_ADD
            `error multiple defs
        `else
        	`ifdef ALTERA_ADD
            		`error multiple defs
        	`else
			`define CSATREE_ADD
		`endif            
        `endif 
    `endif

    `ifdef ALTERA_ADD
        `ifdef SIMPLE_ADD
            `error multiple defs
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
                `error no def
                `endif
            
            `endif
        `endif
    `endif

`endif