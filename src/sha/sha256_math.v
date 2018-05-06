`timescale 1ns/1ps

`ifdef XOR_REPLACED_BY_OR
	`define OR_XOR 7
module ch (i_x, i_y, i_z, o_res);

	input [31:0] i_x, i_y, i_z;
	output [31:0] o_res;

	assign o_res = i_z | (i_x & (i_y | i_z));

endmodule

`else

module ch (i_x, i_y, i_z, o_res);

	input [31:0] i_x, i_y, i_z;
	output [31:0] o_res;

	assign o_res = i_z ^ (i_x & (i_y ^ i_z));

endmodule

`endif

module maj (i_x, i_y, i_z, o_res);

	input [31:0] i_x, i_y, i_z;
	output [31:0] o_res;

	assign o_res = (i_x & i_y) | (i_z & (i_x | i_y));

endmodule

module sum0 (i_x, o_res);

	input [31:0] i_x;
	output [31:0] o_res;

	assign o_res = {i_x[1:0],i_x[31:2]} ^ {i_x[12:0],i_x[31:13]} ^ {i_x[21:0],i_x[31:22]};

endmodule


module sum1 (i_x, o_res);

	input [31:0] i_x;
	output [31:0] o_res;

	assign o_res = {i_x[5:0],i_x[31:6]} ^ {i_x[10:0],i_x[31:11]} ^ {i_x[24:0],i_x[31:25]};

endmodule

module sigm0 (i_x, o_res);

	input [31:0] i_x;
	output [31:0] o_res;

	assign o_res[31:29] = i_x[6:4] ^ i_x[17:15];
	assign o_res[28:0] = {i_x[3:0], i_x[31:7]} ^ {i_x[14:0],i_x[31:18]} ^ i_x[31:3];

endmodule

module sigm1 (i_x, o_res);

	input [31:0] i_x;
	output [31:0] o_res;

	assign o_res[31:22] = i_x[16:7] ^ i_x[18:9];
	assign o_res[21:0] = {i_x[6:0],i_x[31:17]} ^ {i_x[8:0],i_x[31:19]} ^ i_x[31:10];

endmodule


