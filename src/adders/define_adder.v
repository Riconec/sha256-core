`include <../top/defines_top.vh>
module adder_32b_param(i_a, i_b, i_carry, o_carry, o_summ);
    parameter WIDTH = 32;
    input [WIDTH-1:0] i_a, i_b;
    input i_carry;
    output [WIDTH-1:0] o_summ;
    output o_carry;

    `ifdef CSLA_CLA
        adder_csla_cla inst_csla(i_a, i_b, i_carry, o_carry, o_summ);
    `endif

    `ifdef CSLA_RCA
        adder_csla_rca inst_csla(i_a, i_b, i_carry, o_carry, o_summ);
    `endif

    `ifdef RTL_ADD
        assign {o_carry, o_summ} = i_a + i_b + i_carry;
    `endif

    `ifdef CLA
        CLA_nbit inst_cla(i_a, i_b, i_carry, o_carry, o_summ);
    `endif

    `ifdef KSA
        KSA #(32) inst_ksa(i_a, i_b, i_carry, o_summ, o_carry);
    `endif

    `ifdef ALTERA_SNGL_MF
        adder_lpm_add	adder_lpm_add_inst (
                                            .dataa(i_a),
                                            .datab(i_b),
                                            .result(o_summ),
                                            .cin(1'b0),
                                            .cout(o_carry)
                                            );
    `endif
endmodule