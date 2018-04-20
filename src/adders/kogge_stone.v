/* Kogge-Stone adder */
module KSA(a,b,ci,s,co);
    parameter size=2;
    parameter exp=$clog2(size);

    input  [size-1:0] a,b;
    output [size-1:0] s;
    input  ci;
    output co;
    wire [size:0] P[0:exp],G[0:exp];

    assign P[0] = {a, 1'b1} ^ {b, ci};
    assign G[0] = {a, 1'b1} & {b, ci};

    generate
        genvar i;
        
        for (i=0;i<exp;i=i+1) begin : prop
            PG #(size,2**i) pg (P[i],G[i],P[i+1],G[i+1]);
        end
    endgenerate
    
    assign s = P[0][size:1] ^ G[exp][size-1:0];
    assign co = (P[0][size] & G[exp][size-1]) | G[exp][size];

endmodule

/* KSA propagate and generate */
module PG(Pi,Gi,Po,Go);
    parameter size = 2;
    parameter d = 1;
    input  [size:0] Pi,Gi;
    output [size:0] Po,Go;

    assign Po[size:d] =  Pi[size:d] & Pi[size-d:0];
    assign Go[size:d] = (Pi[size:d] & Gi[size-d:0]) | Gi[size:d];
    assign Po[d-1:0] = Pi[d-1:0];
    assign Go[d-1:0] = Gi[d-1:0];
endmodule

