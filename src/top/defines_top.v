`ifdef DEFINES_TOP
    //skip
`else
/*--------------------------------------------------*/
    // `define CSATREE
    //`define KSA
    //`define CSLA_CLA
    // `define CSLA_RCA
    `define RTL_ADD
    // `define ALTERA_PAR
    // `define ALTERA_SNGL

    `define ROUND_INC 1
    `define ROUND_END 64-ROUND_INC

/*--------------------------------------------------*/    
    `define IDX32(x) (((x)+1)*(32)-1):((x)*(32))
/*--------------------------------------------------*/
    `define DEFINES_TOP

    `ifdef ALTERA_PAR
        `ifdef ALTERA_ADD
            `error multiple defs
        `else
            `define ALTERA_ADD
        `endif
    `endif

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

    `ifdef RTL_ADD
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
            //undefined both
                `error no defs
            `endif
        `endif
    `endif

`endif