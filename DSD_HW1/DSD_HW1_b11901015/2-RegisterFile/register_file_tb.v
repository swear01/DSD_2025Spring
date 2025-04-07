`timescale 1ns/10ps
`define CYCLE  10
`define HCYCLE  5
`define NULL 0 

module register_file_tb;
    // port declaration for design-under-test
    reg  Clk=0, WEN;
    reg  [2:0] RW, RX, RY;
    reg  [7:0] busW;
    wire [7:0] busX, busY;
    
    // instantiate the design-under-test
    register_file rf(
        Clk  ,
        WEN  ,
        RW   ,
        busW ,
        RX   ,
        RY   ,
        busX ,
        busY
    );

    integer data_file;
    integer num_fail = 0 ;
    integer iteration = 0 ;
    reg [7:0] golden_busX;
    reg [7:0] golden_busY;

    //clock
    always begin
        #(`HCYCLE) Clk = ~Clk ;
    end

    initial begin
        $fsdbDumpfile("register.fsdb");
        $fsdbDumpvars;
    end
 
    initial begin
        data_file = $fopen("reg.data", "r");
        if (data_file == `NULL) begin
            $display("data_file handle was NULL");
            $finish;
        end
    end

    // main loop
    always begin // main loop
        while (!$feof(data_file)) begin
            // read inputs
            $fscanf(data_file, "%b %b %b %b %b %b %b", WEN, RW, RX, RY, busW, golden_busX, golden_busY);
            // print inputs
            $display("Data: WEN=%b, RW=%b, RX=%b, RY=%b, busW=%b\n", WEN, RW, RX, RY, busW);
            // validate
            $display("Result: BusX=%b, BusY=%b; Golden_BusX=%b, Golden_BusY=%b\n", busX, busY, golden_busX, golden_busY);
            if (iteration >= 8) begin
                if( busX == golden_busX && busY == golden_busY ) begin
                    $display( "PASS\n" );
                end
                else begin
                    $display( "FAIL\n" );
                    num_fail = num_fail + 1 ;
                end
            end
            iteration = iteration + 1;
            // wait for 1 cycle
            #(`CYCLE);
        end
        $display("The number of fail case is %d.\n", num_fail) ;
        // finish tb
        $finish;
    end

    initial begin
        //timeout 
        #10000000 $finish;
    end

endmodule
