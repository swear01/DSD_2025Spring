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

reg [7:0] regfile [7:0] ;
reg [7:0] regfile_next [7:0];
reg already_rst = 1'b0 ;

integer i;
    

// region: assign

assign busX = regfile[RX];
assign busY = regfile[RY];

// region: combitional
always @(*) begin
    // default
    // using for loop
    if (regfile[1][0] != 1'b0 && regfile[1][0] != 1'b1) begin
        for (i = 0; i < 8; i = i + 1) begin
            regfile_next[i] = 8'b0 ;
        end
    end
    else begin
        for (i = 1; i < 8; i = i + 1) begin
            regfile_next[i] = regfile[i];
        end
    
        if (WEN && RW != 3'b0) begin
            regfile_next[RW] = busW;
        end 
    end
end

// region: sequential
always @(posedge Clk) begin
    regfile[0] <= 8'b0 ;
    if (!already_rst ) begin
        already_rst <=  1'b1;
        for (i = 1; i < 8; i = i + 1) begin
            regfile[i] <= 8'b0 ;
        end
    end
    else begin
        for (i = 1; i < 8; i = i + 1) begin
            regfile[i] <= regfile_next[i];
        end
    end
end

endmodule
