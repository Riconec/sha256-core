// add here values for hash block init ????
`define LUT_COEF

`ifdef LATTICE_BRAM_COEF
  module sha256_coefs_clk(
	input [5 : 0] i_coef_num,
  input i_clk,
  output [31 : 0] o_coef_value
  );
  `define COEF_VERS 5
  `ifdef ALTERA_M4K_COEF
    `error_multiple_definitions
  `elsif LUT_COEF
    `error_multiple_definitions
  `endif

SB_RAM256x16 ram256x16_lowpart (
  .RDATA(o_coef_value[15:0]),
  .RADDR({3'd0, i_coef_num}),
  .RCLK(i_clk),
  .RCLKE(1'b1),
  .RE(1'b1),
  .WADDR(8'hFF),
  .WCLK(1'b0),
  .WCLKE(1'b0),
  .WDATA(16'd0),
  .WE(1'b0),
  .MASK(16'hFFFF)
);

defparam ram256x16_lowpart.INIT_0 = 256'hf17406a7b1fe5d747dc385be5b01aa985ed582a411f1c25bdba5fbcf44912f98;
defparam ram256x16_lowpart.INIT_1 = 256'h2967635191470bf37fc727c8c66d515288daa9dc84aa2c6fa1cc9dc6478669c1;
defparam ram256x16_lowpart.INIT_2 = 256'ha07035850624e81951a38b70664be8a12c85c92e0abb73540d136dfc21380a85;
defparam ram256x16_lowpart.INIT_3 = 256'h78f2a3f76cebfffa02087814636f82ee6ff3ca4faa4a0cb3bcb5774c6c08c116;

SB_RAM256x16 ram256x16_hipart (
  .RDATA(o_coef_value[31:16]),
  .RADDR({3'd0, i_coef_num}),
  .RCLK(i_clk),
  .RCLKE(1'b1),
  .RE(1'b1),
  .WADDR(8'hFF),
  .WCLK(1'b0),
  .WCLKE(1'b0),
  .WDATA(16'd0),
  .WE(1'b0),
  .MASK(16'hFFFF)
);

defparam ram256x16_hipart.INIT_0 = 256'hc19b9bdc80de72be550c24311283d807ab1c923f59f13956e9b5b5c07137428a;
defparam ram256x16_hipart.INIT_1 = 256'h142906cad5a7c6e0bf59b003a831983e76f95cb04a742de9240c0fc1efbee49b;
defparam ram256x16_hipart.INIT_2 = 256'h106af40ed699d192c76cc24ba81aa2bf927281c2766a650a53384d2c2e1b27b7;
defparam ram256x16_hipart.INIT_3 = 256'hc671bef9a45090be8cc784c878a5748f682e5b9c4ed8391c34b027481e3719a4;
`endif

`ifdef ALTERA_M4K_COEF
module sha256_coefs_clk(
	input [5 : 0] i_coef_num,
  input i_clk,
  output [31 : 0] o_coef_value
  );
  `define COEF_VERS 10
  `ifdef LATTICE_BRAM_COEF
    `error_multiple_definitions
  `elsif LUT_COEF
    `error_multiple_definitions
  `endif

	reg [32-1:0] rom[2**6-1:0];

	initial	begin
		$readmemb("sha256_coefs.txt", rom);
	end

	always @ (posedge i_clk) begin
		o_coef_value <= rom[i_coef_num];
	end

`endif

`ifdef LUT_COEF
module sha256_coefs_clk(
	input [5 : 0] i_coef_num,
  input i_clk,
  output reg[31 : 0] o_coef_value
  );
  `define COEF_VERS 0
  `ifdef LATTICE_BRAM_COEF
    `error_multiple_definitions
  `endif 
  `ifdef ALTERA_M4K_COEF
    `error_multiple_definitions
  `endif

  always @(posedge i_clk) begin
      case(i_coef_num)
        00: o_coef_value <= 32'h428a2f98;
        01: o_coef_value <= 32'h71374491;
        02: o_coef_value <= 32'hb5c0fbcf;
        03: o_coef_value <= 32'he9b5dba5;
        04: o_coef_value <= 32'h3956c25b;
        05: o_coef_value <= 32'h59f111f1;
        06: o_coef_value <= 32'h923f82a4;
        07: o_coef_value <= 32'hab1c5ed5;
        08: o_coef_value <= 32'hd807aa98;
        09: o_coef_value <= 32'h12835b01;
        10: o_coef_value <= 32'h243185be;
        11: o_coef_value <= 32'h550c7dc3;
        12: o_coef_value <= 32'h72be5d74;
        13: o_coef_value <= 32'h80deb1fe;
        14: o_coef_value <= 32'h9bdc06a7;
        15: o_coef_value <= 32'hc19bf174;
        16: o_coef_value <= 32'he49b69c1;
        17: o_coef_value <= 32'hefbe4786;
        18: o_coef_value <= 32'h0fc19dc6;
        19: o_coef_value <= 32'h240ca1cc;
        20: o_coef_value <= 32'h2de92c6f;
        21: o_coef_value <= 32'h4a7484aa;
        22: o_coef_value <= 32'h5cb0a9dc;
        23: o_coef_value <= 32'h76f988da;
        24: o_coef_value <= 32'h983e5152;
        25: o_coef_value <= 32'ha831c66d;
        26: o_coef_value <= 32'hb00327c8;
        27: o_coef_value <= 32'hbf597fc7;
        28: o_coef_value <= 32'hc6e00bf3;
        29: o_coef_value <= 32'hd5a79147;
        30: o_coef_value <= 32'h06ca6351;
        31: o_coef_value <= 32'h14292967;
        32: o_coef_value <= 32'h27b70a85;
        33: o_coef_value <= 32'h2e1b2138;
        34: o_coef_value <= 32'h4d2c6dfc;
        35: o_coef_value <= 32'h53380d13;
        36: o_coef_value <= 32'h650a7354;
        37: o_coef_value <= 32'h766a0abb;
        38: o_coef_value <= 32'h81c2c92e;
        39: o_coef_value <= 32'h92722c85;
        40: o_coef_value <= 32'ha2bfe8a1;
        41: o_coef_value <= 32'ha81a664b;
        42: o_coef_value <= 32'hc24b8b70;
        43: o_coef_value <= 32'hc76c51a3;
        44: o_coef_value <= 32'hd192e819;
        45: o_coef_value <= 32'hd6990624;
        46: o_coef_value <= 32'hf40e3585;
        47: o_coef_value <= 32'h106aa070;
        48: o_coef_value <= 32'h19a4c116;
        49: o_coef_value <= 32'h1e376c08;
        50: o_coef_value <= 32'h2748774c;
        51: o_coef_value <= 32'h34b0bcb5;
        52: o_coef_value <= 32'h391c0cb3;
        53: o_coef_value <= 32'h4ed8aa4a;
        54: o_coef_value <= 32'h5b9cca4f;
        55: o_coef_value <= 32'h682e6ff3;
        56: o_coef_value <= 32'h748f82ee;
        57: o_coef_value <= 32'h78a5636f;
        58: o_coef_value <= 32'h84c87814;
        59: o_coef_value <= 32'h8cc70208;
        60: o_coef_value <= 32'h90befffa;
        61: o_coef_value <= 32'ha4506ceb;
        62: o_coef_value <= 32'hbef9a3f7;
        63: o_coef_value <= 32'hc67178f2;
      endcase
    end
`endif
endmodule


