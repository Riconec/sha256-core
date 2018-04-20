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
            if (i == 0) begin
                reduce7to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], i_e[i], i_f[i], i_g[i], 5'd0, o_c[i], carry_int[i], o_s[i]);
            end else if (i != WIDTH-1) begin
                reduce7to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], i_e[i], i_f[i], i_g[i], carry_int[i-1], o_c[i], carry_int[i], o_s[i]);
            end else begin
                reduce7to2_1bit inst(i_a[i], i_b[i], i_c[i], i_d[i], i_e[i], i_f[i], i_g[i], carry_int[i-1], o_c[i], carry_int[i], o_s[i]);
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