`timescale 1 ns / 1 ns

module tb_sync_fifo();

parameter    INPUT_WIDTH  = 16;
parameter    OUTPUT_WIDTH = 16;
/*
	The depth parameter of writing mem
	if INPUT_WIDTH < OUTPUT_WIDTH, WR_DEPTH = (OUTPUT_WIDTH/INPUT_WIDTH) * RD_DEPTH
*/
parameter    WR_DEPTH     = 16;
/*
	The depth parameter of reading mem
	if INPUT_WIDTH > OUTPUT_WIDTH, RD_DEPTH = (INPUT_WIDTH/OUTPUT_WIDTH) * WR_DEPTH
*/
parameter    RD_DEPTH     = 16;
//The parameter of reading method
parameter    MODE         = "FWFT";
//Is data stored from high bits or from low bits
parameter    DIRECTION    = "MSB";

parameter MAIN_FRE   = 100; //unit MHz
reg                   sys_clk = 0;
reg                   sys_rst;

always begin
    #(500/MAIN_FRE) sys_clk = ~sys_clk;
end

// always begin
//     #50 sys_rst = 0;
// end

//Instance 
// outports wire
reg							wr_en;
reg	 [INPUT_WIDTH-1:0]		din = 16'h0123;
wire [$clog2(WR_DEPTH) : 0] wr_data_count;
wire [$clog2(WR_DEPTH) : 0] wr_data_space;

reg							rd_en;
wire                      	valid;
wire [OUTPUT_WIDTH-1:0]   	dout;

wire                      	full;
wire                      	empty;

wire [$clog2(RD_DEPTH) : 0] rd_data_count;
wire [$clog2(RD_DEPTH) : 0] rd_data_space;

wire						almost_full;
wire						almost_empty;
wire						prog_full;
wire						prog_empty;
wire						overflow;
wire						underflow;
wire						wr_ack;
wire						sbiterr;
wire						dbiterr;

wire 						xpm_valid;
wire [OUTPUT_WIDTH-1:0] 	xpm_dout;
wire						xpm_full;
wire						xpm_empty;
wire [$clog2(WR_DEPTH) : 0] xpm_wr_data_count;
wire [$clog2(RD_DEPTH) : 0] xpm_rd_data_count;

task reset_normal;
begin
	sys_rst = 1'b1;
	#50
	sys_rst = 1'b0;
end
endtask

task reset_write;
begin
	sys_rst = 1'b1;
	#50
	sys_rst = 1'b0;
	#80
	sys_rst = 1'b1;
	#20
	sys_rst = 1'b0;
end
endtask

task reset_read;
begin
	sys_rst = 1'b1;
	#50
	sys_rst = 1'b0;
	#200
	sys_rst = 1'b1;
	#20
	sys_rst = 1'b0;
end
endtask

task reset_full;
begin
	sys_rst = 1'b1;
	#50
	sys_rst = 1'b0;
	#(WR_DEPTH * 12 + 80)
	sys_rst = 1'b1;
	#10
	sys_rst = 1'b0;
end
endtask

task reset_empty;
begin
	sys_rst = 1'b1;
	#50
	sys_rst = 1'b0;
	#(WR_DEPTH * 12 + RD_DEPTH * 22 + 160)
	sys_rst = 1'b1;
	#10
	sys_rst = 1'b0;
end
endtask

task separate;
begin
	wr_en = 1'b0;
	rd_en = 1'b0;

	#100
	@(posedge sys_clk);
	wr_en = 1'b1;

	#(WR_DEPTH * 12)
	@(posedge sys_clk);
	wr_en = 1'b0;

	#100
	@(posedge sys_clk);
	rd_en = 1'b1;

	#(RD_DEPTH * 22)
	@(posedge sys_clk);
	rd_en = 1'b0;
end
endtask

task simultaneous;
begin
	wr_en = 1'b0;
	rd_en = 1'b0;

	#100
	@(posedge sys_clk);
	wr_en = 1'b1;

	#50
	@(posedge sys_clk);
	rd_en = 1'b1;

	#(WR_DEPTH * 12)
	@(posedge sys_clk);
	wr_en = 1'b0;

	#(RD_DEPTH * 22)
	@(posedge sys_clk);
	rd_en = 1'b0;
end
endtask 

initial begin
	reset_normal();
end

initial begin
	simultaneous();
end

always @(posedge sys_clk) begin
	// if(sys_rst)begin
	// 	din <= 16'h0123;
	// end
	if(wr_en)begin
		din[7:0]   <= din[7:0]   + 1'b1;
		din[15:8]  <= din[15:8]  + 1'b1;
		// din[23:16] <= din[23:16] + 1'b1;
		// din[31:24] <= din[31:24] + 1'b1;
		// din[39:32] <= din[39:32] + 1'b1;
		// din[47:40] <= din[47:40] + 1'b1;
		// din[55:48] <= din[55:48] + 1'b1;
		// din[63:56] <= din[63:56] + 1'b1;
	end
end

always @(posedge sys_clk) begin
	if(wr_en & (~full))
		$display(" %h\t %d\t %d",din,wr_data_count,xpm_wr_data_count);
end

always @(posedge sys_clk) begin
	if(valid)
		$display(" %h\t %d\t %h\t %d",dout,rd_data_count,xpm_dout,xpm_rd_data_count);
end

sync_fifo #(
	.INPUT_WIDTH  	   ( INPUT_WIDTH    ),
	.OUTPUT_WIDTH 	   ( OUTPUT_WIDTH   ),
	.WR_DEPTH     	   ( WR_DEPTH       ),
	.RD_DEPTH     	   ( RD_DEPTH       ),
	.MODE         	   ( MODE			),
	.DIRECTION    	   ( DIRECTION		),
	.ECC_MODE          ( "no_ecc"	    ),
	.PROG_EMPTY_THRESH (  10            ),
	.PROG_FULL_THRESH  (  10			),
	.USE_ADV_FEATURES  ( 16'h1F1F		))
CP_fifo(
	.clock       	( sys_clk        	 ),
	.reset       	( sys_rst        	 ),
	.wr_en         	( wr_en			 	 ),
	.din           	( din		     	 ),
	.rd_en         	( rd_en		     	 ),
	.valid         	( valid          	 ),
	.dout          	( dout		     	 ),
	.full          	( full           	 ),
	.empty         	( empty          	 ),
	.wr_data_count 	( wr_data_count      ),
	.rd_data_count 	( rd_data_count      ),
	.wr_data_space  ( wr_data_space      ),
	.rd_data_space  ( rd_data_space	     ),
	.almost_full	( almost_full		 ),
    .almost_empty	( almost_empty		 ),
    .prog_full		( prog_full 		 ),
    .prog_empty		( prog_empty	 	 ),
    .overflow		( overflow			 ),
    .underflow		( underflow			 ),
    .wr_ack			( wr_ack		     ),
    .sbiterr		( sbiterr			 ),
    .dbiterr		( dbiterr			 )
);

xpm_fifo_sync #(
    .DOUT_RESET_VALUE("0"),    // String
    .ECC_MODE("no_ecc"),       // String
    .FIFO_MEMORY_TYPE("block"), // String
    .FIFO_READ_LATENCY(0),     // DECIMAL
    .FIFO_WRITE_DEPTH(WR_DEPTH),   // DECIMAL
    .FULL_RESET_VALUE(0),      // DECIMAL
    .PROG_EMPTY_THRESH(10),    // DECIMAL
    .PROG_FULL_THRESH(10),     // DECIMAL
    .RD_DATA_COUNT_WIDTH($clog2(RD_DEPTH)+1),   // DECIMAL
    .READ_DATA_WIDTH(OUTPUT_WIDTH),      // DECIMAL
    .READ_MODE("fwft"),         // String
    .USE_ADV_FEATURES("1404"), // only enable rd_data_count and wr_data_count
    .WAKEUP_TIME(0),           // DECIMAL
    .WRITE_DATA_WIDTH(INPUT_WIDTH),     // DECIMAL
    .WR_DATA_COUNT_WIDTH($clog2(WR_DEPTH)+1)    // DECIMAL
) fifo_1clk_for_running_sum_dual_ch_i (
    .almost_empty(),
    .almost_full(),
    .data_valid(xpm_valid),
    .dbiterr(),
    .dout(xpm_dout),
    .empty(xpm_empty),
    .full(xpm_full),
    .overflow(),
    .prog_empty(),
    .prog_full(),
    .rd_data_count(xpm_rd_data_count),
    .rd_rst_busy(),
    .sbiterr(),
    .underflow(),
    .wr_ack(),
    .wr_data_count(xpm_wr_data_count),
    .wr_rst_busy(),
    .din(din),
    .injectdbiterr(),
    .injectsbiterr(),
    .rd_en(rd_en),
    .rst(sys_rst),
    .sleep(),
    .wr_clk(sys_clk),
    .wr_en(wr_en)
  );

initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, tb_sync_fifo);    
    #50000 $finish;
end

endmodule  //TOP
