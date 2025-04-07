// Single Cycle RISC-V CPU ALU  

module ALU(
    input       [31:0] data1,
    input       [31:0] data2,
    input       [ 3:0] alu_ctrl,
    output reg  [31:0] result
    output             zero
)

    // region: I/O

    // region: spec
    // To implement: add, sub, and, or, slt


    // Code Functions   Instructions
    // 0000 AND         AND
    // 0001 OR          OR
    // 0010 ADD         SW, LW
    // 0110 SUBSTRACT   SUB, Branch
    // 1000 SLT         SLT

    // region: param

    // region: func

    // region: variable
    genvar i;  
    wire [31:0] temp;


    // region: modules

    // region: assign
    assign zero = ((~ read_data1 ^ read_data2)== 32'b0) ;

    // region: comb
    always @(*) begin
        case(alu_ctrl) //synopsys full_case parallel_case
            4'b0000: temp = data1 & data2;
            4'b0001: temp = data1 | data2;
            4'b0010: temp = data1 + data2;
            4'b0110: temp = data1 - data2;
            4'b1000: temp = (data1 < data2) ? 32'b1 : 32'b0;
            default: temp = 32'b0;
        endcase
    end

    // region: sequential

endmodule