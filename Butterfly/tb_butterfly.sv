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
task automatic test(
    input logic signed [HALF-1:0] A_real, A_imag, B_real, B_imag, W_real, W_imag, 
    input logic signed [HALF-1:0] expected_out0_real, expected_out0_imag, expected_out1_real, expected_out1_imag
    ); 
    begin 
        A = {A_real, A_imag};
        B = {B_real, B_imag};
        W = {W_real, W_imag};
        #10; // Wait for outputs to stabilize
        $display("A: %0d + j%0d, B: %0d + j%0d, W: %0d + j%0d => out0: %0d + j%0d, out1: %0d + j%0d", 
            A_real, A_imag, B_real, B_imag, W_real, W_imag,
            $signed(out0[WIDTH-1:HALF]), $signed(out0[HALF-1:0]), $signed(out1[WIDTH-1:HALF]), $signed(out1[HALF-1:0]));

        assert(out0[WIDTH-1:HALF] == expected_out0_real) 
            else $fatal("A1 mismatch: expected %0d, got %0d", expected_out0_real, $signed(out0[WIDTH-1:HALF]));
        assert(out0[HALF-1:0] == expected_out0_imag) 
            else $fatal("B1 mismatch: expected %0d, got %0d", expected_out0_imag, $signed(out0[HALF-1:0]));
        assert(out1[WIDTH-1:HALF] == expected_out1_real) 
            else $fatal("A2 real mismatch: expected %0d, got %0d", expected_out1_real, $signed(out1[WIDTH-1:HALF]));
        assert(out1[HALF-1:0] == expected_out1_imag) 
            else $fatal("B2 imag mismatch: expected %0d, got %0d", expected_out1_imag, $signed(out1[HALF-1:0]));
    end
endtask 
    // 1 + j0
    localparam signed [HALF-1:0] W0_RE  = 16'sd32767;
    localparam signed [HALF-1:0] W0_IM  = 16'sd0;
    // 0 - j1
    localparam signed [HALF-1:0] W1_RE  = 16'sd0;
    localparam signed [HALF-1:0] W1_IM  = -16'sd32767;
    // -1 + j0
    localparam signed [HALF-1:0] W2_RE = -16'sd32768;
    localparam signed [HALF-1:0] W2_IM = 16'sd0;
    // 0 + j1
    localparam signed [HALF-1:0] W3_RE  = 16'sd0;
    localparam signed [HALF-1:0] W3_IM  = 16'sd32767;
    
initial begin 
    test(10, 5, 20, 15, W0_RE, W0_IM, 30, 20, -10, -10); // A=10+5j, B=20+15j, W=1+0j => out0=30+20j, out1=-10-10j
    test(10, 5, 20, 15, W1_RE, W1_IM,  25, -15,  -5, 25); // A=10+5j, B=20+15j, W=0-1j => out0=25-15j, out1=-5+25j
    test(10, 5, 20, 15, W2_RE, W2_IM, -10, -10, 30, 20); // A=10+5j, B=20+15j, W=-1+0j => out0=-10-10j, out1=30+20j
    test(10, 5, 20, 15,  W3_RE, W3_IM,  -5, 25,  25, -15); // A=10+5j, B=20+15j, W=0+1j => out0=-5+25j, out1=25-15j
    $display("All butterfly tests passed!");
    $finish;
end
endmodule
