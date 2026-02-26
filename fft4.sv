module fft4 #(
    parameter int WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic start,
    output logic done,
    input signed [WIDTH-1:0] in0,
    input signed [WIDTH-1:0] in1,
    input signed [WIDTH-1:0] in2,
    input signed [WIDTH-1:0] in3,
    output signed [WIDTH-1:0] out0,
    output signed [WIDTH-1:0] out1,
    output signed [WIDTH-1:0] out2,
    output signed [WIDTH-1:0] out3
);
    // Define the twiddle factors for N=4
    localparam signed [WIDTH-1:0] W0 = {16'h0001, 16'h0000}; // W^0 = 1 + j0  = 1
    localparam signed [WIDTH-1:0] W1 = {16'h0000, 16'hFFFF}; // W^1 = 0 - j1  = -j1
    localparam signed [WIDTH-1:0] W2 = {16'hFFFF, 16'h0000}; // W^2 = -1 + j0 = -1
    localparam signed [WIDTH-1:0] W3 = {16'h0000, 16'h0001}; // W^3 = 0 + j1  = j1

    // Create FSM for the 4 stages of the FFT
    typedef enum logic [1:0] { 
        RESET = 2'b00,
        STAGE1 = 2'b01,
        STAGE2 = 2'b10,
        DONE = 2'b11
    } state;
    state current_state, next_state;

    // Butterfly outputss
    logic signed [WIDTH-1:0] bf1_out1, bf1_out2;
    logic signed [WIDTH-1:0] bf2_out1, bf2_out2;
    // Inputs to the butterfly modules
    logic signed [WIDTH-1:0] bf_in0, bf_in1, bf_in2, bf_in3;
    // Inputs to Twiddle factor multipliers
    logic signed [WIDTH-1:0] tw_even, tw_odd;
    // Hold Stage1 results so Stage2 can wire correctly
    logic signed [WIDTH-1:0] s1_e0, s1_e1, s1_o0, s1_o1;

    // Instantiate 2 butterflies (reused across stages)
    butterfly #(.WIDTH(WIDTH)) bfeven (
        .A(bf_in0),
        .B(bf_in1),
        .W(tw_even),
        .out0(bf1_out1),
        .out1(bf1_out2)
    );
    butterfly #(.WIDTH(WIDTH)) bfodd (
        .A(bf_in2),
        .B(bf_in3),
        .W(tw_odd),
        .out0(bf2_out1),
        .out1(bf2_out2)
    );
    // FSM for controlling the stages
    always_comb begin : state_transition
        case (current_state)
            RESET: next_state = start ? STAGE1 : RESET; // start control signal
            STAGE1: next_state = STAGE2;
            STAGE2: next_state = DONE;
            DONE: next_state = rst ? RESET : DONE; // reset control signal
            default next_state = RESET; // Default case to avoid latches
        endcase
    end
    // FSM state transition
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= RESET;
        end else begin
            current_state <= next_state;
        end
    end
    // Output logic based on the current state
    always_ff @(posedge clk) begin
        case (current_state)
            RESET: begin
                done <= 0;
                out0 <= 0;
                out1 <= 0;
                out2 <= 0;
                out3 <= 0;
            end
            STAGE1: begin
                done <= 0;
                bf_in0 <= in0;
                bf_in1 <= in2;
                bf_in2 <= in1;
                bf_in3 <= in3;
                tw_even <= W0; // Twiddle factor for even indices
                tw_odd <= W0;  // Twiddle factor for odd indices
                s1_e0 <= bf1_out1;
                s1_e1 <= bf1_out2;
                s1_o0 <= bf2_out1;
                s1_o1 <= bf2_out2;
            end
            STAGE2: begin
                done <= 0;
                bf_in0 <= s1_e0; 
                bf_in1 <= s1_o0; 
                bf_in2 <= s1_e1; 
                bf_in3 <= s1_o1;
                tw_even <= W0; // Twiddle factor for even indices
                tw_odd <= W1;  // Twiddle factor for odd indices
            end
            DONE: begin
                // Assign final outputs
                out0 <= bf1_out1;
                out2 <= bf1_out2;
                out1 <= bf2_out1;
                out3 <= bf2_out2;
                done <= 1; // Output is valid when done
            end
        endcase
    end
endmodule