
module adder_32b_param(i_a, i_b, i_carry, o_carry, o_summ);

 `define LPM_ADD

  parameter WIDTH = 32;
  input [WIDTH-1:0] i_a, i_b;
  input i_carry;
  output [WIDTH-1:0] o_summ;
  output o_carry;
  wire [WIDTH-2:0] carry;
  wire [WIDTH-1:0] inv_b;
  wire b_inv, b_o_inv;
	

`ifdef LPM_ADD
  adder_lpm_add	adder_lpm_add_inst (
	.dataa ( i_a ),
	.datab ( i_b ),
	.result ( o_summ )
	);
  assign o_carry = 1'b0;
  endmodule
`endif
