
module adder_csla_cla(i_a, i_b, i_carry, o_carry, o_summ);
  parameter WIDTH = 32;
  input [WIDTH-1:0] i_a, i_b;
  input i_carry;
  output [WIDTH-1:0] o_summ;
  output o_carry;
  wire [6:0] carry;
  
    four_bit_RCA inst0(i_a[3:0], i_b[3:0], i_carry, carry[0], o_summ[3:0]);
    CSLA_CLA4 inst1(i_a[7:4], i_b[7:4], carry[0], carry[1], o_summ[7:4]);
    CSLA_CLA4 inst2(i_a[11:8], i_b[11:8], carry[1], carry[2], o_summ[11:8]);
    CSLA_CLA4 inst3(i_a[15:12], i_b[15:12], carry[2], carry[3], o_summ[15:12]);
    CSLA_CLA4 inst4(i_a[19:16], i_b[19:16], carry[3], carry[4], o_summ[19:16]);
    CSLA_CLA4 inst5(i_a[23:20], i_b[23:20], carry[4], carry[5], o_summ[23:20]);
    CSLA_CLA4 inst6(i_a[27:24], i_b[27:24], carry[5], carry[6], o_summ[27:24]);
    CSLA_CLA4 inst7(i_a[31:28], i_b[31:28], carry[6], o_carry, o_summ[31:28]);
endmodule

module adder_csla_rca(i_a, i_b, i_carry, o_carry, o_summ);
  parameter WIDTH = 32;
  input [WIDTH-1:0] i_a, i_b;
  input i_carry;
  output [WIDTH-1:0] o_summ;
  output o_carry;
  wire [6:0] carry;
  
    four_bit_RCA inst0(i_a[3:0], i_b[3:0], i_carry, carry[0], o_summ[3:0]);
    CSLA_RCA4 inst1(i_a[7:4], i_b[7:4], carry[0], carry[1], o_summ[7:4]);
    CSLA_RCA4 inst2(i_a[11:8], i_b[11:8], carry[1], carry[2], o_summ[11:8]);
    CSLA_RCA4 inst3(i_a[15:12], i_b[15:12], carry[2], carry[3], o_summ[15:12]);
    CSLA_RCA4 inst4(i_a[19:16], i_b[19:16], carry[3], carry[4], o_summ[19:16]);
    CSLA_RCA4 inst5(i_a[23:20], i_b[23:20], carry[4], carry[5], o_summ[23:20]);
    CSLA_RCA4 inst6(i_a[27:24], i_b[27:24], carry[5], carry[6], o_summ[27:24]);
    CSLA_RCA4 inst7(i_a[31:28], i_b[31:28], carry[6], o_carry, o_summ[31:28]);
endmodule

module CSLA_RCA4(i_a, i_b, i_cin, o_cout, o_sum);
    input [3:0] i_a, i_b;
    input i_cin;
    output [3:0] o_sum;
    output o_cout;
    wire [3:0] s0,s1;
    wire c0,c1;

    four_bit_RCA rca1(i_a, i_b, 1'b0, c0, s0);
    four_bit_RCA rca2(i_a, i_b, 1'b1, c1, s1);   
    assign o_cout = i_cin ? c1 : c0;
    assign o_sum = i_cin ? s1 : s0;
endmodule

module CSLA_CLA4(i_a, i_b, i_cin, o_cout, o_sum);
    input [3:0] i_a, i_b;
    input i_cin;
    output [3:0] o_sum;
    output o_cout;
    wire [3:0] s0,s1;
    wire c0,c1;

    four_bit_CLA cla1(i_a, i_b, 1'b0, c0, s0);
    four_bit_CLA cla2(i_a, i_b, 1'b1, c1, s1);  
    assign o_cout = i_cin ? c1 : c0;
    assign o_sum = i_cin ? s1 : s0;
endmodule