`define IDX32(x) (((x)+1)*(32)-1):((x)*(32))
`define PARAM_ADD
//`define PAR_ADD_MF
//`define LPM_ADD
//`define RC_ADDER
//`define CLA_ADDER
`define CSLA_ADDER_16
//`define RTL_ADD


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

`ifdef PARAM_ADD
	wire carryo1, carryo2, carryo3, carryo4, carryo5, carryo6, carryo7, carryo8, carryo9, carryo10, carryo11, carryo12;
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
	endmodule
`endif

`ifdef PAR_ADD_MF
  `ifdef MODEL_TECH

	assign o_d = i_kt + i_ch + i_sum1 + i_words[`IDX32(15)] + i_h + i_d;
	assign o_a = i_kt + i_ch + i_sum1 + i_words[`IDX32(15)] + i_h + i_maj + i_sum0;
	assign new_word = i_sigm1 + i_words[`IDX32(6)] + i_sigm0 + i_words[`IDX32(15)];
`else
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
`endif

`ifdef RTL_ADD
    assign o_d = i_kt + i_ch + i_sum1 + i_words[`IDX32(15)] + i_h + i_d;
    assign o_a = i_kt + i_ch + i_sum1 + i_words[`IDX32(15)] + i_h + i_maj + i_sum0;
    assign o_word = i_sigm1 + i_words[`IDX32(6)] + i_sigm0 + i_words[`IDX32(15)];
    endmodule
`endif



	

`ifdef LPM_ADD
module adder_32b_param(i_a, i_b, i_carry, o_carry, o_summ);

  parameter WIDTH = 32;
  input [WIDTH-1:0] i_a, i_b;
  input i_carry;
  output [WIDTH-1:0] o_summ;
  output o_carry;
  wire [WIDTH-2:0] carry;
  wire [WIDTH-1:0] inv_b;
  wire b_inv, b_o_inv;

  adder_lpm_add	adder_lpm_add_inst (
	.dataa ( i_a ),
	.datab ( i_b ),
	.result ( o_summ )
	);
  assign o_carry = 1'b0;
  endmodule
`endif


`ifdef RC_ADDER
module adder_32b_param(i_a, i_b, i_carry, o_carry, o_summ);

  parameter WIDTH = 32;
  input [WIDTH-1:0] i_a, i_b;
  input i_carry;
  output [WIDTH-1:0] o_summ;
  output o_carry;
  wire [WIDTH-2:0] carry;
  wire [WIDTH-1:0] inv_b;
  wire b_inv, b_o_inv;
  // genetating ripple carry adder
  genvar i;

  generate
    for (i = 0; i < WIDTH; i = i + 1) begin :RCA
      if (i == 0)
        full_adder ints1(i_a[i], i_b[i], i_carry, o_summ[i], carry[i]);
      else if (i == WIDTH-1)
        full_adder ints1(i_a[i], i_b[i], carry[i-1], o_summ[i], o_carry);
      else 
        full_adder ints1(i_a[i], i_b[i], carry[i-1], o_summ[i], carry[i]);
    end
  endgenerate
endmodule
`endif

`ifdef CLA_ADDER
module adder_32b_param(i_a, i_b, i_carry, o_carry, o_summ);

  parameter WIDTH = 32;
  input [WIDTH-1:0] i_a, i_b;
  input i_carry;
  output [WIDTH-1:0] o_summ;
  output o_carry;
  wire [WIDTH-2:0] carry;
  wire [WIDTH-1:0] inv_b;
  wire b_inv, b_o_inv;

  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;
 //full_adder(i_a, i_b, i_carry, o_sum, o_carry);
  // Create the Full Adders
  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1)
      begin  :gen1
        full_adder full_adder_inst(i_a[ii],i_b[ii], w_C[ii], w_SUM[ii]);
      end
  endgenerate
 
  // Create the Generate (G) Terms:  Gi=Ai*Bi
  // Create the Propagate Terms: Pi=Ai+Bi
  // Create the Carry Terms:
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1)
      begin :gen2
        assign w_G[jj]   = i_a[jj] & i_b[jj];
        assign w_P[jj]   = i_a[jj] | i_b[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = 1'b0; // no carry input on first adder
  assign o_carry = w_C[WIDTH];
  assign o_summ = w_SUM;   // Verilog Concatenation
 
endmodule // carry_lookahead_adder
`endif

`ifdef CSLA_ADDER_16
module adder_32b_param(i_a, i_b, i_carry, o_carry, o_summ);

  parameter WIDTH = 32;
  input [WIDTH-1:0] i_a, i_b;
  input i_carry;
  output [WIDTH-1:0] o_summ;
  output o_carry;
  carry_select_adder_32bit inst_csla_16_l (.a(i_a), 
                                           .b(i_b), 
                                           .cin(1'b0), 
                                           .sum(o_summ), 
                                           .cout(o_carry)
                                           );

  // carry_select_adder_16bit inst_csla_16_h (.a(i_a[31:16]), 
  //                                          .b(i_b[31:16]), 
  //                                          .cin(csla_16_carry), 
  //                                          .sum(o_summ[31:16]), 
  //                                          .cout(outcarry1)
  //                                          );
endmodule
`endif

//////////////////////////////////////
//4-bit Carry Select Adder Slice
//////////////////////////////////////
 
module carry_select_adder_4bit_slice(a, b, cin, sum, cout);
  input [3:0] a,b;
  input cin;
  output [3:0] sum;
  output cout;
  
  wire [3:0] s0,s1;
  wire c0,c1;

  ripple_carry_4_bit rca1(
                          .a(a[3:0]),
                          .b(b[3:0]),
                          .cin(1'b0),
                          .sum(s0[3:0]),
                          .cout(c0)
                          );
  
  ripple_carry_4_bit rca2(
                          .a(a[3:0]),
                          .b(b[3:0]),
                          .cin(1'b1),
                          .sum(s1[3:0]),
                          .cout(c1)
                          );
  
  mux2X1 #(4) ms0(
                  .in0(s0[3:0]),
                  .in1(s1[3:0]),
                  .sel(cin),
                  .out(sum[3:0])
                  );
  
  mux2X1 #(1) mc0(
                  .in0(c0),
                  .in1(c1),
                  .sel(cin),
                  .out(cout)
                  );

endmodule
  
/////////////////////
//2X1 Mux
/////////////////////
 
module mux2X1(in0, in1, sel, out);
  parameter WIDTH=16; 
  input [WIDTH-1:0] in0, in1;
  input sel;
  output [WIDTH-1:0] out;
  assign out = (sel) ? in1 : in0;
endmodule
 
/////////////////////////////////
//4-bit Ripple Carry Adder
/////////////////////////////////
module ripple_carry_4_bit(a, b, cin, sum, cout);
  input [3:0] a,b;
  input cin;
  output [3:0] sum;
  output cout;
 
  wire c1,c2,c3;
  full_adder fa0(
                a[0],
                b[0],
                cin,
                sum[0],
                c1
                );
  
  
  
  full_adder fa1(
                a[1],
                b[1],
                c1,
                sum[1],
                c2
                );
  
  full_adder fa2(
                a[2],
                b[2],
                c2,
                sum[2],
                c3
                );
  
  full_adder fa3(
                a[3],
                b[3],
                c3,
                sum[3],
                cout
                );

  endmodule

module carry_select_adder_16bit(a, b, cin, sum, cout);
  input [15:0] a,b;
  input cin;
  output [15:0] sum;
  output cout;
  
  wire [2:0] c;
  
  ripple_carry_4_bit rca1(
  .a(a[3:0]),
  .b(b[3:0]),
  .cin(cin),
  .sum(sum[3:0]),
  .cout(c[0]));
  
  // first 4-bit by ripple_carry_adder
  carry_select_adder_4bit_slice csa_slice1(
  .a(a[7:4]),
  .b(b[7:4]),
  .cin(c[0]),
  .sum(sum[7:4]),
  .cout(c[1]));
  
  carry_select_adder_4bit_slice csa_slice2(
  .a(a[11:8]),
  .b(b[11:8]),
  .cin(c[1]),
  .sum(sum[11:8]), 
  .cout(c[2]));
  
  carry_select_adder_4bit_slice csa_slice3(
  .a(a[15:12]),
  .b(b[15:12]),
  .cin(c[2]),
  .sum(sum[15:12]),
  .cout(cout));
endmodule

module carry_select_adder_32bit(a, b, cin, sum, cout);
  input [31:0] a,b;
  input cin;
  output [31:0] sum;
  output cout;
  
  wire [6:0] c;
  
  ripple_carry_4_bit rca1(
  .a(a[3:0]),
  .b(b[3:0]),
  .cin(cin),
  .sum(sum[3:0]),
  .cout(c[0]));
  
  // first 4-bit by ripple_carry_adder
  carry_select_adder_4bit_slice csa_slice1(
  .a(a[7:4]),
  .b(b[7:4]),
  .cin(c[0]),
  .sum(sum[7:4]),
  .cout(c[1]));
  
  carry_select_adder_4bit_slice csa_slice2(
  .a(a[11:8]),
  .b(b[11:8]),
  .cin(c[1]),
  .sum(sum[11:8]), 
  .cout(c[2]));  
  carry_select_adder_4bit_slice csa_slice3(
  .a(a[15:12]),
  .b(b[15:12]),
  .cin(c[2]),
  .sum(sum[15:12]),
  .cout(c[3]));
  carry_select_adder_4bit_slice csa_slice4(
  .a(a[19:16]),
  .b(b[19:16]),
  .cin(c[3]),
  .sum(sum[19:16]),
  .cout(c[4]));
  
  carry_select_adder_4bit_slice csa_slice5(
  .a(a[23:20]),
  .b(b[23:20]),
  .cin(c[4]),
  .sum(sum[23:20]), 
  .cout(c[5]));
  
  carry_select_adder_4bit_slice csa_slice6(
  .a(a[27:24]),
  .b(b[27:24]),
  .cin(c[5]),
  .sum(sum[27:24]),
  .cout(c[6]));

  carry_select_adder_4bit_slice csa_slice7(
  .a(a[31:28]),
  .b(b[31:28]),
  .cin(c[6]),
  .sum(sum[31:28]),
  .cout(cout));

endmodule


module full_adder(i_a, i_b, i_carry, o_sum, o_carry);
  input i_a, i_b, i_carry;
  output o_sum, o_carry;
  wire sum1, carry1, carry2;
  
  half_adder inst1(i_a, i_b, sum1, carry1);
  half_adder inst2(sum1, i_carry, o_sum, carry2);
  or inst3(o_carry, carry1, carry2);
 
endmodule

module half_adder(i_a, i_b, o_sum, o_carry);
  input i_a, i_b;
  output o_sum, o_carry;
  
  and inst1(o_carry, i_a, i_b);
  xor inst2(o_sum, i_a, i_b);  
  
endmodule

