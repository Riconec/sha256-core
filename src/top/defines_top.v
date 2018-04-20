`ifdef DEFINES_TOP
    //skip
`else
/*--------------------------------------------------*/
    // `define CSATREE
    //`define KSA
    //`define CSLA_CLA
    // `define CSLA_RCA
    // `define RTL_ADD
    // `define ALTERA_PAR
    // `define ALTERA_SNGL

    //`define ROUNDS16
    // `define ROUNDS8
    // `define ROUNDS4
    // `define ROUNDS2
    `define ROUNDS1

/*--------------------------------------------------*/    
    `define IDX32(x) (((x)+1)*(32)-1):((x)*(32))

    `ifdef ROUNDS1
        `define ROUNDO1
        `define ROUND_INC 7'd1
        `define ROUND_END 7'd63
    `else
        `ifdef ROUNDS2
            `define ROUNDS1
            `define ROUNDO2
            `define ROUND_INC 7'd2
            `define ROUND_END 7'd62
        `else
            `ifdef ROUNDS4
                `define ROUNDS2
                `define ROUNDS1
                `define ROUNDO4
                `define ROUND_INC 7'd4
                `define ROUND_END 7'd60
            `else
                `ifdef ROUNDS8
                    `define ROUNDS4
                    `define ROUNDS2
                    `define ROUNDS1
                    `define ROUNDO8
                    `define ROUND_INC 7'd8
                    `define ROUND_END 7'd56
                `else 
                    `ifdef ROUNDS16
                        `define ROUNDS8
                        `define ROUNDS4
                        `define ROUNDS2
                        `define ROUNDS1
                        `define ROUNDO16
                        `define ROUND_INC 7'd16
                        `define ROUND_END 7'd48
                    `endif
                `endif
            `endif
        `endif
    `endif

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