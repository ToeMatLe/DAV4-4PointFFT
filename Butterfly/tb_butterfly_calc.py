print("Enter your numbers in typical complex number format, e.g. 200+0j or 317+13j.")

A = complex(input("A >\t"))
B = complex(input("B >\t"))
W = complex(input("W >\t"))

print(f"A+BW = {A + B*W}")
print(f"A-BW = {A - B*W}")

#test(10, 5, 20, 15, W0_RE, W0_IM, 30, 20, -10, -10); // A=10+5j, B=20+15j, W=1+0j => out0=30+20j, out1=-10-10j
#test(10, 5, 20, 15, W1_RE, W1_IM,  25, -15,  -5, 25); // A=10+5j, B=20+15j, W=0-1j => out0=25-15j, out1=-5+25j
#test(10, 5, 20, 15, W2_RE, W2_IM, -10, -10, 30, 20); // A=10+5j, B=20+15j, W=-1+0j => out0=-10-10j, out1=30+20j
#test(10, 5, 20, 15,  W3_RE, W3_IM,  -5, 25,  25, -15); // A=10+5j, B=20+15j, W=0+1j => out0=-5+25j, out1=25-15j
