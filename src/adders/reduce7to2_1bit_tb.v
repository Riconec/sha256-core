module reduce7to2_1bit_tb;
    localparam WIDTH = 32;
    reg [WIDTH-1:0] i_a, i_b, i_c, i_d, i_e, i_f, i_g;
    reg [4:0] i_ca;
    //wire o_s, o_c;
    //wire [4:0] o_ca;
    wire [WIDTH-1:0] o_cn, o_sn;


    //reduce7to2_1bit inst1(i_a, i_b, i_c, i_d, i_e, i_f, i_g, i_ca, o_c, o_ca, o_s);

    reduce7to2_nbit #(WIDTH) inst2(i_a, i_b, i_c, i_d, i_e, i_f, i_g, o_cn, o_sn);

    initial begin
        #1;
        /*all inputs 0 */
        i_a = 0;
        i_b = 0;
        i_c = 0;
        i_d = 0;
        i_e = 0;
        i_f = 0;
        i_g = 0;

        /* input carry all 0 */
        i_ca = 5'd0;

        #5;
        /*all inputs 0 */
        i_a = 1;
        i_b = 2;
        i_c = 3;
        i_d = 4;
        i_e = 5;
        i_f = 6;
        i_g = 7;

        #5;
        /*all inputs 0 */
        i_a = 255;
        i_b = 255;
        i_c = 255;
        i_d = 255;
        i_e = 255;
        i_f = 255;
        i_g = 255;

        #5;
        /*all inputs 0 */
        i_a = 32767;
        i_b = 32767;
        i_c = 32767;
        i_d =32767;
        i_e =32767;
        i_f = 32767;
        i_g = 32767;
      $pause;
    end

endmodule