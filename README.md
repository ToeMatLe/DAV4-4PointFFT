# 4-Point FFT – Lab 4

## Overview

This project implements a 4-point radix-2 Decimation-In-Time (DIT) FFT in SystemVerilog.

The design includes:
- Two reusable butterfly modules
- A 4-state FSM (RESET → STAGE1 → STAGE2 → DONE)
- Fixed-point complex arithmetic (Q1.15 format)
- Parameterized data width (default: 32 bits)

Each complex number is stored as:
- [31:16] → Real part (signed 16-bit)
- [15:0]  → Imaginary part (signed 16-bit)

---

## FFT Architecture

A 4-point FFT requires 2 stages.

### Stage 1

Even branch:
(in0, in2)

Odd branch:
(in1, in3)

Twiddle factor:
W0 = 1

Results:
E0 = in0 + in2
E1 = in0 - in2

O0 = in1 + in3
O1 = in1 - in3

---

### Stage 2

Butterfly 1:
A = E0
B = O0
W = 1

Butterfly 2:
A = E1
B = O1
W = -j

Final outputs:
X0 = E0 + O0
X2 = E0 - O0

X1 = E1 + O1·(-j)
X3 = E1 - O1·(-j)

---

## FSM States

RESET
- Clears outputs
- Waits for start signal

STAGE1
- Computes first butterfly stage

STAGE2
- Computes second butterfly stage

DONE
- Outputs valid
- done = 1

For an N-point FFT:
Number of stages = log2(N)

---

## Fixed-Point Representation (Q1.15)

Twiddle factors are scaled by 2^15.

W0 =  1 + j0   = {32767, 0}
W1 =  0 - j1   = {0, -32768}
W2 = -1 + j0   = {-32768, 0}
W3 =  0 + j1   = {0, 32767}

Only W0 and W1 are required for the 4-point FFT.

After complex multiplication, the lower 15 bits are truncated per lab specification.

---

## Modules

### butterfly.sv

Computes:
out0 = A + B·W
out1 = A - B·W

Fully combinational.

---

### fft4.sv

- Reuses two butterfly modules
- Uses FSM control
- Stores stage 1 outputs in registers
- Asserts done when FFT completes

---

## Test Case

Input:
in0 = 100
in1 = 150
in2 = 200
in3 = 250

Expected Output:
out0 =  700 + 0j
out1 = -100 + 100j
out2 = -100 + 0j
out3 = -100 - 100j

---

## Summary

This implementation:
- Correctly computes a 4-point FFT
- Uses fixed-point signed arithmetic
- Efficiently reuses hardware
- Matches expected lab outputs
