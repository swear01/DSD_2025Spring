module simple_calculator(
    Clk,
    WEN,
    RW,
    RX,
    RY,
    DataIn,
    Sel,
    Ctrl,
    busY,
    Carry
);

// region: I/O

    input        Clk;
    input        WEN;
    input  [2:0] RW, RX, RY;
    input  [7:0] DataIn;
    input        Sel;
    input  [3:0] Ctrl;
    output [7:0] busY;
    output       Carry;

// region: spec
// reference spec to the submodules

// region: variable

reg [7:0] busX;
reg [7:0] alu_x ;

assign alu_x = Sel ? busY : DataIn; // mux

// region: module  

register_file regfile(
    .Clk(Clk),
    .WEN(WEN),
    .RW(RW),
    .RX(RX),
    .RY(RY),
    .busW(DataIn),
    .busX(busX),
    .busY(busY)
);

alu_always alu(
// alu_assign alu(
    .ctrl(Ctrl),
    .x(alu_x),
    .y(DataIn),
    .carry(Carry),
    .out(busY)
);    


endmodule
