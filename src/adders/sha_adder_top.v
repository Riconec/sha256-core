`include <../top/defines_top.vh>
module sha_adder(i_kt, i_ch, i_sum1, i_sum0, i_sigm1, i_sigm0, i_maj, i_d, i_h, i_words, o_d, o_a, o_word);
    input [31:0] i_kt;
    input [31:0] i_ch;
    input [31:0] i_sum1;
    input [31:0] i_sum0;
    input [31:0] i_sigm1;
    input [31:0] i_sigm0;
    input [31:0] i_maj;
    input [31:0] i_d;
    input [31:0] i_h;
    input [511:0] i_words;
    output [31:0] o_d;
    output [31:0] o_a;
    output [31:0] o_word;

    `ifdef SIMPLE_ADD

        wire carryo1, carryo2, carryo3, carryo4, carryo5, carryo6, carryo8, carryo9, carryo10, carryo11, carryo12;
        wire [31:0] adder_wire_kt_ch, adder_wire_sum_wt, adder_wire_d_h, adder_wire_sum_wt_kt_ch, adder_wire_word_1, adder_wire_word_2, addw_sum_wt_kt_ch_h, addw_maj_sum0;

        adder_32b_param st1_kt_ch (i_kt, i_ch, 1'b0, carryo1, adder_wire_kt_ch);
        adder_32b_param st1_sum_wt (i_sum1, i_words[`IDX32(15)], 1'b0, carryo2, adder_wire_sum_wt);
        adder_32b_param st1_d_h (i_d, i_h, 1'b0, carryo3, adder_wire_d_h);

        adder_32b_param st2_sum_wt_kt_ch (adder_wire_kt_ch, adder_wire_sum_wt, 1'b0, carryo4, adder_wire_sum_wt_kt_ch);
        adder_32b_param st2_all (adder_wire_sum_wt_kt_ch, adder_wire_d_h, 1'b0, carryo5, o_d);

        adder_32b_param st2_a (adder_wire_sum_wt_kt_ch, i_h, 1'b0, carryo6, addw_sum_wt_kt_ch_h);

        adder_32b_param st2_maj_sum0 (i_maj, i_sum0, 1'b0, carryo11, addw_maj_sum0);
        adder_32b_param st2_alla(addw_maj_sum0, addw_sum_wt_kt_ch_h, 1'b0, carryo12, o_a);

        adder_32b_param inst_word_sigm1_rx_word (i_sigm1, i_words[`IDX32(6)], 1'b0, carryo8, adder_wire_word_1);
        adder_32b_param inst_word_prev_sigm0 (adder_wire_word_1, i_sigm0, 1'b0, carryo9, adder_wire_word_2);
        adder_32b_param inst_word_prev_words (adder_wire_word_2, i_words[`IDX32(15)], 1'b0, carryo10, o_word);	

    `endif

    `ifdef RTL_ADD
        assign o_a = i_h + i_sum1 + i_ch + i_kt + i_words[`IDX32(15)] + i_sum0 + i_maj;
        assign o_d = i_h + i_sum1 + i_ch + i_kt + i_words[`IDX32(15)] + i_d;
        assign o_word = i_sigm1+ i_words[`IDX32(6)]+ i_sigm0+ i_words[`IDX32(15)];
    `endif

    `ifdef CSATREE_ADD
        wire [31:0] o_cn1, o_cn2, o_cn3, o_sn1, o_sn2, o_sn3;
        `ifdef MIXED_CSA
        
            reduce5to2_nbit #(32) inst1(i_h, i_sum1, i_ch, i_kt, i_words[`IDX32(15)], o_cn1, o_sn1);
            reduce4to2_nbit #(32) inst3(i_sigm1, i_words[`IDX32(6)], i_sigm0, i_words[`IDX32(15)], o_cn3, o_sn3);
            assign o_a = o_cn1 + o_sn1 + i_sum0 + i_maj;
            assign o_d = o_cn1 + o_sn1 + i_d;
            assign o_word = o_cn3 + o_sn3;

        `else
            reduce7to2_nbit #(32) inst1(i_h, i_sum1, i_ch, i_kt, i_words[`IDX32(15)], i_d, 32'd0, o_cn2, o_sn2);
            reduce7to2_nbit #(32) inst2(i_h, i_sum1, i_ch, i_kt, i_words[`IDX32(15)], i_sum0, i_maj, o_cn1, o_sn1);
            reduce7to2_nbit #(32) inst3(i_sigm1, i_words[`IDX32(6)], i_sigm0, i_words[`IDX32(15)], 32'd0, 32'd0, 32'd0, o_cn3, o_sn3);

            assign o_a = o_cn2 + o_sn2;
            assign o_d = o_cn1 + o_sn1;
            assign o_word = o_cn3 + o_sn3;
        `endif
    `endif

    `ifdef ALTERA_PAR_MF
        par_add_6	par_add_6_inst (
                                    .data0x (i_kt),
                                    .data1x (i_ch),
                                    .data2x (i_sum1),
                                    .data3x (i_words[`IDX32(15)]),
                                    .data4x (i_h),
                                    .data5x (i_d),
                                    .result (o_d)
                                    );

        par_add_7	par_add_7_inst (
                                    .data0x (i_kt),
                                    .data1x (i_ch),
                                    .data2x (i_sum1),
                                    .data3x (i_words[`IDX32(15)]),
                                    .data4x (i_h),
                                    .data5x (i_maj),
                                    .data6x (i_sigm0),
                                    .result (o_a)
                                    );

        par_add_4	par_add_4_inst (
                                    .data0x (i_sigm1),
                                    .data1x (i_words[`IDX32(6)]),
                                    .data2x (i_sigm0),
                                    .data3x (i_words[`IDX32(15)]),
                                    .result (o_word)
                                    );
    `endif

endmodule