module tb_butterfly;

localparam int WIDTH = 32;
localparam int HALF = WIDTH/2;
logic signed [WIDTH-1:0] A, B, W;
logic signed [WIDTH-1:0] out0, out1;

// Instantiate the butterfly module (Device Under Test)
butterfly #(.WIDTH(WIDTH)) dut (
    .A(A),
    .B(B),
    .W(W),
    .out0(out0),
    .out1(out1)
);


endmodule
