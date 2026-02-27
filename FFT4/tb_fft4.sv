`timescale 1ps/1ps

module tb_fft4;

localparam int WIDTH = 32;
logic clk;
logic rst;
logic start;
logic done;
logic signed [WIDTH-1:0] in0, in1, in2, in3;
logic signed [WIDTH-1:0] out0, out1, out2, out3;

fft4 #(.WIDTH(WIDTH)) dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .done(done),
    .in0(in0),
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .out0(out0),
    .out1(out1),
    .out2(out2),
    .out3(out3)
);

initial clk = 0;;
always #10 clk = ~clk;

initial begin 
    
    $display("");
    $finish;
end


endmodule