//RTL (use continuous assignment)
module alu_assign(
    ctrl,
    x,
    y,
    carry,
    out  
);
    
    input       [3:0]   ctrl;
    input       [7:0]   x;
    input       [7:0]   y;
    output wire         carry;
    output wire [7:0]   out;

// specs

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

//region: function

//sign extension
// 8-bit to 9-bit
// function [8:0] extend;
//     input [7:0] x;
//     begin
//         extend = {x[7], x};
//     end
    
// endfunction


// region: variable

// region: assignment

assign out =    ctrl == 4'b0000 ? x + y :
                ctrl == 4'b0001 ? x - y :
                ctrl == 4'b0010 ? x & y :
                ctrl == 4'b0011 ? x | y :
                ctrl == 4'b0100 ? ~x :
                ctrl == 4'b0101 ? x ^ y :
                ctrl == 4'b0110 ? ~(x | y) :
                ctrl == 4'b0111 ? y << x[2:0] :
                ctrl == 4'b1000 ? y >> x[2:0] :
                ctrl == 4'b1001 ? {x[7], x[7:1]} :
                ctrl == 4'b1010 ? {x[6:0], x[7]} :
                ctrl == 4'b1011 ? {x[0], x[7:1]} :
                ctrl == 4'b1100 ? (x == y) :
                ctrl == 4'b1101 ? 8'b0 :
                ctrl == 4'b1110 ? 8'b0 :
                8'b0 ; // ctrl == 4'b1111

assign carry = ( {x[7],x} + {y[7],y} ) >> 8;

// region: comb logic






// region: seq logic

// not exist in this module

endmodule
