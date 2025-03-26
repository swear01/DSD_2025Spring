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

wire [7:0] busX;
wire [7:0] busW;
wire [7:0] mux_out ;

assign mux_out = Sel ? busX : DataIn; // mux

// region: module  

register_file regfile(
    .Clk(Clk),
    .WEN(WEN),
    .RW(RW),
    .RX(RX),
    .RY(RY),
    .busW(busW),
    .busX(busX),
    .busY(busY)
);

alu_assign alu(
// alu_assign alu(
    .ctrl(Ctrl),
    .x(mux_out),
    .y(busY),
    .carry(Carry),
    .out(busW)
);    


endmodule
