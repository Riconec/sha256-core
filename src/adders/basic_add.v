/* Half and full adders */

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