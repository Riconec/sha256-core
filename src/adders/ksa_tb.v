`timescale 1ns / 1ps

module ksa_adder_tb;
  parameter PERIOD = 10;
     localparam ADDWIDTH = 8;
  reg [ADDWIDTH-1:0] a, b, golden_sum;
  reg golden_carry, i_carry;
  wire [ADDWIDTH-1:0] sum;
  wire o_carry;
  integer i, j, l, error_cnt;

 
    KSA #(ADDWIDTH) inst_ksa (a,b,i_carry,sum,o_carry); 
                      
initial begin
  a = 0;
  b = 0;
  i_carry = 0;
  error_cnt = 0;
  for (l = 0; l < 2; l = l + 1) begin
    for (i = 0; i < 8'hFF; i = i + 1) begin
      for (j = 0; j < 8'hFF; j = j + 1) begin
        a = i;
        b = j;
        i_carry = l;
        {golden_carry, golden_sum} = a + b + i_carry;
        #10;
      end
    end
  end
  if (error_cnt == 0) $display ("There is no errors in code ;)");
  else $display ("Error counter =%d", error_cnt);
end                      
                      
                      

initial forever begin
  @(a, b) begin
    if ({golden_carry, golden_sum} !== {o_carry, sum}) begin
      error_cnt = error_cnt + 1;
      $display ("This is error # %4d", error_cnt, " at simtime %6d", $time, " Golden =%8d", {golden_carry, golden_sum}, " Simulated=%8d", {o_carry, sum});
      end
  end
end
  
endmodule