module register_file(
    Clk  ,
    WEN  ,
    RW   ,
    busW ,
    RX   ,
    RY   ,
    busX ,
    busY
);
// region: I/O
input        Clk, WEN;
input  [2:0] RW, RX, RY;
input  [7:0] busW;
output [7:0] busX, busY;
    
// region: spec

// the register file has 8 registers, each 8-bit wide
// the register file has 2 read ports and 1 write port
// the register file has 1 write enable signal

// region: variable

reg [7:0] regfile [7:0] = 
reg [7:0] regfile_next [7:0];

integer i;
    

// region: assign

assign busX = regfile[RX];
assign busY = regfile[RY];

// region: always
always @(posedge Clk) begin
    // default
    // using for loop
    for (i = 0; i < 8; i = i + 1) begin
        regfile_next[i] = regfile[i];
    end

    if (WEN) begin
        regfile_next[RW] = busW;
    end
    else begin
        regfile_next[RW] = regfile[RW];
    end
end

// region: sequential
always @(posedge Clk) begin
    for (i = 0; i < 8; i = i + 1) begin
        regfile[i] <= regfile_next[i];
    end
end

endmodule
