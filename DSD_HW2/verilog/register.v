// Single Cycle RISC-V CPU Register File

module register( 
    clk,
    rst_n,
    read_reg1,
    read_reg2,
    write_reg,
    write_data,
    reg_write,
)

    input                   clk;
    input                   rst_n;
    input                   reg_write;
    input  [4:0]            read_reg1;
    input  [4:0]            read_reg2;
    input  [4:0]            write_reg;
    input  [31:0]           write_data;

    output [31:0]           read_data1;
    output [31:0]           read_data2;

    // region: I/O
    
    // region: spec
    
    // region: param
    
    // region: func
    
    // region: variable
    reg [31:0] regfile      [0:31];
    reg [31:0] regfile_next [1:31];
    
    // region: modules
    
    // region: assign
    assign read_data1 = regfile[read_reg1];
    assign read_data2 = regfile[read_reg2];
    
    // region: comb
    always @(*) begin
        for (int i = 1; i < 32; i = i + 1) begin
            regfile_next[i] = regfile[i];
        end
        if (reg_write && (write_reg != 5'b0)) begin 
            // x0 is hardwired to 0
            regfile_next[write_reg] = write_data;
        end 
    end
        
    
    // region: sequential
    // synchronous reset
    genvar i;
    always @(posedge clk) begin
        if (~rst_n) begin // reset
            for (i = 0; i < 32; i = i + 1) begin
                regfile[i] <= 32'h0;
            end
        end else begin
            for (i = 1; i < 32; i = i + 1) begin
                regfile[i] <= regfile_next[i];
            end
        end
    end

endmodule
