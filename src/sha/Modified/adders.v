module adder_32b_param(i_a, i_b, i_carry, o_carry, o_summ);
  parameter WIDTH = 32;
  input [WIDTH-1:0] i_a, i_b;
  input i_carry;
  output [WIDTH-1:0] o_summ;
  output o_carry;
  wire [WIDTH-2:0] carry;
  wire [WIDTH-1:0] inv_b;
  wire b_inv, b_o_inv;
	
//`define MF_PAR_ADD
`define LPM_ADD
//`define RC_ADDER
//`define CLA_ADDER
//`define CSLA_ADDER_16

`ifdef LPM_ADD
  adder_lpm_add	adder_lpm_add_inst (
	.dataa ( i_a ),
	.datab ( i_b ),
	.result ( o_summ )
	);
  assign o_carry = 1'b0;
  endmodule
`endif


`ifdef RC_ADDER
  `define ADD_VERSION 0
  `ifdef CLA_ADDER
    `error_multiple_adder_definitions
  `elsif CSLA_ADDER_16
    `error_multiple_adder_definitions
  `endif
  
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
  `define ADD_VERSION 0
  `ifdef CSLA_ADDER_16
    `error_multiple_adder_definitions
  `elsif RC_ADDER
    `error_multiple_adder_definitions
  `endif

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
  `define ADD_VERSION 20
  `ifdef CLA_ADDER
    `error_multiple_adder_definitions
  `elsif RC_ADDER
    `error_multiple_adder_definitions
  `endif

  wire csla_16_carry;
	//carry_select_adder_16bit(a, b, cin, sum, cout);
  carry_select_adder_16bit inst_csla_16_l (.a(i_a[15:0]), .b(i_b[15:0]), .cin(1'b0), .sum(o_summ[15:0]), .cout(csla_16_carry));
  carry_select_adder_16bit inst_csla_16_h (.a(i_a[31:16]), .b(i_b[31:16]), .cin(csla_16_carry), .sum(o_summ[31:16]), .cout(outcarry1));
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


