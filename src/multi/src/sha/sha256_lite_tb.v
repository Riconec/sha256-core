
`timescale 1ns/1ps
module sha256_tb();
      // memory adresses
  parameter PERIOD = 50;
  reg clk, rst_n, mem_we;
  reg [7:0] data, mem_addr;
  wire completed;
  wire [7:0] data_o, data_w;

  integer i;
  reg[511:0] M = {24'h616263,1'b1,423'd0,64'd24}; 
  
  sha256_core sha256_core_inst(.i_clk(clk),   // Clock
  			   				   .i_rst_n(rst_n),  // Asynchronous reset active low
  			   				   .i_w_addr(mem_addr),
  			   				   .i_data8(data),
  			   				   .i_we(mem_we),
  			   				   .o_irq(completed),
  			   				   .o_data_h(data_o),
  			   				   .o_data_w(data_w));

  initial begin
    clk = 0;
    forever #(PERIOD/2) clk = ~clk;
  end

  initial begin
    rst_n = 0;
    mem_we = 0;
    data = 32'd0;
    #40 rst_n = 1;
    #60 mem_we = 1;
    
    for (i = 0; i<64; i=i+1) begin
        #PERIOD mem_addr = i;
        data = M[mem_addr*8 +: 8];
    end
    #PERIOD mem_addr = 66;
    data = 1;
    #PERIOD mem_we = 0;

    //data = 32'b0000_0000_0000_0000_0000_0000_1010_1010;
    
        #5000 $stop;
  end
endmodule