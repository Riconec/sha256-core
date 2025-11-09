/* n-bit seven operand Tree Carry Save Adder */
module reduce7to2_nbit(i_a, i_b, i_c, i_d, i_e, i_f, i_g, o_c, o_s);
    parameter WIDTH = 32;
    input [WIDTH-1:0] i_a, i_b, i_c, i_d, i_e, i_f, i_g;
    output [WIDTH-1:0] o_s, o_c;

    wire [WIDTH-1:0] c_int;
    wire [4:0] carry_int [WIDTH-1:0];

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1'b1) begin : gener
            if (i == 0) begin : gen_reduce
                reduce7to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], i_e[i], i_f[i], i_g[i], 5'd0, o_c[i], carry_int[i], o_s[i]);
            end else if (i != WIDTH-1) begin : gen_reduce
                reduce7to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], i_e[i], i_f[i], i_g[i], carry_int[i-1], o_c[i], carry_int[i], o_s[i]);
            end else begin : gen_reduce
                reduce7to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], i_e[i], i_f[i], i_g[i], carry_int[i-1], o_c[i], carry_int[i], o_s[i]);
            end
        end
    endgenerate

endmodule

/* n-bit five operand Tree Carry Save Adder */
module reduce5to2_nbit(i_a, i_b, i_c, i_d, i_e, o_c, o_s);
    parameter WIDTH = 32;
    input [WIDTH-1:0] i_a, i_b, i_c, i_d, i_e;
    output [WIDTH-1:0] o_s, o_c;

    wire [WIDTH-1:0] c_int;
    wire [2:0] carry_int [WIDTH-1:0];

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1'b1) begin : gener
            if (i == 0) begin : gen_reduce
                reduce5to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], i_e[i], 3'd0, o_c[i], carry_int[i], o_s[i]);
            end else if (i != WIDTH-1) begin : gen_reduce
                reduce5to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], i_e[i], carry_int[i-1], o_c[i], carry_int[i], o_s[i]);
            end else begin : gen_reduce
                reduce5to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], i_e[i], carry_int[i-1], o_c[i], carry_int[i], o_s[i]);
            end
        end
    endgenerate

endmodule

/* n-bit four operand Tree Carry Save Adder */
module reduce4to2_nbit(i_a, i_b, i_c, i_d, o_c, o_s);
    parameter WIDTH = 32;
    input [WIDTH-1:0] i_a, i_b, i_c, i_d;
    output [WIDTH-1:0] o_s, o_c;

    wire [WIDTH-1:0] c_int;
    wire [1:0] carry_int [WIDTH-1:0];

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1'b1) begin : gener
            if (i == 0) begin
                reduce4to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], 2'd0, o_c[i], carry_int[i], o_s[i]);
            end else if (i != WIDTH-1) begin : gen_reduce
                reduce4to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], carry_int[i-1], o_c[i], carry_int[i], o_s[i]);
            end else begin : gen_reduce
                reduce4to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], carry_int[i-1], o_c[i], carry_int[i], o_s[i]);
            end
        end
    endgenerate

endmodule

/* 1bit seven operand Tree Carry Save Adder */
module reduce7to2_1bit(i_a, i_b, i_c, i_d, i_e, i_f, i_g, i_ca, o_c, o_ca, o_s);
    input i_a, i_b, i_c, i_d, i_e, i_f, i_g;
    input [4:0] i_ca;
    output o_s;
    output [4:0] o_ca;
    output o_c;

    full_adder inp1(i_b, i_c, i_d, sum_inp1, o_ca[0]);
    full_adder inp2(i_e, i_f, i_g, sum_inp2, o_ca[1]);

    full_adder int1(i_a, sum_inp1, sum_inp2, sum_int1, o_ca[2]);
    full_adder int2(sum_int1, i_ca[0], i_ca[1], sum_int2, o_ca[3]);
    full_adder int3(sum_int2, i_ca[2], i_ca[3], o_s, o_ca[4]);

    /* o_c is already shifted to be passed to CPA\RCA */
    assign o_c = i_ca[4];
endmodule

/* 1bit five operand Tree Carry Save Adder */
module reduce5to2_1bit(i_a, i_b, i_c, i_d, i_e, i_ca, o_c, o_ca, o_s);
    input i_a, i_b, i_c, i_d, i_e;
    input [2:0] i_ca;
    output o_s;
    output [2:0] o_ca;
    output o_c;

    full_adder inp1(i_c, i_d, i_e, sum_inp1, o_ca[0]);
    full_adder inp2(i_a, i_b, sum_inp1, sum_inp2, o_ca[1]);
    full_adder int2(sum_inp2, i_ca[0], i_ca[1], o_s, o_ca[2]);

    /* o_c is already shifted to be passed to CPA\RCA */
    assign o_c = i_ca[2];
endmodule

/* 1bit four operand Tree Carry Save Adder */
module reduce4to2_1bit(i_a, i_b, i_c, i_d, i_ca, o_c, o_ca, o_s);
    input i_a, i_b, i_c, i_d;
    input [1:0] i_ca;
    output o_s;
    output [1:0] o_ca;
    output o_c;

    wire inp_xor_1 = i_a ^ i_b;
    wire inp_xor_2 = i_c ^ i_d;
    wire int_xor_1 = inp_xor_1 ^ inp_xor_2;

    assign o_ca[0] = inp_xor_1 ? i_c : i_a;
    assign o_ca[1] = int_xor_1 ? i_ca[0] : i_d;
    assign o_s = i_ca[0] ^ int_xor_1;
    /* o_c is already shifted to be passed to CPA\RCA */
    assign o_c = i_ca[1];
endmodule
