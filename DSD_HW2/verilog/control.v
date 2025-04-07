// Single Cycle RISC-V CPU Control Unit  
// Author: Swear01

module Control (
    instruction,
    jalr,
    jal,
    branch,
    mem_read,
    mem_write,
    mem_to_reg,
    alu_src,
    reg_write
)

    // region: I/O
    input           clk ;
    input           rst_n ;
    input [6:0]     instruction ;
    
    output          jalr ;
    output          jal ;
    output          branch ;
    output          mem_read ;
    output          mem_write ;
    output          mem_to_reg ;
    output          alu_src ;
    output          reg_write ;


    // region: spec
    // Support instructions:add, sub, and, or, slt, lw, sw, beq, jal, jalr
    // add sub and or slt 
    //      0110011 R
    // lw   0000011 I
    // sw   0100011 S
    // beq  1100011 SB
    // jal  1101111 UJ
    // jalr 1100111 I

    // region: param

    // region: func

    // region: variable

    // region: modules

    // region: assign
    assign jalr         = (instruction == 7'b1100111) ? 1'b1 : 1'b0 ;
    assign jal          = (instruction == 7'b1101111) ? 1'b1 : 1'b0 ;
    assign branch       = (instruction == 7'b1100011) ? 1'b1 : 1'b0 ;
    assign mem_read     = (instruction == 7'b0000011) ? 1'b1 : 1'b0 ;
    assign mem_write    = (instruction == 7'b0100011) ? 1'b1 : 1'b0 ;
    assign mem_to_reg   = (instruction == 7'b0000011) ? 1'b1 : 1'b0 ;
    // Only R-type requires alu_src = 0
    assign alu_src      = (instruction == 7'b0110011) ? 1'b0 : 1'b1 ;
    // While SW, disallow reg_write
    assign reg_write    = (instruction == 7'b0100011) ? 1'b0 : 1'b1 ;
    // alu_op
    

    // region: comb

    // region: sequential


endmodule