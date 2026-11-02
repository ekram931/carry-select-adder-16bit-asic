module carry_select_adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input c_in,
    output [15:0] sum,
    output c_out
);
    wire w1, w2, w3;
    wire [3:0] s0, s1;

    CLA_adder A1 (.a(a[3:0]), .b(b[3:0]), .c_in(c_in), .sum(sum[3:0]), .c_out(w1));

    CLA_adder A2 (.a(a[7:4]), .b(b[7:4]), .c_in(1'b0), .sum(s0), .c_out(w2));
    CLA_adder A3 (.a(a[7:4]), .b(b[7:4]), .c_in(1'b1), .sum(s1), .c_out(w3));


    mux_2_to_1 M1 (.in0(s0), .in1(s1), .sel(w1), .out(sum[7:4]));


endmodule