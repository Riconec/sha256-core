/* replace by parametrized RCA */
module four_bit_RCA(i_a, i_b, i_carry, o_carry, o_summ);
  input [3:0] i_a, i_b;
  input i_carry;
  output [3:0] o_summ;
  output o_carry;
  wire carry0, carry1, carry2;

  full_adder ints1(i_a[0], i_b[0], i_carry, o_summ[0], carry0);
  full_adder ints2(i_a[1], i_b[1], carry0, o_summ[1], carry1);
  full_adder ints3(i_a[2], i_b[2], carry1, o_summ[2], carry2);
  full_adder ints4(i_a[3], i_b[3], carry2, o_summ[3], o_carry);
endmodule