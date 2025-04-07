// Single Cycle CPU Immediate Generator

module Imm_Gen (
    input   [31:0]      instruction,
    output  [31:0]  reg imm
);

    
// region: I/O

// region: spec

// region: param

// to implement: I-type, S-type, B-type, U-type, J-type
// lw   0000011 I-type
// sw   0100011 S-type
// beq  1100011 B-type
// jal  1101111 U-type
// jalr 1100111 J-type

// region: func

// region: variable

// region: modules

// region: assign

// region: comb
// TODO: implement by seperating into parts
always @(*) begin
    case(instruction[6:0]) //synopsys full_case parallel_case
        7'b0000011: // I-type
            imm = {{20{instruction[31]}}, instruction[30:20]};
        7'b0100011: // S-type
            imm = {{20{instruction[31]}}, instruction[30:25], instruction[11:7]};
        7'b1100011: // B-type
            imm = {{19{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        7'b1101111: // U-type
            imm = {instruction[31:12], 12'b0};
        7'b1100111: // J-type
            imm = {{11{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
        default: 
            imm = 32'b0; 
    endcase
end

// region: sequential

endmodule