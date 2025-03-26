//continuous assignment tb
`timescale 1ns/10ps
`define CYCLE   10
`define HCYCLE  5
`define NULL 0 

module alu_assign_tb;
    reg  [3:0] ctrl;
    reg  [7:0] x;
    reg  [7:0] y;
    wire       carry;
    wire [7:0] out;
    
    alu_assign alu_assign(
        ctrl     ,
        x        ,
        y        ,
        carry    ,
        out  
    );

    integer data_file;
    reg [7:0] golden_out;
    reg       golden_carry;

   initial begin
       $fsdbDumpfile("alu_always.fsdb");
       $fsdbDumpvars;
   end

    initial begin
        data_file = $fopen("alu.data", "r");
        if (data_file == `NULL) begin
            $display("data_file handle was NULL");
            $finish;
        end
    end

    always begin // main loop
        // set inputs
        ctrl = 4'bx;
        x = 8'bx;
        y = 8'bx;

        // reset 

        while (!$feof(data_file)) begin
            // read inputs
            $fscanf(data_file, "%b %b %b %b %b", ctrl, x, y, golden_carry, golden_out);
            // print inputs
            $display("ctrl=%b x=%b y=%b", ctrl, x, y);
            // wait for 1 cycle
            // validate
            $display("carry, out=%b, %b, golden=%b, %b", carry, out, golden_carry, golden_out);
            if( carry == golden_carry && out == golden_out ) $display( "PASS\n" );
            else $display( "FAIL\n" );
            // wait for 1 cycle
            #(`CYCLE);
        end
        // finish tb
        $finish;
    end

    initial begin
        //timeout 
        #1000000 $finish;
    end

endmodule
