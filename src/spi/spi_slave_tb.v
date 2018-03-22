
`timescale 1ns/1ps
module spi_slave_tb();
      // memory adresses
  parameter PERIOD = 50;
  reg clk, rst_n;
  wire done;
  wire [15:0] data_o;

  reg [15:0] shift, shift_in;

  reg ss, mosi;

  integer i;
  //reg[511:0] M = {24'h616263,1'b1,423'd0,64'd24}; 

  spi_slave spi_ints(.i_rst(rst_n), 
                     .i_ss(ss), 
                     .i_sck(clk), 
                     .i_mosi(mosi), 
                     .i_msb(1'b1),
                     .i_data(16 'h45FA),
                     .o_miso(miso),         //slave out   master in 
                     .o_done(done),
                     .o_data(data_o)
  );
  
  // sha_testing sha256_core_inst(.i_clk(clk),   // Clock
  // 			   				   .i_rst_n(rst_n),  // Asynchronous reset active low
  // 			   				   .i_w_addr(mem_addr),
  // 			   				   .i_data8(data),
  // 			   				   .i_we(mem_we),
  // 			   				   .o_irq(completed),
  // 			   				   .o_data_h(data_o),
  // 			   				   .o_data_w(data_w));

 //  always @(posedge clk) begin
 //    rx_state <= kek_inst.sha256_core_inst.dig.rx_state;
 //    //tx_state <= kek_inst.sha256_core_inst.dig.tx_state;
 //  end
 // assign  calc = rx_state + kek_inst.sha256_core_inst.dig.tx_state;
  initial begin
    clk = 0;
    forever #(PERIOD/2) clk = ~clk;
  end

  //assign 

  initial begin
    rst_n = 0;
    ss = 1;
    shift = 16'h428a;
    shift_in = 8'd0;
    //mem_we = 0;
    //data = 32'd0;
    #50 rst_n = 1;

    #100 ss = 0;
    //#60 mem_we = 1;
    
    for (i = 0; i<16; i=i+1) begin
        @(negedge clk);
        mosi = shift[15];
        shift = {shift[14:0], 1'b1};
        @(posedge clk);
        shift_in = {shift_in[14:0], miso};

    end
    //#PERIOD mem_addr = 66;
    //data = 1;
    //#PERIOD mem_we = 0;

    //data = 32'b0000_0000_0000_0000_0000_0000_1010_1010;
    
        #5000 $stop;
  end


  // `define IDX(x) (((x)+1)*(32)-1):((x)*(32))
  // `define MAJ(x, y, z) ((x & y) | (x & z) | (y & z))
  // `define CH(x, y, z) ((x & y) | (~x & z))
  // `define S0(x) ({x[1:0],x[31:2]} ^ {x[12:0],x[31:13]} ^ {x[21:0],x[31:22]})
  // `define S1(x) ({x[5:0],x[31:6]} ^ {x[10:0],x[31:11]} ^ {x[24:0],x[31:25]})
  // parameter [31:0] KS [0:63] = '{
  //       32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5,
  //       32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
  //       32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3,
  //       32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
  //       32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc,
  //       32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
  //       32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7,
  //       32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
  //       32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13,
  //       32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
  //       32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3,
  //       32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
  //       32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5,
  //       32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
  //       32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208,
  //       32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2};
  // reg [511:0] message = 512'd0; //6b656f6180000000000000000000000_00000000000000000000000000000000_00000000000000000000000000000000_;

  // integer j = 0;
  // reg [31:0] A, B, C, D, E, F, G, H, T1, T2, MAJ, S0, S1, E0, E1, CH, W, K;
  // localparam H_INIT = 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667;


  // initial begin
  // message[511:480] = 32'h33800000;
  // message[31:0] = 32'd1;

  // A =   H_INIT[`IDX(0)];
  // B =   H_INIT[`IDX(1)];
  // C =   H_INIT[`IDX(2)];
  // D =   H_INIT[`IDX(3)];
  // E =   H_INIT[`IDX(4)];
  // F =   H_INIT[`IDX(5)];
  // G =   H_INIT[`IDX(6)];
  // H =   H_INIT[`IDX(7)];

  // #10 MAJ = `MAJ(A, B, C);
  // CH = `CH(E, F, G);
  // S0 = `S0(A);
  // S1 = `S1(E);

  // K = KS[0];
  // W = message[`IDX(15)];

  // T1 = H + S1 + CH + K + W;
  // T2 = S0 + MAJ;

  // // #1 A = T1 + T2;
  // // B = A;
  // // C = B;
  // // D = C;
  // // E = D + T1;
  // // F = E;
  // // G = F;
  // // H = G;

  // #10 H = G;
  // G = F;
  // F = E;
  // E = D + T1;
  // D = C;
  // C = B;
  // B = A;
  // A = T1 + T2;


  // end

endmodule
