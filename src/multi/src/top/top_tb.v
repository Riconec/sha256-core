`timescale 1ns/1ps
module top_tb();
      // memory adresses
  parameter PERIOD = 50;
    parameter PERIOD_SPI = 500;
  reg clk, rst_n, ss, mem_we, sck;
  wire done;
  wire [15:0] data_o;
  wire [255:0] digest;
  reg [7:0] tmp, byte_out;
  reg [15:0] shift, shift_in;

  reg  mosi;

  integer i,j,k;
  reg[511:0] M = {24'h616263,1'b1,423'd0,64'd24};

  reg [255:0] golden_hash = 256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad;

  wire win = (golden_hash == digest);
  
   sha256_spi spi_hash(
                    .i_clk(clk),
                    .i_sck(sck),
                    .i_rst_n(rst_n),
                    .i_ss_n(ss),
                    .i_spi_mosi(mosi),
                    .o_spi_miso(miso),
                    .o_irq_done(done)
  );
  
  initial begin
    clk = 0;
    forever #(PERIOD/2) clk = ~clk;
  end

  initial begin
    rst_n = 0;
    ss = 1;
    sck = 1;
    #250 rst_n = 1;
    #(PERIOD*2);

    // fork 
    //   gen_sck;
    //   read_byte(64);
    // join

    for (k=0; k<64; k=k+1) begin
      fork
      gen_sck;
      tmp = M[k*8 +: 8];
      write_byte(1,k[6:0],tmp);
      $display("write[%d] = %h", k, tmp);
      join
      #(PERIOD_SPI*2);
    end
    #(PERIOD_SPI*2);

    fork
    gen_sck;
    write_byte(1,65,1);
    join
    #(PERIOD_SPI*2);

    for (k=0; k<32; k=k+1) begin
      fork
      gen_sck;
      //tmp = M[k*8 +: 8];
      //write_byte(1,k[6:0],tmp);
      read_byte(k+70);
      //$display("read[%d] = %h", k, tmp);
      join
      #(PERIOD_SPI*2);
    end
    #(PERIOD_SPI*2);

    #5000 $stop;
  end

task read_byte;
    input [6:0] read_addr;
    reg [7:0] byte_out;
    reg [15:0] shift_rx;
    begin
      shift_rx = 16'hffff;
      write_byte(1'b0, read_addr, 8'd0);
      #500;
      ss = 0;
      gen_sck;
      for (i = 0; i<16; i=i+1) begin
        @(posedge sck);
        shift_rx = {shift_rx[14:0], miso};
      end
      #100 ss = 1;
      byte_out = shift_rx[7:0];
    $display("REG[%d] = %h", read_addr, byte_out);
    end
    
    endtask


task write_byte;
    input n_r_w;
    input [6:0] write_addr;
    input [7:0] data;
    reg [15:0] shift_tx;
    begin
      shift_tx = 16'h0000;
      ss = 0;
      shift_tx = {n_r_w,write_addr,data};
      for (i = 0; i < 16; i=i+1) begin
        @(negedge sck);
        mosi = shift_tx[15];
        shift_tx = {shift_tx[14:0], 1'b1};
      end
      @(posedge sck);
      #100; ss = 1;
    end
    endtask

  task gen_sck;
    begin
      #100;
      for (j = 0; j<32; j=j+1) begin
        #(PERIOD_SPI/2) sck = ~sck;
      end
    end
  endtask
endmodule