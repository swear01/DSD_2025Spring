class RegisterFile:
    def __init__(self):
        self.regfile = [0] + [255]* 7  # 8 registers, each 8-bit wide

    def read(self, rx, ry) -> tuple[int, int]: # bus_x and bus_y
        """Read values from registers RX and RY."""
        return self.regfile[rx], self.regfile[ry]

    def write(self, wen, rw, bus_w):
        """Write value to register RW if write enable (WEN) is set."""
        if wen and rw != 0: # RW0 is hardwired to 0
            self.regfile[rw] = bus_w & 0xFF  # Ensure 8-bit storage

    def step(self, wen, rw, rx, ry, bus_w):
        """Read values from registers RX and RY, then write to register RW."""
        # Write have 1 cycle delay, so read first
        out = self.read(rx, ry)
        self.write(wen, rw, bus_w)
        return out

# Generate golden reference

with open("test_data.txt", "r") as f:
    test_data = f.readlines()

rf = RegisterFile()
golden_ref = []
for data in test_data:
    data = list(map(int, data.split()))
    out = rf.step(*data)
    golden_ref.append([*data, *out])

with open("reg.data", "w") as f:
    for data in golden_ref:
        # wen rw rx ry bus_w bus_x bus_y
        f.write(f'{data[0]:1b} {data[1]:3b} {data[2]:3b} {data[3]:03b} {data[4]:08b} {data[5]:08b} {data[6]:08b}\n')

