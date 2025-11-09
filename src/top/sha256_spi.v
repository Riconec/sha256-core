/* SPI MODE 3
		CHANGE DATA (o_miso) @ NEGEDGE i_sck
		read data (i_mosi) @posedge i_sck
*/		
module sha256_spi(
	input i_clk,
	input i_sck,
	input i_rst_n,
	input i_ss_n,
	input i_spi_mosi,
	output o_spi_miso,
	output o_irq_done
	);

wire [6:0] mosi_addr_7b;
wire [7:0] mem_out, mosi_data_8b;
wire [15:0] rx_frame, tx_frame;
wire n_read_write, spi_rx_complete, ss_edge, sck_edge_f, sck_edge_r;

reg [2:0] mosi_sync, sck_sync, ss_sync;

always @(posedge i_clk or negedge i_rst_n) begin
	if(!i_rst_n) begin
		ss_sync	<= 3'b111;
		sck_sync <= 3'b111;
		mosi_sync <= 3'd0;
	end else begin
		ss_sync <= {ss_sync[1:0],i_ss_n};
		sck_sync <= {sck_sync[1:0], i_sck};
		mosi_sync <= {mosi_sync[1:0], i_spi_mosi};
	end
end

assign ss_edge = !ss_sync[0] & ss_sync[1];
assign sck_edge_f = !sck_sync[0] & sck_sync[1];
assign sck_edge_r = !sck_sync[1] & sck_sync[0];
assign n_read_write = rx_frame[15];
assign mosi_data_8b = rx_frame[7:0];
assign mosi_addr_7b = rx_frame[14:8];
assign tx_frame = {n_read_write, mosi_addr_7b, mem_out};

//16 bit message 
// 15 bit - R/W
//	14..8 - addr
//	7..0 - data

sha256_core sha256_core_inst	(.i_clk(i_clk),   // Clock
  			   				     .i_rst_n(i_rst_n),  // Asynchronous reset active low
  			   				     .i_w_addr(mosi_addr_7b),  			   				   
  			   				     .i_data8(mosi_data_8b),  			   				   
  			   				     .i_we(n_read_write),  			   				   
  			   				     .o_irq(o_irq_done),  			   				   
  			   				     .o_data_mux(mem_out)
  			   				     );

spi_slave spi_ints				(.i_clk(i_clk),
								 .i_rst_n(i_rst_n),                      
								 .i_ss(i_ss_n),                      
								 .i_sck_r(sck_edge_r),
								 .i_sck_f(sck_edge_f),                      
								 .i_mosi(i_spi_mosi),                      
								 .i_msb(1'b1),                     
								 .i_data(tx_frame),
								 .o_miso(o_spi_miso),                    
								 .o_done(spi_rx_complete),                     
								 .o_data(rx_frame)
								 );

endmodule
