// Single Cycle RISC-V CPU  
// Author: Swear01
module core(clk,
            rst_n,
            // for mem_D
            mem_wen_D,
            mem_addr_D,
            mem_wdata_D,
            mem_rdata_D,
            // for mem_I
            mem_addr_I,
            mem_rdata_I
    );
    
    // region: I/O
    input         clk, rst_n ;
    // for mem_D
    output        mem_wen_D  ;  // mem_wen_D is high, core writes data to D-mem; else, core reads data from D-mem
    output [31:0] mem_addr_D ;  // the specific address to fetch/store data 
    output [31:0] mem_wdata_D;  // data writing to D-mem 
    input  [31:0] mem_rdata_D;  // data reading from D-mem
    // for mem_I
    output [31:0] mem_addr_I ;  // the fetching address of next instruction
    input  [31:0] mem_rdata_I;  // instruction reading from I-mem
    
    // region: spec

    // Support instructions:add, sub, and, or, slt, lw, sw, beq, jal, jalr
    // Data Memory and Instruction Memory are implemented outside.  
    // Only 32 words of data memory and instruction memory are addressed.  
    // Data memory and instruction memory are little-endian.  
    // Please Follow RV32I Standard.  
    
    // region: param  
    
    // region: func
    
    // region: variable
    wire [31:0] instruction; // alias of mem_rdata_I
    wire [31:0] reg_write_data; // data to be written to register file
    wire [31:0] d_mem_mux;
    wire [31:0] alu_data_2;  // data2 for ALU
    wire [31:0] pc_next ;    // next pc
    wire [31:0] pc_mux ;     // pc mux output
    wire [31:0] pc_add4;     // pc + 4
    wire [31:0] adder_sum;   // adder sum
    
    // Registers
    reg [31:0] pc;          // program counter  


    
    // region: modules
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    register regfile0(
        .clk(clk), 
        .rst_n(rst_n), 
        .read_reg1(instruction[19:15]), 
        .read_reg2(instruction[24:20]),
        .write_reg(instruction[11:7]),
        .write_data(reg_write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );


    wire jalr, jal, branch, mem_read, mem_write;
    wire mem_to_reg, alu_src, reg_write;
    Control ctrl0(
        .instruction(instruction[6:0]),
        .jalr(jalr),
        .jal(jal),
        .branch(branch),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );

    wire [3:0] alu_ctrl;
    ALU_control alu_control0(
        .op_43(instruction[4:3]),
        .funct3(instruction[14:12]),
        .funct7_5(instruction[30]),
        .alu_ctrl(alu_ctrl)
    );
        
    wire [31:0] alu_result;
    wire        alu_zero;
    ALU alu0(
        .data1(read_data1),
        .data2(alu_data_2),
        .alu_ctrl(alu_ctrl),
        .zero(alu_zero),
        .result(alu_result)
    );

    wire [31:0] imm;
    Imm_Gen imm_gen0(
        .instruction(instruction),
        .imm(imm)
    );

    
    // region: assign
    assign instruction = mem_rdata_I; // alias
    assign pc_add4 = pc + 4;
    assign adder_sum = pc + imm;
    assign mem_addr_I = pc;
    assign mem_addr_D = alu_result;
    assign mem_wen_D = mem_write;

    //muxes
    assign next_pc = (jalr) ? (read_data1 + imm) : pc_add4;
    assign pc_mux = (jal | branch & alu_zero) ? adder_sum : pc_add4;
    assign d_mem_mux = (mem_read) ? mem_rdata_D : alu_result;
    assign alu_data_2 = (alu_src) ? imm : read_data2;
    assign reg_write_data = (jal | jalr) ? pc_add4 : d_mem_mux;
    // region: comb
    
    // region: sequential
    
endmodule

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

// Single Cycle RISC-V CPU ALU Control Unit  

module ALU_control (
    op,
    funct3,
    funct7,
    alu_ctrl
);
    // region: I/O

    input   [4:3] op_43; //only need 2 bits
    input   [2:0] funct3;
    input   [5:5] funct7_5; //only need 5th bit
    output  [3:0] alu_ctrl;

    // region: spec

    //    ALUCtrl[0] = OP[4] & funct3[2] & funct3[1] & (!funct3[0])
    //    ALUCtrl[1] = !(OP[4] & (!OP[3]) & funct3[1])
    //    ALUCtrl[2] = ((!OP[4]) & (!funct3[1])) | (funct7[5] & OP[4])
    //    ALUCtrl[3] = OP[4] & (!funct3[2]) & funct3[1]

    // Code Functions   Instructions
    // 0000 AND         AND
    // 0001 OR          OR
    // 0010 ADD         SW, LW
    // 0110 SUBSTRACT   SUB, Branch
    // 1000 SLT         SL

    // region: param

    // region: func

    // region: variable

    // region: modules

    // region: assign
    assign alu_ctrl[0] = op_43[4] & funct3[2] & funct3[1] & (!funct3[0]);
    assign alu_ctrl[1] = !(op_43[4] & (!op_43[3]) & funct3[1]);
    assign alu_ctrl[2] = ((!op_43[4]) & (!funct3[1])) | (funct7_5 & op_43[4]);
    assign alu_ctrl[3] = op_43[4] & (!funct3[2]) & funct3[1];

    // region: comb

    // region: sequential

    
endmodule

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
