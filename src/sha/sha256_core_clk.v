`include "../top/defines_top.vh"
module sha256_core(
	input i_clk,    // Clock
	input i_rst_n,  // Asynchronous reset active low
	input [6:0] i_w_addr,
	input [7:0]	i_data8,
	input i_we,
	output o_irq,
	output reg [7:0] o_data_mux
	
);
	
	parameter N = 16;
	// FSM states - 3-bit encoding for expanded state support

    // assuming width can fit in 4 bits
    parameter [(N*5)-1:0] ROUND_LOAD = {5'd15, 5'd14, 5'd13, 5'd12, 5'd11,  5'd10, 5'd9,  5'd8, 5'd7, 5'd6, 5'd5, 5'd4, 5'd3, 5'd2,  5'd1,5'd0};

    `ifdef USER_MEMORY
        reg [7:0] usr_mem [MEM_END-DIGEST_END_ADDR-1:0]
    `endif

	reg [255:0] r_variables, r_variables_in; //a, b, c, d, e, f, g, h
	reg [639:0] r_words; // Expanded to 640 bits to store 80-byte input (512 bits for W0-W15, 128 bits for padding)
	reg [6:0] r_round;
	reg [7:0] r_status;
	reg completed, run_signal, do_math;

	wire [7:0] o_data_h;
	
	assign o_irq = completed;
	assign o_data_h = r_variables[(i_w_addr-DIGEST_START_ADDR) * 8 +: 8];

	always @* begin
		o_data_mux = 8'd0;
		if(i_w_addr <= END_W_MEM_ADDR) begin
			//o_data_mux = 8'd0; //reading disabled
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
            `ifdef USER_MEMORY
				if (i_w_addr > MEM_END) begin
					o_data_mux = 8'haa; //safe for no reason
				end else begin
				    o_data_mux = usr_mem[i_w_addr[3:0]];
				end
            `else
			    o_data_mux = 8'haa;
            `endif
		end
	end

	`ifdef MULTI_REORDER
		reg [31:0] r_t3_precalculated;
		reg [6:0] r_round_prec;
		wire [31:0] Kt_out_prec;
		/* Reorder uses additional LUT table */
		sha256_coefs inst_coef_clk_prec(.i_coef_num((r_status[STATUS_STATE_HI:STATUS_STATE_LO] == 3'b000) ? r_round : r_round_prec), .o_coef_value(Kt_out_prec));
	`endif

    always @ (posedge i_clk or negedge i_rst_n) begin : hash_control_reg
        if(!i_rst_n) begin
            r_round <= 7'd0;
            r_status <= STATUS_INIT_VALUE;  // Reset all status bits, including completed=0
			r_variables_in <= HASH_INIT;
			`ifdef MULTI_REORDER
			r_round_prec <= 0;
			r_t3_precalculated <= 32'd0;
			`endif
        end else begin
        	if(i_we) begin
        		if(i_w_addr == STATUS_REG) begin
        			// Update bit 0 (start), bit 1 (bitcoin mode), bit 2 (nonce_sweep_enable), and preserve other bits
        			r_status[STATUS_START] <= i_data8[STATUS_START];      // Start bit
        			r_status[STATUS_BITCOIN_MODE] <= i_data8[STATUS_BITCOIN_MODE];      // Bitcoin mode bit
        			r_status[STATUS_NONCE_SWEEP] <= i_data8[STATUS_NONCE_SWEEP];      // Nonce sweep enable (reserved)
        			// Other bits remain unchanged
        		end
			end else begin
				case(r_status[STATUS_STATE_HI:STATUS_STATE_LO])
                	INIT: begin
					`ifdef MULTI_REORDER
						r_t3_precalculated <= r_variables[`IDX32(0)] + Kt_out_prec + r_words[`IDX32(15)];
						`endif
                    	if(r_status[STATUS_START]) begin // if START
						`ifdef MULTI_REORDER
							r_round_prec <= r_round + 1'b1;
							`endif
                        	r_status[STATUS_STATE_HI:STATUS_STATE_LO] <= ROUND;
                        	r_status[STATUS_COMPLETED] <= 1'b0; // clear completed (bit 7)
                        	r_status[STATUS_SECOND_ROUND] <= 1'b0; // clear second_round (bit 6) when starting new operation  
                        end else begin
                        	r_status[STATUS_COMPLETED] <= 1'b1; // set completed (ready state when not active)
                        end
                	end
                	ROUND: begin
                		r_round <= r_round + `ROUND_INC;
						`ifdef MULTI_REORDER
						r_round_prec <= r_round_prec + `ROUND_INC;
						r_t3_precalculated <= r_variables[`IDX32(1)] + Kt_out_prec + r_words[`IDX32(14)];
						`endif
						if(r_round == ROUND_END_DEF) begin
                    		r_status[STATUS_STATE_HI:STATUS_STATE_LO] <= MATH;
                    		r_round <= 7'd0;
                    	end
                	end
                	MATH: begin
						// In MATH state, perform final addition A-H + initial/intermediate values
                        if(r_status[STATUS_BITCOIN_MODE] && !r_status[STATUS_SECOND_ROUND]) begin // First round in Bitcoin mode
							r_status[STATUS_STATE_HI:STATUS_STATE_LO] <= BTC_1; // 
							r_status[STATUS_SECOND_ROUND] <= 1'b1;
						end else if (r_status[STATUS_BITCOIN_MODE] && r_status[STATUS_SECOND_ROUND]) begin // Second round in Bitcoin mode
							r_status[STATUS_STATE_HI:STATUS_STATE_LO] <= BTC_2; // 
							r_status[STATUS_SECOND_ROUND] <= 1'b0;
						else begin // Legacy mode
							r_status[STATUS_STATE_HI:STATUS_STATE_LO] <= INIT; // Go to completion
						end
                	end
					BTC_1: begin
						// First SHA-256 addition done, prepare for second round
						// imitate reset state here, r_variables_in kept saved, r_words need to load second frame padded
						// words updated with extra padded frame
						r_words[511:0] <= {r_words[639:512], PADDED_BLOCK};
						r_variables_in <= r_variables; // Use first hash as "initial" for second round
						`ifdef MULTI_REORDER
						r_round_prec <= 0;
						r_t3_precalculated <= 32'd0;
						`endif
						r_status[STATUS_STATE_HI:STATUS_STATE_LO] <= INIT; // 
					end
					BTC_2: begin
						r_words[511:0] <= {r_words[511:256], SHA256_PAD};
						r_variables_in <= HASH_INIT;
						`ifdef MULTI_REORDER
						r_round_prec <= 0;
						r_t3_precalculated <= 32'd0;
						`endif
						r_status[STATUS_STATE_HI:STATUS_STATE_LO] <= INIT; // 
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
    	case (r_status[STATUS_STATE_HI:STATUS_STATE_LO])
    		INIT: begin	end
    		ROUND: run_signal = 1'b1;
    		MATH: do_math = 1'b1;
    		default : /* default */;
    	endcase
    end

    wire [255:0] variables_net [`ROUND_INC-1:0];
    wire [511:0] words_net [`ROUND_INC-1:0];
    wire [255:0] variables_out_end;
    wire [511:0] words_out_end;

	generate
    genvar i;

    for (i = 0; i < `ROUND_INC; i = i + 1) begin : rounder
        if (i == 0) begin : gen_rounds
			`ifdef ROUND1BYPASS
`ifdef MULTI_REORDER
            	sha256_digester_comb #(ROUND_LOAD[i*5+:5]) inst_sha (i_clk, i_rst_n, (r_round + i[6:0]), r_variables, r_status, variables_out_end, r_words[511:0], r_t3_precalculated, words_out_end);
`else
            	sha256_digester_comb #(ROUND_LOAD[i*5+:5]) inst_sha (i_clk, i_rst_n, (r_round + i[6:0]), r_variables, r_status, variables_out_end, r_words[511:0], 32'd0, words_out_end);
`endif
			`else
`ifdef MULTI_REORDER
				sha256_digester_comb #(ROUND_LOAD[i*5+:5]) inst_sha (i_clk, i_rst_n, (r_round + i[6:0]), r_variables, r_status, variables_net[i], r_words[511:0], r_t3_precalculated, words_net[i]);
`else
				sha256_digester_comb #(ROUND_LOAD[i*5+:5]) inst_sha (i_clk, i_rst_n, (r_round + i[6:0]), r_variables, r_status, variables_net[i], r_words[511:0], 32'd0, words_net[i]);
`endif
			`endif
        end else if (i != (`ROUND_INC-1)) begin
            sha256_digester_comb #(ROUND_LOAD[i*5+:5]) inst_sha (i_clk, i_rst_n, (r_round + i[6:0]), variables_net[i-1], r_status, variables_net[i], words_net[i-1], 32'd0, words_net[i]);
        end else begin
            sha256_digester_comb #(ROUND_LOAD[i*5+:5]) inst_sha (i_clk, i_rst_n, (r_round + i[6:0]), variables_net[i-1], r_status, variables_out_end, words_net[i-1], 32'd0, words_out_end);
        end
    end

    endgenerate

	always @(posedge i_clk or negedge i_rst_n) begin : hash_math
		if(!i_rst_n) begin
			r_words <= 640'd0; // Initialize 80-byte message storage (640 bits)
			r_variables <= HASH_INIT;
		end else begin
			if (i_we & !run_signal) begin
				if (i_w_addr < (END_W_MEM_ADDR + 1)) begin
					r_words[(i_w_addr - START_W_MEM_ADDR) * 8 +: 8] <= i_data8;  // Store to 640-bit message register
				end
                `ifdef USER_MEMORY
                    else if ((i_w_addr > DIGEST_END_ADDR) & (i_w_addr < (MEM_END + 1))) begin 
                        usr_mem[i_w_addr[3:0]] <= i_data8; /* write user data, why not ? */
                    end
                `endif
			end else if(run_signal & !i_we) begin : hash_computing
				r_words[511:0] <= words_out_end;  // Update only the 512-bit message schedule part
				r_variables <= variables_out_end;
			end else if(do_math) begin
				r_variables[`IDX32(7)] <= r_variables[`IDX32(7)] + r_variables_in[`IDX32(7)];
				r_variables[`IDX32(6)] <= r_variables[`IDX32(6)] + r_variables_in[`IDX32(6)];
				r_variables[`IDX32(5)] <= r_variables[`IDX32(5)] + r_variables_in[`IDX32(5)];
				r_variables[`IDX32(4)] <= r_variables[`IDX32(4)] + r_variables_in[`IDX32(4)];
				r_variables[`IDX32(3)] <= r_variables[`IDX32(3)] + r_variables_in[`IDX32(3)];
				r_variables[`IDX32(2)] <= r_variables[`IDX32(2)] + r_variables_in[`IDX32(2)];
				r_variables[`IDX32(1)] <= r_variables[`IDX32(1)] + r_variables_in[`IDX32(1)];
				r_variables[`IDX32(0)] <= r_variables[`IDX32(0)] + r_variables_in[`IDX32(0)];
			end
		end
	end
endmodule

module sha256_digester_comb(i_clk, i_rst_n, r_coef, i_variables, i_status, o_variables, i_words, i_t3, o_words);
	parameter RESET_ROUND = 0;
	input i_clk;	
	input i_rst_n;
	input [31:0] i_t3;
	input [7:0] i_status;
	input [6:0] r_coef;
	input [511:0] i_words;
	input [255:0] i_variables;
	output [255:0] o_variables;
	output [511:0] o_words;
	wire [31:0] sum0_out, sum1_out, sigm0_out, sigm1_out, ch_out, maj_out, Kt_out, new_word;
	wire [31:0] o_var_a, o_var_b, o_var_c, o_var_d, o_var_e, o_var_f, o_var_g, o_var_h, o_d, o_a;

	wire [31:0] var_a = i_variables[`IDX32(7)];
	wire [31:0] var_b = i_variables[`IDX32(6)];
	wire [31:0] var_c = i_variables[`IDX32(5)];
	wire [31:0] var_d = i_variables[`IDX32(4)];
	wire [31:0] var_e = i_variables[`IDX32(3)];
	wire [31:0] var_f = i_variables[`IDX32(2)];
	wire [31:0] var_g = i_variables[`IDX32(1)];
	wire [31:0] var_h = i_variables[`IDX32(0)];

	sum0 inst_sum0(var_a, sum0_out);
	sum1 inst_sum1(var_e, sum1_out);
	sigm0 inst_sigm0(i_words[`IDX32(14)], sigm0_out);
	sigm1 inst_sigm1(i_words[`IDX32(1)], sigm1_out);
	ch inst_ch(var_e, var_f, var_g, ch_out);
	maj inst_maj(var_a, var_b, var_c, maj_out);
	sha256_coefs inst_coef_clk(.i_coef_num(r_coef), .o_coef_value(Kt_out));

`ifdef REORDER
		reg [31:0] r_t3_precalculated;
		reg [6:0] r_round_prec;
		wire [31:0] Kt_out_prec;
		/* Reorder uses additional LUT table */
		sha256_coefs inst_coef_clk_prec(.i_coef_num((i_status[STATUS_STATE_HI:STATUS_STATE_LO] == 3'b000) ? r_coef : r_round_prec), .o_coef_value(Kt_out_prec));

			always @(posedge i_clk, negedge i_rst_n) begin
				if(!i_rst_n) begin
					r_round_prec <= RESET_ROUND;
					r_t3_precalculated <= 32'd0;
				end else begin
					case(i_status[STATUS_STATE_HI:STATUS_STATE_LO])
						INIT: begin
							r_t3_precalculated <= i_variables[`IDX32(0)] + Kt_out_prec + i_words[`IDX32(15)];
							if(i_status[STATUS_START]) begin
								r_round_prec <= r_coef + 1'b1;
							end else begin 
								r_round_prec <= RESET_ROUND;
							end
						end
						ROUND: begin
								r_round_prec <= r_round_prec + 1'b1;
								r_t3_precalculated <= i_variables[`IDX32(1)] + Kt_out_prec + i_words[`IDX32(14)];
						end
						default: begin end
					endcase
				end
			end

	sha_adder  #(RESET_ROUND)
	sh_add_inst(.i_kt(Kt_out),
						   .i_ch(ch_out),
						   .i_sum1(sum1_out),
						   .i_sum0(sum0_out),
						   .i_sigm1(sigm1_out),
						   .i_sigm0(sigm0_out),
						   .i_maj(maj_out),
						   .i_d(var_d),
						   .i_h(var_h),
						   .i_words(i_words),
						   .i_t3(r_t3_precalculated),
						   .o_d(o_d),
						   .o_a(o_a),
						   .o_word(new_word)
						   );

`else

	sha_adder  #(RESET_ROUND)
	sh_add_inst(.i_kt(Kt_out),
						   .i_ch(ch_out),
						   .i_sum1(sum1_out),
						   .i_sum0(sum0_out),
						   .i_sigm1(sigm1_out),
						   .i_sigm0(sigm0_out),
						   .i_maj(maj_out),
						   .i_d(var_d),
						   .i_h(var_h),
						   .i_words(i_words),
						   .i_t3(i_t3),
						   .o_d(o_d),
						   .o_a(o_a),
						   .o_word(new_word)
						   );
`endif
	assign o_var_a = o_a;
	assign o_var_b = var_a;
	assign o_var_c = var_b;
	assign o_var_d = var_c;
	assign o_var_e = o_d;
	assign o_var_f = var_e;
	assign o_var_g = var_f;
	assign o_var_h = var_g;
	assign o_words = {i_words[479:0], new_word};
	assign o_variables = {o_var_a, o_var_b, o_var_c, o_var_d, o_var_e, o_var_f, o_var_g, o_var_h};

endmodule
