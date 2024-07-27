`timescale 1 ns / 1 ns

module testbench();

parameter WIDTH=32;
parameter DEPTH=1<<9;

parameter MAIN_FRE   = 100; //unit MHz
reg                   sys_clk = 0;
reg                   sys_rst = 1;

always begin
    #(500/MAIN_FRE) sys_clk = ~sys_clk;
end

always begin
    #10 sys_rst = 0;
end

//Instance 
// outports wire
wire             	i_tready;
wire [WIDTH-1:0] 	o_tdata;
wire             	o_tvalid;
wire [15:0]      	space;
wire [15:0]      	occupied;

reg                 clear;
reg [WIDTH-1:0]     i_tdata;
reg                 i_tvalid;
reg                 o_tready;

 initial begin
        // Initialize inputs
        clear = 0;
        i_tdata = 0;
        i_tvalid = 0;
        o_tready = 0;

         // Write data to the FIFO
        @(negedge sys_clk);
        i_tdata = 32'hA5A5A5A5;
        i_tvalid = 1;
        @(negedge sys_clk);
        i_tdata = 32'h5A5A5A5A;
        i_tvalid = 1;
        @(negedge sys_clk);
        i_tdata = 32'h12345678;
        i_tvalid = 1;
        @(negedge sys_clk);
        i_tvalid = 0;

        // Assert clear signal
        @(negedge sys_clk);
        clear = 1;
        @(negedge sys_clk);
        clear = 0;

        // Check FIFO status after clear
        @(negedge sys_clk);
        o_tready = 1;
        @(posedge o_tvalid);
        @(negedge sys_clk);
        o_tready = 0;

        // Wait a few cycles
        #50;

        // Write data to the FIFO again
        @(negedge sys_clk);
        i_tdata = 32'hDEADBEEF;
        i_tvalid = 1;
        @(negedge sys_clk);
        i_tvalid = 0;

        // Read data from the FIFO
        @(negedge sys_clk);
        o_tready = 1;
        @(posedge o_tvalid);
        @(negedge sys_clk);
        o_tready = 0;

        // Wait and finish simulation
        #100;
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time: %0d, reset = %b, clear = %b, i_tdata = %h, i_tvalid = %b, i_tready = %b, o_tdata = %h, o_tvalid = %b, o_tready = %b, space = %d, occupied = %d",
            $time, sys_rst, clear, i_tdata, i_tvalid, i_tready, o_tdata, o_tvalid, o_tready, space, occupied);
    end

sync_fifo_test #(
	.WIDTH 	( WIDTH         ),
	.DEPTH 	( DEPTH         ))
u_sync_fifo_test(
	.clock    	( sys_clk   ),
	.reset    	( sys_rst   ),
	.clear    	( clear     ),
	.i_tdata  	( i_tdata   ),
	.i_tvalid 	( i_tvalid  ),
	.i_tready 	( i_tready  ),
	.o_tdata  	( o_tdata   ),
	.o_tvalid 	( o_tvalid  ),
	.o_tready 	( o_tready  ),
	.space    	( space     ),
	.occupied 	( occupied  )
);

initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, testbench);    
    #50000 $finish;
end

endmodule  //TOP
