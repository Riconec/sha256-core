`include <../top/defines_top.vh>
module sha256_core(
	input i_clk,    // Clock
	input i_rst_n,  // Asynchronous reset active low
	input [6:0] i_w_addr,
	input [7:0]	i_data8,
	input i_we,
	output o_irq,
	output reg [7:0] o_data_mux
	
);
	
	localparam START_W_MEM_ADDR = 0;
	localparam END_W_MEM_ADDR = 63;
	localparam WHO_AM_I = 7'd64;
	localparam STATUS_REG = 7'd65;
	localparam REVISION = 7'd66;
	localparam DAY = 7'd67;
	localparam MONTH = 7'd68;
	localparam YEAR = 7'd69;
	localparam WHO_AM_I_DATA = `ROUND_INC;
	localparam REVISION_DATA = 8'd52;
	localparam DAY_DATA = 8'd20;
	localparam MONTH_DATA = 8'd04;
	localparam YEAR_DATA = 8'd18;
	localparam DIGEST_START_ADDR = 70;
	localparam DIGEST_END_ADDR = 101;
    localparam MEM_END = 127;

	//16 addresses left empty
	localparam HASH_INIT = 256'h6a09e667_bb67ae85_3c6ef372_a54ff53a_510e527f_9b05688c_1f83d9ab_5be0cd19;
	parameter ROUND_INC_DEF = `ROUND_INC;
	parameter ROUND_END_DEF = `ROUND_END;
	// FSM states
    parameter   INIT = 2'd0,
                ROUND = 2'd1,
                MATH = 2'd2,
                OUT = 2'd3;

    `ifdef USER_MEMORY
        reg [7:0] usr_mem [MEM_END-DIGEST_END_ADDR-1:0]
    `endif

	reg [255:0] r_variables, r_variables_in; //a, b, c, d, e, f, g, h 
	reg [511:0] r_words; //W0, W1, W2 ... W15 in terms of FIPS
	reg [6:0] r_round;
	reg [7:0] r_status;
	reg completed, run_signal, do_math;

	wire [7:0] o_data_h;
	
	assign o_irq = completed;
	assign o_data_h = r_variables[(i_w_addr-DIGEST_START_ADDR) * 8 +: 8];

	always @* begin
		o_data_mux = 8'd0;
		if((i_w_addr >= 0) & (i_w_addr <= END_W_MEM_ADDR)) begin
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
                o_data_mux = usr_mem[i_w_addr[3:0]];
            `else
			    o_data_mux = 8'haa;
            `endif
		end
	end

    /* Help assignments
    r_status[7:5] - reserved
    r_status[5:4] - state
    r_status[3] - completed
    r_status[2] - running
    r_status[1] - ready
    r_status[0] - start 
    */

    always @ (posedge i_clk or negedge i_rst_n) begin : hash_control_reg
        if(!i_rst_n) begin
            r_round <= 7'd0;
            r_status <= 8'd0;
			r_variables_in <= HASH_INIT;
        end else begin
        	if(i_we) begin
        		if(i_w_addr == STATUS_REG) begin
        			r_status <= i_data8[0];	
        		end
			end else begin
				case(r_status[5:4])
                	INIT: begin
                    	if(r_status[0]) begin // if START
                        	r_status[5:4] <= ROUND;
                        	r_status[3:0] <= 4'b0100; //set running
							r_variables_in <= HASH_INIT;
                        end else begin
                        	r_status[3:0] <= 4'b0010; // set ready
                        end
                	end
                	ROUND: begin
                		r_round <= r_round + `ROUND_INC;
						if(r_round == ROUND_END_DEF) begin
                    		r_status[5:4] <= MATH;
                    		r_round <= 7'd0;
                    	end
                	end
                	MATH: begin
                		r_status[5:4] <= OUT;
                	end
                	OUT: begin
                        r_status[5:4] <= INIT;
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
    	case (r_status[5:4])
    		INIT: begin	end
    		ROUND: run_signal = 1'b1;
    		MATH: do_math = 1'b1;
    		OUT: completed = 1'b1;
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
        if (i == 0) begin
			`ifdef ROUND1BYPASS
            	sha256_digester_comb inst_sha (i_clk, (r_round + i[6:0]), r_variables, variables_out_end, r_words, words_out_end);
			`else
				sha256_digester_comb inst_sha (i_clk, (r_round + i[6:0]), r_variables, variables_net[i], r_words, words_net[i]);
			`endif
        end else if (i != (`ROUND_INC-1)) begin
            sha256_digester_comb inst_sha (i_clk, (r_round + i[6:0]), variables_net[i-1], variables_net[i], words_net[i-1], words_net[i]);
        end else begin
            sha256_digester_comb inst_sha (i_clk, (r_round + i[6:0]), variables_net[i-1], variables_out_end, words_net[i-1], words_out_end);
        end
    end

    endgenerate

	always @(posedge i_clk or negedge i_rst_n) begin : hash_math
		if(!i_rst_n) begin
			r_words <= 512'd0; // debug words 512'h5348412D32353620636F72652062792059657668656E696920506F707261766B6120323031383A29800000000000000000000000000000000000000000000028;
			r_variables <= HASH_INIT;
		end else begin
			if (i_we & !run_signal) begin
				if ((i_w_addr >= START_W_MEM_ADDR) & (i_w_addr < (END_W_MEM_ADDR + 1))) begin
					r_words[(i_w_addr - START_W_MEM_ADDR) * 8 +: 8] <= i_data8;
				end
                `ifdef USER_MEMORY
                    else if ((i_w_addr > DIGEST_END_ADDR) & (i_w_addr < (MEM_END + 1))) begin 
                        usr_mem[i_w_addr[3:0]] <= i_data8; /* write user data, why not ? */
                    end
                `endif
			end else if(run_signal & !i_we) begin : hash_computing
				r_words <= words_out_end;
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

module sha256_digester_comb(i_clk, r_coef, i_variables, o_variables, i_words, o_words);
	input i_clk;
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

	sum0 inst_sum0(.x(var_a), .y(sum0_out));
	sum1 inst_sum1(.x(var_e), .y(sum1_out));
	sigm0 inst_sigm0(.x(i_words[`IDX32(14)]), .y(sigm0_out));
	sigm1 inst_sigm1(.x(i_words[`IDX32(1)]), .y(sigm1_out));
	ch inst_ch(.x(var_e), .y(var_f), .z(var_g), .o(ch_out));
	maj inst_maj(.x(var_a), .y(var_b), .z(var_c), .o(maj_out));
	sha256_coefs inst_coef_clk(.i_coef_num(r_coef), .o_coef_value(Kt_out));
	
	sha_adder  sh_add_inst(.i_kt(Kt_out),
						   .i_ch(ch_out),
						   .i_sum1(sum1_out),
						   .i_sum0(sum0_out),
						   .i_sigm1(sigm1_out),
						   .i_sigm0(sigm0_out),
						   .i_maj(maj_out),
						   .i_d(var_d),
						   .i_h(var_h),
						   .i_words(i_words),
						   .o_d(o_d),
						   .o_a(o_a),
						   .o_word(new_word)
						   );		

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
