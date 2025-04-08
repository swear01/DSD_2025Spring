// The testbench feeds initial instruction and data and checks the result of data memory.d

`timescale 1 ns/10 ps

`define CYCLE 3.8 // You can modify your clock frequency
`define END_CYCLE 30 // You can modify your maximum cycles

`include "memory.v"
`define DMEM_DATA "./pattern/data.txt"
`define DMEM_ANS  "./pattern/ans.txt"

`define IMEM_INIT "./pattern/inst_RV32I.txt"

`ifdef RTL
    `include "CHIP.v"
    `include "core.v"
`endif
`ifdef SYN
    `include "CHIP_syn.v"
    `include "tsmc13.v"
    `define SDF
    `define SDFFILE "./CHIP_syn.sdf"
`endif


module RISCV_tb;

    reg         clk, rst_n ;
    
    wire        mem_wen_D  ;
    wire [31:0] mem_addr_D ;
    wire [31:0] mem_wdata_D;
    wire [31:0] mem_rdata_D;
    
    wire [31:0] mem_addr_I ;
    wire [31:0] mem_rdata_I;
    
    reg  [31:0] mem_data_ans [0:31];

    integer i;
    
    integer eof;
    reg eof_find;

    integer error_num;
    
    // Note the design is connected at testbench, include:
    // 1. CHIP (RISCV + D_cache + I_chache)
    // 2. memory for data
    // 3. memory for instruction
    
    CHIP chip0(
        clk,
        rst_n);
       
    `ifdef SDF
        initial $sdf_annotate(`SDFFILE, chip0);
    `endif
    
    // Initialize the data memory
    initial begin
        $fsdbDumpfile("RISCV.fsdb");            
        $fsdbDumpvars(0,RISCV_tb,"+mda");

        $display("------------------------------------------------------------\n");
        $display("START!!! Simulation Start .....\n");
        $display("------------------------------------------------------------\n");
        
        clk = 1;
        rst_n = 1'b1;
        #(`CYCLE*2);
        #(0.1) rst_n = 1'b0;
        #(`CYCLE*2) rst_n = 1'b1;
        
        for (i=0; i<32; i=i+1) chip0.mem_D.mem[i]    = 32'h00_00_00_00; // reset data in mem_D
        $readmemh (`DMEM_DATA, chip0.mem_D.mem);                        // initialize data in mem_D
        for (i=0; i<32; i=i+1) mem_data_ans[i] = 32'h00_00_00_00;
        $readmemh (`DMEM_ANS , mem_data_ans);                     // answer lists
        $readmemh (`IMEM_INIT, chip0.mem_I.mem);                        // initialize data in mem_I
        eof_find = 0;
        for (i=0; i<32; i=i+1) begin
            if (chip0.mem_I.mem[i] === 32'bx) begin
                if (eof_find == 0) begin
                    eof_find = 1;
                    eof = i;
                end
                chip0.mem_I.mem[i] = 32'h33_00_00_00;
            end
        end

        #(`CYCLE*`END_CYCLE)
        $display("============================================================\n");
        $display("Simulation time is longer than expected.");
        $display("The test result is .....FAIL :(\n");
        $display("============================================================\n");
        $finish;
    end

    always @(negedge clk) begin
        if (chip0.core0.mem_addr_I[6:2] >= eof) begin
            error_num = 0;
            for (i=0; i<32; i=i+1) begin
                if (chip0.mem_D.mem[i] !== mem_data_ans[i]) begin
                    if (error_num == 0)
                        $display("Error!");
                    error_num = error_num + 1;
                    $display("  Addr = 0x%2h  Correct ans: 0x%h  Your ans: 0x%h", 4*i, mem_data_ans[i], chip0.mem_D.mem[i]);
                end
            end
            if (error_num > 0) begin
                $display(" ");
                $display("============================================================\n");
                $display("There are total %4d errors in the data memory", error_num);
                $display("The test result is .....FAIL :(\n");
                $display("============================================================\n");
            end
            else begin
                $display("============================================================\n");
                $display("Success!");
                $display("The test result is .....PASS :)\n");
                $display("============================================================\n");
            end
            $finish;
        end
    end
        
    always #(`CYCLE*0.5) clk = ~clk;
        
endmodule
