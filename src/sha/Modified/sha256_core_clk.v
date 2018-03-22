`define IDX32(x) (((x)+1)*(32)-1):((x)*(32))
`define IDX8(x) (((x)+1)*(8)-1):((x)*(8))

module sha256_core(
	input i_clk,    // Clock
	input i_rst_n,  // Asynchronous reset active low
	input [6:0] i_w_addr,
	input [7:0]	i_data8,
	input i_we,
	output o_irq,
	output reg [7:0] o_data_mux
);

	`define BASE_VERSION 2
	`define REVIS_ID 51
	//`define MF_PAR_ADD

	localparam START_W_MEM_ADDR = 0;
	localparam END_W_MEM_ADDR = 63;
	localparam WHO_AM_I = 7'd64;
	localparam STATUS_REG = 7'd65;
	localparam REVISION = 7'd66;
	localparam DAY = 7'd67;
	localparam MONTH = 7'd68;
	localparam YEAR = 7'd69;
	localparam WHO_AM_I_DATA = 7'd7;
	localparam REVISION_DATA = 8'd51;
	localparam DAY_DATA = 8'd19;
	localparam MONTH_DATA = 8'd03;
	localparam YEAR_DATA = 8'd19;
	localparam DIGEST_START_ADDR = 70;
	localparam DIGEST_END_ADDR = 101;
	//16 addresses left empty
	localparam HASH_INIT = 256'h6a09e667_bb67ae85_3c6ef372_a54ff53a_510e527f_9b05688c_1f83d9ab_5be0cd19;

	// FSM states
    parameter   INIT = 2'd0,
                ROUND = 2'd1,
                MATH = 2'd2,
                OUT = 2'd3;

	reg [255:0] r_variables; //a, b, c, d, e, f, g, h 
	reg [511:0] r_words; //W0, W1, W2 ... W15 in terms of FIPS
	reg [5:0] r_round, r_coef;
	reg [7:0] r_status; //r_status = {4'd0, completed, run, ready, start}
	reg [1:0] r_state;
	reg completed, run_signal, do_math;

	//assign o_digest = r_variables;
	//assign o_data_w = r_words[i_w_addr-DIGEST_START_ADDR * 8 +: 8];
	
	//variables indexing
	wire [31:0] var_a = r_variables[`IDX32(7)]; //a
	wire [31:0] var_b = r_variables[`IDX32(6)];	//b
	wire [31:0] var_c = r_variables[`IDX32(5)]; //c
	wire [31:0] var_d = r_variables[`IDX32(4)]; //d
	wire [31:0] var_e = r_variables[`IDX32(3)]; //e <- highest delay here
	wire [31:0] var_f = r_variables[`IDX32(2)]; //f
	wire [31:0] var_g = r_variables[`IDX32(1)]; //g
	wire [31:0] var_h = r_variables[`IDX32(0)]; //h
	wire [31:0] sum0_out, sum1_out, sigm0_out, sigm1_out, ch_out, maj_out, Kt_out;
	wire [31:0] adder_wire_t1_1, adder_wire_t1_2, adder_wire_t1_3, t1, t2, adder_wire_word_1, adder_wire_word_2, new_word, new_a, new_d;
	wire [7:0] o_data_w, o_data_h;

	assign o_irq = completed;
	assign o_data_h = r_variables[(i_w_addr-DIGEST_START_ADDR) * 8 +: 8]; //????
	//math with adders here, the most area cost also
	// wire [31:0] t1 = var_h + sum1_out + ch_out + r_words[`IDX32(15)] + Kt_out; //<----------------- replace by adder module
    // wire [31:0] t2 = sum0_out + maj_out;
    // wire [31:0] new_word = sigm1_out + r_words[`IDX32(6)] + sigm0_out + r_words[`IDX32(15)]; //<----------------- replace by adder module
	//r_status = {4'd0, completed, run, ready, start} <- was commented before

	sum0 inst_sum0(.x(var_a), .y(sum0_out));
	sum1 inst_sum1(.x(var_e), .y(sum1_out));
	sigm0 inst_sigm0(.x(r_words[`IDX32(14)]), .y(sigm0_out));
	sigm1 inst_sigm1(.x(r_words[`IDX32(1)]), .y(sigm1_out));
	ch inst_ch(.x(var_e), .y(var_f), .z(var_g), .o(ch_out));
	maj inst_maj(.x(var_a), .y(var_b), .z(var_c), .o(maj_out));
	sha256_coefs_clk inst_coef_clk(.i_coef_num(r_coef), .i_clk(i_clk), .o_coef_value(Kt_out)); 
	
	`ifndef MF_PAR_ADD
	//adders instances
	//adder_32b_param(i_a, i_b, i_carry, o_carry, o_summ);
	//t1 adders, step 1
	wire [31:0] adder_wire_kt_ch, adder_wire_sum_wt, adder_wire_d_h, adder_wire_sum_wt_kt_ch;
	adder_32b_param st1_kt_ch (Kt_out, ch_out, 1'b0, carryo1, adder_wire_kt_ch);
	adder_32b_param st1_sum_wt (sum1_out, r_words[`IDX32(15)], 1'b0, carryo2, adder_wire_sum_wt);
	adder_32b_param st1_d_h (var_d, var_h, 1'b0, carryo3, adder_wire_d_h);
	//t1 adders, step 2
	adder_32b_param st2_sum_wt_kt_ch (adder_wire_kt_ch, adder_wire_sum_wt, 1'b0, carryo4, adder_wire_sum_wt_kt_ch);
	adder_32b_param st2_all (adder_wire_sum_wt_kt_ch, adder_wire_d_h, 1'b0, carryo5, new_d);
	//t1 adders, step 2 duplicate
	adder_32b_param st2_a (adder_wire_sum_wt_kt_ch, var_h, 1'b0, carryo6, new_a);

	// adder_32b_param inst_t1_var_h_sum1 (var_h, sum1_out, 1'b0, carryo1, adder_wire_t1_1);  <- sequential 5 step addition. gross
	// adder_32b_param inst_t1_prev_ch (adder_wire_t1_1, ch_out, 1'b0, carryo2, adder_wire_t1_2);
	// adder_32b_param inst_t1_prev_rword (adder_wire_t1_2, r_words[`IDX32(15)], 1'b0, carryo3, adder_wire_t1_3);
	// adder_32b_param inst_t1_prev_kt (adder_wire_t1_3, Kt_out, 1'b0, carryo4, t1);
	//var_d + t1
	//adder_32b_param inst_t1_d (t1, var_d, 1'b0, carryo5, new_d);
	//t2 adders
	//adder_32b_param inst_t2_sum0_maj (sum0_out, maj_out, 1'b0, carryo7, t2);
	//t1+t2 adder
	//adder_32b_param inst_t1_t2 (t1, t2, 1'b0, carryo7, new_a);
	//new word adders
	adder_32b_param inst_word_sigm1_rx_word (sigm1_out, r_words[`IDX32(6)], 1'b0, carryo8, adder_wire_word_1);
	adder_32b_param inst_word_prev_sigm0 (adder_wire_word_1, sigm0_out, 1'b0, carryo9, adder_wire_word_2);
	adder_32b_param inst_word_prev_r_words (adder_wire_word_2, r_words[`IDX32(15)], 1'b0, carryo10, new_word);
	`else
	par_add_6	par_add_6_inst (
	.data0x ( Kt_out ),
	.data1x ( ch_out ),
	.data2x ( sum1_out ),
	.data3x ( r_words[`IDX32(15)] ),
	.data4x ( var_d ),
	.data5x ( var_h ),
	.result ( new_d )
	);

	par_add_7	par_add_7_inst (
	.data0x ( Kt_out ),
	.data1x ( ch_out ),
	.data2x ( sum1_out ),
	.data3x ( r_words[`IDX32(15)] ),
	.data4x ( var_h ),
	.data5x ( maj_out ),
	.data6x ( sum0_out ),
	.result ( new_a )
	);

	par_add_4	par_add_4_inst (
	.data0x ( sigm1_out ),
	.data1x ( r_words[`IDX32(6)] ),
	.data2x ( sigm0_out ),
	.data3x ( r_words[`IDX32(15)] ),
	.result ( new_word )
	);

	`endif

	always @* begin
		o_data_mux = 8'd0;
		if((i_w_addr >= 0) & (i_w_addr <= END_W_MEM_ADDR)) begin
			//o_data_mux = 8'd0;
		end else if (i_w_addr == WHO_AM_I) begin
			o_data_mux = WHO_AM_I_DATA;
		end else if (i_w_addr == STATUS_REG) begin
			o_data_mux = r_status;
		end else if(i_w_addr == REVISION) begin
			o_data_mux = REVISION_DATA;
		end else if(i_w_addr == DAY) begin
			o_data_mux = DAY_DATA;
		end else if(i_w_addr == MONTH) begin
			o_data_mux = MONTH_DATA;
		end else if(i_w_addr == YEAR) begin
			o_data_mux = YEAR_DATA;
		end else if ((i_w_addr >= DIGEST_START_ADDR) & (i_w_addr <= DIGEST_END_ADDR)) begin
			o_data_mux = o_data_h;
		end else if(i_w_addr > DIGEST_END_ADDR) begin
			o_data_mux = 8'haa;
		end
	end

    always @ (posedge i_clk or negedge i_rst_n) begin : hash_control_reg
        if(!i_rst_n) begin
            r_round <= 6'd0;
	    r_coef <= 6'd0;
            r_state <= INIT;
            r_status <= 8'd2;
        end else begin
        	if(i_we) begin
        		if(i_w_addr == STATUS_REG) begin
        			r_status <= i_data8[0];	
        		end
			end else begin
				case(r_state)
                	INIT: begin
                    	if(r_status[0]) begin
                        	r_state <= ROUND;
                        	r_status <= 8'b0000_0100; //clear ready, start, set run
							//r_coef special
							r_coef <= 6'd1;
                        end else begin
							//preinit for fkng clk coefs
							r_coef <= 6'd0;
                        	r_status <= 8'b0000_0010;	//(compl, run, ready, start)
                        end
                	end
                	ROUND: begin
                		r_round <= r_round + 1'b1;
						r_coef <= r_coef + 1'b1;
                    	if(r_round == 6'd63) begin
                    		r_state <= MATH;
                    		r_round <= 6'd0;
                    	end
                	end
                	MATH: begin
                		r_state <= OUT;
                	end
                	OUT: begin
                		r_status <= 8'b0000_1010;
                		if(r_status[0]) begin
                			r_state <= INIT;
                		end
                	end
                	default: begin end
            	endcase
			end             
        end
    end

    always @(*) begin : hash_control_comb
    	run_signal = 1'b0;
    	completed = 1'b0;
    	do_math = 1'b0;
    	case (r_state)
    		INIT: begin	end
    		ROUND: run_signal = 1'b1;
    		MATH: do_math = 1'b1;
    		OUT: completed = 1'b1;
    		default : /* default */;
    	endcase
    end


	always @(posedge i_clk or negedge i_rst_n) begin : hash_math
		if(~i_rst_n) begin
			r_variables <= HASH_INIT;
			r_words <= 512'd0;
		end else begin
			if (i_we & !run_signal) begin
				if ((i_w_addr >= START_W_MEM_ADDR) & (i_w_addr < (END_W_MEM_ADDR+1))) begin //check here for other values
					r_words[(i_w_addr - START_W_MEM_ADDR) * 8 +: 8] <= i_data8;
				end
			end else if(run_signal & !i_we) begin : hash_computing
				r_words <= {r_words[479:0], new_word};  //shift right replaced with shift left! <----------------- critical
				r_variables[`IDX32(7)] <= new_a; 		// new a from adder instance
				r_variables[`IDX32(6)] <= var_a;		// new b
				r_variables[`IDX32(5)] <= var_b;		// new c
				r_variables[`IDX32(4)] <= var_c;		// new d
				r_variables[`IDX32(3)] <= new_d;		// new e from adder instance, highest delay here
				r_variables[`IDX32(2)] <= var_e;		// new f
				r_variables[`IDX32(1)] <= var_f;		// new g
				r_variables[`IDX32(0)] <= var_g;		// new h
			end
			if(do_math) begin
				r_variables[`IDX32(7)] <= var_a + 32'h6a09e667; //<----------------- replace by adder module
				r_variables[`IDX32(6)] <= var_b + 32'hbb67ae85;	//replace by initial values for multiblock hash
				r_variables[`IDX32(5)] <= var_c + 32'h3c6ef372;
				r_variables[`IDX32(4)] <= var_d + 32'ha54ff53a;
				r_variables[`IDX32(3)] <= var_e + 32'h510e527f;
				r_variables[`IDX32(2)] <= var_f + 32'h9b05688c;
				r_variables[`IDX32(1)] <= var_g + 32'h1f83d9ab;
				r_variables[`IDX32(0)] <= var_h + 32'h5be0cd19;
			end
		end
	end
endmodule

