/* SPI MODE 3
		CHANGE DATA (o_miso) @NEGEDGE i_sck
		read data (i_mosi) @posedge i_sck
*/
module spi_slave (
  	input i_clk, i_rst_n, i_ss, i_sck_r, i_sck_f, i_mosi, i_msb,
  	input [15:0] i_data,
  	output o_miso,
  	output o_done,
  	output reg [15:0] o_data
  	);

 reg [15:0] r_tx, r_rx;
 reg [3:0] r_cnt;
 wire sout;
  
assign sout = i_msb ? r_tx[15] : r_tx[0];
assign o_miso = (!i_ss) ? sout : 1'bz;
assign o_done = (r_cnt == 4'd15) ? 1'b1 : 1'b0;

always @(posedge i_clk or negedge i_rst_n)
  begin
    if (!i_rst_n) begin	
    	r_rx <= 16'd0;  
    	o_data <= 16'd0;
    	r_cnt <= 0;
    end else begin
    	if (!i_ss & i_sck_r) begin 
			if(!i_msb) begin //LSB first, in@msb -> right shift
				r_rx <= {i_mosi, r_rx[15:1]}; 
			end else begin   //MSB first, in@lsb -> left shift
				r_rx <= {r_rx[14:0], i_mosi}; 
			end
			r_cnt <= r_cnt + 1'b1;
			if (r_cnt == 4'd15) begin
				r_cnt <= 0;
				o_data <= {r_rx[14:0], i_mosi};
			end
		end else if (o_data[15]) begin
			o_data[15] <= 1'b0;
		end
	end
end

always @(posedge i_clk or negedge i_rst_n)
  begin
	if (!i_rst_n) begin
		r_tx <= 16'hffFF;
	end else begin
		if(r_cnt == 0) begin
			r_tx <= i_data;
		end else if(!i_ss & i_sck_f) begin
			if(!i_msb) begin   //LSB first, out=lsb -> right shift
				r_tx <= {1'b1, r_tx[15:1]}; 
			end else begin    //MSB first, out=msb -> left shift
				r_tx <= {r_tx[14:0], 1'b1}; 
			end		
		end
	 end 
  end 
endmodule