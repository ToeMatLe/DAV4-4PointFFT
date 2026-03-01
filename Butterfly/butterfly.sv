module butterfly #(
    parameter int WIDTH = 32
)(
    input  logic signed [WIDTH-1:0] A,
    input  logic signed [WIDTH-1:0] B,
    input  logic signed [WIDTH-1:0] W,
    output logic signed [WIDTH-1:0] out0,
    output logic signed [WIDTH-1:0] out1
);
    localparam int HALF = WIDTH/2;

    logic signed [HALF-1:0] A_real, A_imag, B_real, B_imag, W_real, W_imag;

    assign A_real = A[WIDTH-1:HALF];
    assign A_imag = A[HALF-1:0];
    assign B_real = B[WIDTH-1:HALF];
    assign B_imag = B[HALF-1:0];
    assign W_real = W[WIDTH-1:HALF];
    assign W_imag = W[HALF-1:0];

    logic signed [WIDTH-1:0] mult_ac, mult_bd, mult_ad, mult_bc;
    logic signed [WIDTH-1:0] temp_real, temp_imag;

    assign mult_ac  = B_real * W_real;
    assign mult_bd  = B_imag * W_imag;
    assign mult_ad  = B_real * W_imag;
    assign mult_bc  = B_imag * W_real;

    assign temp_real = mult_ac - mult_bd;
    assign temp_imag = mult_ad + mult_bc;

    // Scale back to 16 bits with rounding (add 0.5 in fixed-point)
    logic signed [HALF-1:0] bw_real, bw_imag;
    assign bw_real = ((temp_real + (1 <<< 14)) >>> 15)[HALF-1:0];
    assign bw_imag = ((temp_imag + (1 <<< 14)) >>> 15)[HALF-1:0];

    // 17-bit add/sub then pack
    logic signed [HALF:0] sum0_r, sum0_i, sum1_r, sum1_i;
    assign sum0_r = A_real + bw_real;
    assign sum0_i = A_imag + bw_imag;
    assign sum1_r = A_real - bw_real;
    assign sum1_i = A_imag - bw_imag;

    // 17 to 16 bits, dealing with overflow
    assign out0 = {sum0_r[HALF-1:0], sum0_i[HALF-1:0]};
    assign out1 = {sum1_r[HALF-1:0], sum1_i[HALF-1:0]};

endmodule
