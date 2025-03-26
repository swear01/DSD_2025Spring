//RTL level (event-driven) 
module alu_always(
    ctrl,
    x,
    y,
    carry,
    out 
);
    
// region: I/O
input      [3:0]    ctrl;
input      [7:0]    x;
input      [7:0]    y;
output reg          carry;
output reg [7:0]    out;


// region: spec
// 0000 Add (signed)    out = x + y   
// 0001 Sub (signed)    out = x - y   
// 0010 Bitwise And     out = and(x, y) 
// 0011 Bitwise Or      out = or(x , y) 
// 0100 Bitwise Not     out = not(x) 
// 0101 Bitwise Xor     out = xor(x , y) 
// 0110 Bitwise Nor     out = nor(x , y) 
// 0111 Shift left logical variable     out = y << x[2:0] 
// 1000 Shift right logical variable    out = y >> x[2:0] 
// 1001 Shift right arithmetic          out ={x[7],x[7:1]} 
// 1010 Rotate left     out = {x[6:0] , x[7]} 
// 1011 Rotate right    out = {x[0] , x[7:1]} 
// 1100 Equal           out = (x==y) == 1:0 
// 1101 NOP (No operation) out = 0 
// 1110 NOP (No operation) out = 0 
// 1111 NOP (No operation) out = 0 


// region: param

// region: func

// region: variable

// region: assign

// region: always
always @(*) begin
    case(ctrl)
        4'b0000: out = x + y;
        4'b0001: out = x - y;
        4'b0010: out = x & y;
        4'b0011: out = x | y;
        4'b0100: out = ~x;
        4'b0101: out = x ^ y;
        4'b0110: out = ~(x | y);
        4'b0111: out = y << x[2:0];
        4'b1000: out = y >> x[2:0];
        4'b1001: out = {x[7], x[7:1]};
        4'b1010: out = {x[6:0], x[7]};
        4'b1011: out = {x[0], x[7:1]};
        4'b1100: out = (x == y) ? 8'b1 : 8'b0;
        4'b1101: out = 8'b0;
        4'b1110: out = 8'b0;
        4'b1111: out = 8'b0;
        default: out = 8'b0;
    endcase
end
always @(*) begin
    case(ctrl)
        4'b0000, 4'b0001: carry = ( {x[7],x} + {y[7],y} ) >> 8;
        default: carry = 1'b0;
    endcase
end

// region: sequential
    

endmodule
