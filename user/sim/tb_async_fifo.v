`timescale 1ns / 1ps

module tb_async_fifo();

parameter    INPUT_WIDTH  = 16;
parameter    OUTPUT_WIDTH = 64;
/*
	The depth parameter of writing mem
	if INPUT_WIDTH < OUTPUT_WIDTH, WR_DEPTH = (OUTPUT_WIDTH/INPUT_WIDTH) * RD_DEPTH
*/
parameter    WR_DEPTH     = 64;
/*
	The depth parameter of reading mem
	if INPUT_WIDTH > OUTPUT_WIDTH, RD_DEPTH = (INPUT_WIDTH/OUTPUT_WIDTH) * WR_DEPTH
*/
parameter    RD_DEPTH     = 16;
//The parameter of reading method
parameter    MODE         = "FWFT";
//Is data stored from high bits or from low bits
parameter    DIRECTION    = "LSB";

parameter 	 WR_FRE     = 100; //unit MHz
parameter	 RD_FRE     = 50;
reg          wr_clk     = 0;
reg			 rd_clk     = 0;
reg          sys_rst	= 1;

always begin
    #(500/WR_FRE) wr_clk = ~wr_clk;
end

always begin
    #(500/RD_FRE) rd_clk = ~rd_clk;
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
wire [$clog2(WR_DEPTH):0] 	wr_data_count;
wire [$clog2(RD_DEPTH):0] 	rd_data_count;
wire [$clog2(WR_DEPTH):0] 	wr_data_space;
wire [$clog2(RD_DEPTH):0] 	rd_data_space;

reg							wr_en;
reg							rd_en;
reg	 [INPUT_WIDTH-1:0]		din;

wire						almost_full;
wire						almost_empty;
wire						prog_full;
wire						prog_empty;
wire						overflow;
wire						underflow;
wire						wr_ack;
wire						sbiterr;
wire						dbiterr;

reg							rst_d1  = 1'b1;
reg							xpm_rst = 1'b1;

wire 						xpm_valid;
wire [OUTPUT_WIDTH-1:0] 	xpm_dout;
wire						xpm_full;
wire						xpm_empty;
wire [10:0] 				xpm_wr_data_count;
wire [10:0] 				xpm_rd_data_count;

wire						xpm_almost_full;
wire						xpm_almost_empty;
wire						xpm_prog_full;
wire						xpm_prog_empty;
wire						xpm_overflow;
wire						xpm_underflow;

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
	@(posedge wr_clk);
	wr_en = 1'b1;

	#((WR_DEPTH+5) * 10)
	@(posedge wr_clk);
	wr_en = 1'b0;

	#100
	@(posedge rd_clk);
	rd_en = 1'b1;

	#((RD_DEPTH+10) * 20)
	@(posedge rd_clk);
	rd_en = 1'b0;
end
endtask

task simultaneous;
begin
	wr_en = 1'b0;
	rd_en = 1'b0;

	#100
	@(posedge wr_clk);
	wr_en = 1'b1;

	#50
	@(posedge rd_clk);
	rd_en = 1'b1;

	#(WR_DEPTH * 12)
	@(posedge wr_clk);
	wr_en = 1'b0;

	#(RD_DEPTH * 22)
	@(posedge rd_clk);
	rd_en = 1'b0;
end
endtask

initial begin
	reset_normal();
end

initial begin
	separate();
end

always @(posedge wr_clk or posedge sys_rst) begin
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

always @(posedge wr_clk) begin
	rst_d1  <= sys_rst;
	xpm_rst <= rst_d1;
end

always @(posedge wr_clk) begin
	if(wr_en & (~full))
		$display("%h\t %d\t %d",din,wr_data_count,xpm_wr_data_count);
end

always @(posedge rd_clk) begin
	if(valid & (~empty))
		$display("%h\t %d\t %d",dout,rd_data_count,xpm_dout,xpm_rd_data_count);
end

async_fifo #(
	.INPUT_WIDTH       	( INPUT_WIDTH           ),
	.OUTPUT_WIDTH      	( OUTPUT_WIDTH          ),
	.WR_DEPTH          	( WR_DEPTH				),
	.RD_DEPTH          	( RD_DEPTH       		),
	.MODE              	( MODE       			),
	.DIRECTION         	( DIRECTION  			),
	.ECC_MODE          	( "no_ecc"   			),
	.PROG_EMPTY_THRESH 	( 10       	 			),
	.PROG_FULL_THRESH  	( 10       	 			),
	.USE_ADV_FEATURES  	( 16'h1F1F  	 		))
u_async_fifo(
	.reset         	( sys_rst          			),
	
	.wr_clock      	( wr_clk       				),
	.wr_en         	( wr_en          			),
	.wr_ready      	(                			),
	.din           	( din            			),
	
	.rd_clock      	( rd_clk         			),
	.rd_en         	( rd_en          			),
	.valid         	( valid          			),
	.dout          	( dout           			),
	
	.full          	( full           			),
	.empty         	( empty          			),
	
	.wr_data_count 	( wr_data_count  			),
	.wr_data_space 	( wr_data_space  			),
	.rd_data_count 	( rd_data_count  			),
	.rd_data_space 	( rd_data_space  			),
	
	.almost_full   	( almost_full    			),
	.almost_empty  	( almost_empty   			),
	.prog_full     	( prog_full      			),
	.prog_empty    	( prog_empty     			),
	.overflow      	( overflow       			),
	.underflow     	( underflow      			),
	.wr_ack        	( wr_ack         			));

glbl #(
	.ROC_WIDTH 	( 100000  ),
	.TOC_WIDTH 	( 0       ))
u_glbl();

xpm_fifo_async #(
	.FIFO_MEMORY_TYPE    	( "block"           ),
	.ECC_MODE            	( "no_ecc"          ),
	.RELATED_CLOCKS      	( 1                 ),
	.FIFO_WRITE_DEPTH    	( WR_DEPTH          ),
	.WRITE_DATA_WIDTH    	( INPUT_WIDTH       ),
	.WR_DATA_COUNT_WIDTH 	( $clog2(WR_DEPTH)  ),
	.PROG_FULL_THRESH    	( 10                ),
	.FULL_RESET_VALUE    	( 0                 ),
	.USE_ADV_FEATURES    	( "1F1F"            ),
	.READ_MODE           	( "std"             ),
	.FIFO_READ_LATENCY   	( 1                 ),
	.READ_DATA_WIDTH     	( OUTPUT_WIDTH      ),
	.RD_DATA_COUNT_WIDTH 	( $clog2(RD_DEPTH)  ),
	.PROG_EMPTY_THRESH   	( 10                ),
	.DOUT_RESET_VALUE    	( "0"               ),
	.CDC_SYNC_STAGES     	( 2                 ),
	.WAKEUP_TIME         	( 0                 ))
u_xpm_fifo_async(
	.sleep         	( 1'b0	             		),
	.rst           	( sys_rst        		    ),
	.wr_clk        	( wr_clk         		    ),
	.wr_en         	( wr_en          		    ),
	.din           	( din            		    ),
	.full          	( xpm_full           		),
	.prog_full     	( xpm_prog_full  		    ),
	.wr_data_count 	( xpm_wr_data_count  		),
	.overflow      	( xpm_overflow       		),
	.wr_rst_busy   	( 			     			),
	.almost_full   	( xpm_almost_full    		),
	.wr_ack        	( 		         		 	),
	.rd_clk        	( rd_clk         		 	),
	.rd_en         	( rd_en          		 	),
	.dout          	( xpm_dout           		),
	.empty         	( xpm_empty          		),
	.prog_empty    	( xpm_prog_empty     		),
	.rd_data_count 	( xpm_rd_data_count  		),
	.underflow     	( xpm_underflow      		),
	.rd_rst_busy   	( 			     			),
	.almost_empty  	( xpm_almost_empty   		),
	.data_valid    	( xpm_valid      			),
	.injectsbiterr 	( 			     			),
	.injectdbiterr 	( 			     			),
	.sbiterr       	(         		 			),
	.dbiterr       	(         		 			));

initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, tb_async_fifo);    
    #50000 $finish;
end

endmodule  //TOP
