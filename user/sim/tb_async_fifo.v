`timescale 1ns / 1ps

module tb_async_fifo();

`define ef

parameter    INPUT_WIDTH  = 16;
parameter    OUTPUT_WIDTH = 128;
/*
	The depth parameter of writing mem
	if INPUT_WIDTH < OUTPUT_WIDTH, WR_DEPTH = (OUTPUT_WIDTH/INPUT_WIDTH) * RD_DEPTH
*/
parameter    WR_DEPTH     = 64;
/*
	The depth parameter of reading mem
	if INPUT_WIDTH > OUTPUT_WIDTH, RD_DEPTH = (INPUT_WIDTH/OUTPUT_WIDTH) * WR_DEPTH
*/
parameter    RD_DEPTH     = 8;
//The parameter of reading method
parameter    MODE         = "Standard";
//Is data stored from high bits or from low bits
parameter    DIRECTION    = "MSB";

parameter 	 WR_FRE     = 100; //unit MHz
parameter	 RD_FRE     = 50;
reg          wr_clk     = 0;
reg			 rd_clk     = 0;
reg          sys_rst    = 0;

always begin
    #(500/WR_FRE) wr_clk = ~wr_clk;
end

always begin
    #(500/RD_FRE) rd_clk = ~rd_clk;
end

always begin
    #50 sys_rst = 1;
end

//Instance 
// outports wire
wire                      	valid;
wire [OUTPUT_WIDTH-1:0]   	dout;
wire                      	full;
wire                      	empty;
wire [$clog2(WR_DEPTH):0] 	wr_data_count;
wire [$clog2(RD_DEPTH):0] 	rd_data_count;

reg							wr_en;
reg							rd_en;
reg	 [INPUT_WIDTH-1:0]		din;

initial begin
	wr_en = 1'b0;
	rd_en = 1'b0;
	#100
	wr_en = 1'b1;
	#(WR_DEPTH * 12)
	wr_en = 1'b0;
	#200
	rd_en = 1'b1;
	#(RD_DEPTH * 22)
	rd_en = 1'b0;
end

always @(posedge wr_clk or negedge sys_rst) begin
	if(sys_rst == 1'b0)begin
		din <= 64'h0123;
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

always @(posedge wr_clk) begin
	if(wr_en)
		$display("the write data is %h\t the write_count is %d",din,wr_data_count);
end

always @(posedge rd_clk) begin
	if(valid)
		$display("the read data is %h\t the read_count is %d",dout,rd_data_count);
end

async_fifo #(
	.INPUT_WIDTH  	( INPUT_WIDTH     ),
	.OUTPUT_WIDTH 	( OUTPUT_WIDTH    ),
	.WR_DEPTH     	( WR_DEPTH        ),
	.RD_DEPTH     	( RD_DEPTH        ),
	.MODE         	( MODE  		  ),
	.DIRECTION    	( DIRECTION       ))
u_async_fifo(
	.wr_clk        	( wr_clk         ),
	.wr_rst        	( sys_rst        ),
	.wr_en         	( wr_en          ),
	.din           	( din            ),
	.rd_clk        	( rd_clk         ),
	.rd_rst        	( sys_rst        ),
	.rd_en         	( rd_en          ),
	.valid         	( valid	         ),
	.dout          	( dout           ),
	.full          	( full           ),
	.empty         	( empty          ),
	.wr_data_count 	( wr_data_count  ),
	.rd_data_count 	( rd_data_count  )
);

initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, tb_async_fifo);    
    #50000 $finish;
end

endmodule  //TOP
