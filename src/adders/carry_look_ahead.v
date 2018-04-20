module CLA_nbit(i_a, i_b, i_carry, o_carry, o_summ);
  parameter WIDTH = 32;
  input [WIDTH-1:0] i_a, i_b;
  input i_carry;
  output [WIDTH-1:0] o_summ;
  output o_carry;
  
  wire [WIDTH-2:0] carry;
  wire [WIDTH:0]     w_C;
  wire [WIDTH-1:0]   w_G, w_P, w_SUM;

  genvar             ii;
  generate
    for (ii=0; ii<WIDTH; ii=ii+1)
      begin  :gen1
        full_adder full_adder_inst(i_a[ii],i_b[ii], w_C[ii], w_SUM[ii]);
      end
  endgenerate
 
  genvar             jj;
  generate
    for (jj=0; jj<WIDTH; jj=jj+1)
      begin :gen2
        assign w_G[jj]   = i_a[jj] & i_b[jj];
        assign w_P[jj]   = i_a[jj] | i_b[jj];
        assign w_C[jj+1] = w_G[jj] | (w_P[jj] & w_C[jj]);
      end
  endgenerate
   
  assign w_C[0] = i_carry; 
  assign o_carry = w_C[WIDTH];
  assign o_summ = w_SUM;   
 
endmodule 