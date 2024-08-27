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
parameter    DIRECTION    = "LSB";

parameter MAIN_FRE   = 100; //unit MHz
reg                   sys_clk = 0;
reg                   sys_rst = 1;

always begin
    #(500/MAIN_FRE) sys_clk = ~sys_clk;
end

always begin
    #50 sys_rst = 0;
end

//Instance 
// outports wire
wire                      	valid;
wire [OUTPUT_WIDTH-1:0]   	dout;
wire                      	full;
wire                      	empty;
wire [$clog2(WR_DEPTH) : 0] wr_data_count;
wire [$clog2(RD_DEPTH) : 0] rd_data_count;
wire [$clog2(WR_DEPTH) : 0] wr_data_space;
wire [$clog2(RD_DEPTH) : 0] rd_data_space;

reg							wr_en;
reg							rd_en;
reg	 [INPUT_WIDTH-1:0]		din;

initial begin
	wr_en = 1'b0;
	rd_en = 1'b0;

	#100

	@(posedge sys_clk);
	wr_en = 1'b1;
	rd_en = 1'b0;

	#(WR_DEPTH * 12)

	@(posedge sys_clk);
	wr_en = 1'b0;
	rd_en = 1'b0;

	#200

	@(posedge sys_clk);
	wr_en = 1'b0;
	rd_en = 1'b1;

	#30

	@(posedge sys_clk);
	wr_en = 1'b0;
	rd_en = 1'b0;

	#215

	@(posedge sys_clk);
	wr_en = 1'b0;
	rd_en = 1'b1;

	#(RD_DEPTH * 22)

	@(posedge sys_clk);
	wr_en = 1'b0;
	rd_en = 1'b0;
end

always @(posedge sys_clk or negedge sys_rst) begin
	if(sys_rst == 1'b1)begin
		din <= 16'h0123;
	end
	else if(wr_en)begin
		din[7:0]   <= din[7:0]   + 1'b1;
		din[15:8]  <= din[15:8]  + 1'b1;
		//din[23:16] <= din[23:16] + 1'b1;
		//din[31:24] <= din[31:24] + 1'b1;
		//din[39:32] <= din[39:32] + 1'b1;
		//din[47:40] <= din[47:40] + 1'b1;
		//din[55:48] <= din[55:48] + 1'b1;
		//din[63:56] <= din[63:56] + 1'b1;
	end
end

always @(posedge sys_clk) begin
	if(wr_en & (~full))
		$display("the write data is %h\t the write_count is %d",din,wr_data_count);
end

always @(posedge sys_clk) begin
	if(valid)
		$display("the read data is %h\t the read_count is %d",dout,rd_data_count);
end

sync_fifo #(
	.INPUT_WIDTH  	( INPUT_WIDTH    ),
	.OUTPUT_WIDTH 	( OUTPUT_WIDTH   ),
	.WR_DEPTH     	( WR_DEPTH       ),
	.RD_DEPTH     	( RD_DEPTH       ),
	.MODE         	( MODE			 ),
	.DIRECTION    	( "LSB"			 ))
CP_fifo(
	.clock       	( sys_clk        ),
	.reset       	( sys_rst        ),
	.wr_en         	( wr_en			 ),
	.din           	( din		     ),
	.rd_en         	( rd_en		     ),
	.valid         	( valid          ),
	.dout          	( dout		     ),
	.full          	( full           	 ),
	.empty         	( empty          	 ),
	.wr_data_count 	( wr_data_count      ),
	.rd_data_count 	( rd_data_count      ),
	.wr_data_space  ( wr_data_space      ),
	.rd_data_space  ( rd_data_space	     )
);

initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, tb_sync_fifo);    
    #50000 $finish;
end

endmodule  //TOP
