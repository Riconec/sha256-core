`timescale 1ns / 1ps

module csa_adder_tb;
  parameter PERIOD = 10;

  reg a, b, c, d, e, f, g, golden_sum, golden_carry;
  wire o_s;
  wire o_c;
  integer i, j, l, error_cnt;

 
    CSA7_2 inst1bit(a, b, c, d, e, f, g,  o_c, o_s);
                      
initial begin
  a = 0;
  b = 0;
  c = 0;
  d = 0;
  e = 0;
  f = 0;
  g = 0;

    #10;

    a = 1;
  b = 0;
  c = 0;
  d = 0;
  e = 0;
  f = 0;
  g = 0;

   #10;

    a = 1;
  b = 1;
  c = 0;
  d = 0;
  e = 0;
  f = 0;
  g = 0;

     #10;

    a = 1;
  b = 1;
  c = 1;
  d = 0;
  e = 0;
  f = 0;
  g = 0;

       #10;

    a = 1;
  b = 1;
  c = 1;
  d = 1;
  e = 0;
  f = 0;
  g = 0;

         #10;

    a = 1;
  b = 1;
  c = 1;
  d = 1;
  e = 1;
  f = 0;
  g = 0;
  error_cnt = 0;
//   for (l = 0; l < 2; l = l + 1) begin
//     for (i = 0; i < 8'hFF; i = i + 1) begin
//       for (j = 0; j < 8'hFF; j = j + 1) begin
//         a = i;
//         b = j;
//         i_carry = l;
//         {golden_carry, golden_sum} = a + b + i_carry;
//         #10;
//       end
//     end
//   end
//   if (error_cnt == 0) $display ("There is no errors in code ;)");
//   else $display ("Error counter =%d", error_cnt);
end                      
                      
                      

// initial forever begin
//   @(a, b) begin
//     if ({golden_carry, golden_sum} !== {o_carry, sum}) begin
//       error_cnt = error_cnt + 1;
//       $display ("This is error # %4d", error_cnt, " at simtime %6d", $time, " Golden =%8d", {golden_carry, golden_sum}, " Simulated=%8d", {o_carry, sum});
//       end
//   end
// end
  
endmodule