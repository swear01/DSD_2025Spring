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

    register regfile0(clk=clk, rst_n=rst_n, 
        read_reg1 = instruction[19:15], 
        read_reg2 = instruction[24:20],
        write_reg = instruction[11:7],
        write_data= reg_write_data,
        reg_write = reg_write,
        read_data1= read_data1,
        read_data2= read_data2
    );


    wire jalr, jal, branch, mem_read, mem_write;
    wire mem_to_reg, alu_src, reg_write;
    Control ctrl0(
        instruction = instruction[6:0],
        jalr        = jalr,
        jal         = jal,
        branch      = branch,
        mem_read    = mem_read,
        mem_write   = mem_write,
        mem_to_reg  = mem_to_reg,
        alu_src     = alu_src,
        reg_write   = reg_write
    );

    wire [3:0] alu_ctrl;
    ALU_control alu_control0(
        op_43    = instruction[ 4: 3],
        funct3   = instruction[14:12],
        funct7_5 = instruction[30:30],
        alu_ctrl = alu_ctrl
    );
        
    wire [31:0] alu_result;
    wire        alu_zero;
    ALU alu0(
        data1    = read_data1,
        data2    = alu_data_2,
        alu_ctrl = alu_ctrl,
        zero     = alu_zero,
        result   = alu_result
    );

    wire [31:0] imm;
    Imm_Gen imm_gen0(
        instruction = instruction,
        imm         = imm
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