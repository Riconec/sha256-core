module sha256_coefs(
	input [5 : 0] i_coef_num,
  output reg [31 : 0] o_coef_value
  );
  
  always @* begin
    case(i_coef_num)
      00: o_coef_value = 32'h428a2f98;
      01: o_coef_value = 32'h71374491;
      02: o_coef_value = 32'hb5c0fbcf;
      03: o_coef_value = 32'he9b5dba5;
      04: o_coef_value = 32'h3956c25b;
      05: o_coef_value = 32'h59f111f1;
      06: o_coef_value = 32'h923f82a4;
      07: o_coef_value = 32'hab1c5ed5;
      08: o_coef_value = 32'hd807aa98;
      09: o_coef_value = 32'h12835b01;
      10: o_coef_value = 32'h243185be;
      11: o_coef_value = 32'h550c7dc3;
      12: o_coef_value = 32'h72be5d74;
      13: o_coef_value = 32'h80deb1fe;
      14: o_coef_value = 32'h9bdc06a7;
      15: o_coef_value = 32'hc19bf174;
      16: o_coef_value = 32'he49b69c1;
      17: o_coef_value = 32'hefbe4786;
      18: o_coef_value = 32'h0fc19dc6;
      19: o_coef_value = 32'h240ca1cc;
      20: o_coef_value = 32'h2de92c6f;
      21: o_coef_value = 32'h4a7484aa;
      22: o_coef_value = 32'h5cb0a9dc;
      23: o_coef_value = 32'h76f988da;
      24: o_coef_value = 32'h983e5152;
      25: o_coef_value = 32'ha831c66d;
      26: o_coef_value = 32'hb00327c8;
      27: o_coef_value = 32'hbf597fc7;
      28: o_coef_value = 32'hc6e00bf3;
      29: o_coef_value = 32'hd5a79147;
      30: o_coef_value = 32'h06ca6351;
      31: o_coef_value = 32'h14292967;
      32: o_coef_value = 32'h27b70a85;
      33: o_coef_value = 32'h2e1b2138;
      34: o_coef_value = 32'h4d2c6dfc;
      35: o_coef_value = 32'h53380d13;
      36: o_coef_value = 32'h650a7354;
      37: o_coef_value = 32'h766a0abb;
      38: o_coef_value = 32'h81c2c92e;
      39: o_coef_value = 32'h92722c85;
      40: o_coef_value = 32'ha2bfe8a1;
      41: o_coef_value = 32'ha81a664b;
      42: o_coef_value = 32'hc24b8b70;
      43: o_coef_value = 32'hc76c51a3;
      44: o_coef_value = 32'hd192e819;
      45: o_coef_value = 32'hd6990624;
      46: o_coef_value = 32'hf40e3585;
      47: o_coef_value = 32'h106aa070;
      48: o_coef_value = 32'h19a4c116;
      49: o_coef_value = 32'h1e376c08;
      50: o_coef_value = 32'h2748774c;
      51: o_coef_value = 32'h34b0bcb5;
      52: o_coef_value = 32'h391c0cb3;
      53: o_coef_value = 32'h4ed8aa4a;
      54: o_coef_value = 32'h5b9cca4f;
      55: o_coef_value = 32'h682e6ff3;
      56: o_coef_value = 32'h748f82ee;
      57: o_coef_value = 32'h78a5636f;
      58: o_coef_value = 32'h84c87814;
      59: o_coef_value = 32'h8cc70208;
      60: o_coef_value = 32'h90befffa;
      61: o_coef_value = 32'ha4506ceb;
      62: o_coef_value = 32'hbef9a3f7;
      63: o_coef_value = 32'hc67178f2;
    endcase 
  end
endmodule
