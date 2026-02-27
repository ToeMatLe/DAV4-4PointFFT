module butterfly #(
    parameter int WIDTH = 32
)(
    input signed [WIDTH-1:0] A,
    input signed [WIDTH-1:0] B,
    input signed [WIDTH-1:0] W,
    output signed [WIDTH-1:0] out0,
    output signed [WIDTH-1:0] out1
);
    localparam int HALF = WIDTH/2;
    logic signed [HALF-1: 0] A_real, B_real, W_real, A_imag, B_imag, W_imag;
    // Split the inputs into half real and half imaginary parts
    assign A_real = A[WIDTH-1:HALF];
    assign A_imag = A[HALF-1:0];
    assign B_real = B[WIDTH-1:HALF];
    assign B_imag = B[HALF-1:0];
    assign W_real = W[WIDTH-1:HALF];
    assign W_imag = W[HALF-1:0];

    // Perform the butterfly operation
    // B*W = (B_real + jB_imag)(W_real + jW_imag) = (B_real*W_real - B_imag*W_imag) + j(B_real*W_imag + B_imag*W_real)
    logic signed [WIDTH-1:0] temp_real, temp_imag;
    assign temp_real = B_real * W_real - B_imag * W_imag;
    assign temp_imag = B_real * W_imag + B_imag * W_real

    logic signed [HALF-1:0] out0_real, out0_imag;
    logic signed [HALF-1:0] out1_real, out1_imag;

    assign out0_real = A_real + temp_real;
    assign out0_imag = A_imag + temp_imag;
    assign out1_real = A_real - temp_real;
    assign out1_imag = A_imag - temp_imag;

    assign out0 = {out0_real, out0_imag};
    assign out1 = {out1_real, out1_imag};
endmodule