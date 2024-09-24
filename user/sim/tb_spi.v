`timescale 1 ns / 1 ns

module tb_spi();

parameter    CPOL       = 0;
parameter    CPHA       = 0;
parameter    CE_LEVEL   = 0;
parameter    DATA_WIDTH = 24;
parameter    CLK_FREQ   = 26'd50_000_000;
parameter    SPI_FREQ   = 26'd400_000;

parameter MAIN_FRE   = 50; //unit MHz
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
wire [DATA_WIDTH-1:0] 	rx_data;
wire                  	spi_done;
wire                  	sclk;
wire                  	mosi;
wire                  	ce;

reg						spi_exe;
reg [DATA_WIDTH-1:0]    tx_data;
wire					miso;

reg [5:0]				wait_cnt;

always @(posedge sys_clk or posedge sys_rst) begin
	if(sys_rst == 1'b1)begin
		wait_cnt <= 6'd0;
	end
	else if(wait_cnt == 6'd63)begin
		wait_cnt <= wait_cnt;
	end
	else begin
		wait_cnt <= wait_cnt + 1'b1;
	end
end

always @(posedge sys_clk or posedge sys_rst) begin
	if(sys_rst == 1'b1)begin
		spi_exe <= 1'b0;
	end
	else if(wait_cnt == 6'd62)begin
		spi_exe <= 1'b1;
	end
	else if(spi_done)begin
		spi_exe <= 1'b1;
	end
	else begin
		spi_exe <= 1'b0;
	end
end

always @(posedge sys_clk or posedge sys_rst) begin
	if(sys_rst == 1'b1)begin
		tx_data[23:18] <= 6'b100000;
		tx_data[17:0]  <= 18'h1_0123;
	end
	else if(spi_done)begin
		tx_data[23:18] <= 6'b100000;
		tx_data[7:0]   <= tx_data[7:0] + 1'b1;
		tx_data[15:8]  <= tx_data[15:8] + 1'b1;
		tx_data[17:16] <= tx_data[17:16] + 1'b1;
	end
	else begin
		tx_data <= tx_data;
	end
end

SPI #(
	.CPOL       	( CPOL      ),
	.CPHA       	( CPHA      ),
	.CE_LEVEL   	( CE_LEVEL  ),
	.DATA_WIDTH 	( DATA_WIDTH),
	.CLK_FREQ   	( CLK_FREQ  ),
	.SPI_FREQ   	( SPI_FREQ  ))
u_SPI(
	.clock    	( sys_clk   ),
	.reset    	( sys_rst   ),
	.spi_exe  	( spi_exe   ),
	.tx_data  	( tx_data   ),
	.rx_data  	( rx_data   ),
	.spi_done 	( spi_done  ),
	.sclk     	( sclk      ),
	.mosi     	( mosi      ),
	.miso     	( miso      ),
	.ce       	( ce        )
);

wire       	wr_end;
wire       	rd_end;
wire [7:0] 	rd_data;
wire       	spi_clk;
wire       	spi_enb;
wire       	spi_di;

spi_adi u_spi_adi(
	.clk     	( sys_clk  ),
	.rst_n   	( ~sys_rst ),
	.wr_req  	( spi_exe  ),
	.wr_end  	( wr_end   ),
	.wr_addr 	( tx_data[17:8] ),
	.wr_data 	( tx_data[7:0]  ),
	.rd_req  	( spi_exe  ),
	.rd_end  	( rd_end   ),
	.rd_addr 	( rd_addr  ),
	.rd_data 	( rd_data  ),
	.spi_clk 	( spi_clk  ),
	.spi_enb 	( spi_enb  ),
	.spi_do  	( spi_do   ),
	.spi_di  	( spi_di   )
);

wire 					  slave_done;
wire [DATA_WIDTH - 1 : 0] slave_rx_data;

spi_slave #(
	.CPOL       		( CPOL  	),
	.CPHA       		( CPHA  	),
	.CE_LEVEL   		( CE_LEVEL  ),
	.DATA_WIDTH 		( DATA_WIDTH))
u_spi_slave(
	//ports
	.clock    		( sys_clk    	),
	.reset    		( sys_rst    	),
	
	.tx_data  		(   			),
	.rx_data  		( slave_rx_data ),
	
	.spi_done 		( slave_done 	),
	
	.sclk     		( sclk     		),
	.ce       		( ce       		),
	.mosi     		( mosi     		),
	.miso     		( miso     		)
);

initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, tb_spi);    
    #500000 $finish;
end

endmodule  //TOP
