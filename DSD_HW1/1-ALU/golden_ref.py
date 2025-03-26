def alu_golden(ctrl, x, y):
    carry = 0
    if ctrl == 0b0000:  # Addition with carry
        result = (x + y) & 0xFF  # Ensure 8-bit result
        carry = ((x + y) >> 8) & 1
    elif ctrl == 0b0001:  # Subtraction with carry
        result = (x - y) & 0xFF
        carry = ((x - y) >> 8) & 1
    elif ctrl == 0b0010:  # Bitwise AND
        result = x & y
    elif ctrl == 0b0011:  # Bitwise OR
        result = x | y
    elif ctrl == 0b0100:  # Bitwise NOT of x
        result = (~x) & 0xFF
    elif ctrl == 0b0101:  # Bitwise XOR
        result = x ^ y
    elif ctrl == 0b0110:  # NOR
        result = (~(x | y)) & 0xFF
    elif ctrl == 0b0111:  # Left shift y by lower 3 bits of x
        result = (y << (x & 0b111)) & 0xFF
    elif ctrl == 0b1000:  # Right shift y by lower 3 bits of x
        result = (y >> (x & 0b111)) & 0xFF
    elif ctrl == 0b1001:  # Arithmetic right shift x
        result = ((x & 0x80) | (x >> 1)) & 0xFF
    elif ctrl == 0b1010:  # Left rotate x
        result = ((x << 1) | ((x >> 7) & 1)) & 0xFF
    elif ctrl == 0b1011:  # Right rotate x
        result = ((x >> 1) | ((x & 1) << 7)) & 0xFF
    elif ctrl == 0b1100:  # Equality comparison
        result = 1 if x == y else 0
    elif ctrl in (0b1101, 0b1110, 0b1111):  # Always 0 for these cases
        result = 0
    else:
        result = 0  # Default case
    
    return carry, result


# Generating Data  
N = 4
data = []
from random import randint
for ctrl in range(16):
    for _ in range(N):
        x = randint(0, 255)
        y = randint(0, 255)
        carry, result = alu_golden(ctrl, x, y)
        data.append((ctrl, x, y, carry, result))

# Writing Data
with open('alu.data', 'w') as f:
    for ctrl, x, y, carry, result in data:
        f.write(f'{ctrl:04b} {x:08b} {y:08b} {carry} {result:08b}\n')
    