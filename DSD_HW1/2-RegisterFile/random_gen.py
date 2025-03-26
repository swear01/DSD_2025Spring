# Generate random data for testing register file
# Have 5 columns: wen, rw, rx, ry, bus_w
# wen: bool, rw: 3-bit, rx: 3-bit, ry: 3-bit, bus_w: 8-bit

import random

N = 1000
test_data = []
# First, initialize the register file with 0 
for i in range(8):
    test_data.append([1, i, 0, 0, 0])

# Generate random data for testing register file
for i in range(N):
    wen = random.choice([0, 1])
    rw = random.randint(0, 7)
    rx = random.randint(0, 7)
    ry = random.randint(0, 7)
    bus_w = random.randint(0, 255)
    test_data.append([wen, rw, rx, ry, bus_w])

# Write to file
with open("test_data.txt", "w") as f:
    for data in test_data:
        f.write(" ".join(map(str, data)) + "\n")