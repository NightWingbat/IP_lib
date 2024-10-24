module ch347_test #(
    //The parameter for clock idle state level
    parameter    CPOL       = 1, // @suppress "Parameter 'CPOL' is never used locally"
    //The parameter for clock phase
    parameter    CPHA       = 1, // @suppress "Parameter 'CPHA' is never used locally"
    //chip selection enable level
    parameter    CE_LEVEL   = 0, // @suppress "Parameter 'CE_LEVEL' is never used locally"
    //The width parameter for register control
    parameter    CTRL_WIDTH = 8,
    //The width parameter for register address
    parameter    ADDR_WIDTH = 8,
    //The width parameter for writing or receiving data
    parameter    DATA_WIDTH = 8,
    //Burst read or write length
    parameter    LEN_WIDTH  = 32,
    //SPI write command
    parameter    CTRL_WRITE = 8'h3a, // @suppress "Parameter 'CTRL_WRITE' is never used locally"
    //SPI read  command
    parameter    CTRL_READ  = 8'h3b // @suppress "Parameter 'CTRL_READ' is never used locally"
) (
    input   clock,

    input   locked,

    input   sclk,

    input   ce,

    input   mosi,

    output  miso
);

// outports wire
wire [CTRL_WIDTH-1:0] 	ctrl;
wire [ADDR_WIDTH-1:0] 	address;

wire                  	tx_en;
wire                  	rx_en;
wire                    tx_valid;

wire [DATA_WIDTH-1:0] 	rx_data;
wire [DATA_WIDTH-1:0] 	tx_data;

wire                  	spi_done;

reg  [5:0]				wait_cnt;
reg 					hbc_cal_pass;

wire                    full;
wire                    empty;

always @(posedge clock or negedge locked) begin
	if(locked == 1'b0)begin
		wait_cnt <= 6'd0;
	end
	else if(wait_cnt == 6'd63)begin
		wait_cnt <= wait_cnt;
	end
	else begin
		wait_cnt <= wait_cnt + 1'b1;
	end
end

always @(posedge clock or negedge locked) begin
	if(locked == 1'b0)begin
		hbc_cal_pass <= 1'b0;
	end
	else if(wait_cnt == 6'd63)begin
		hbc_cal_pass <= 1'b1;
	end
	else begin
		hbc_cal_pass <= 1'b0;
	end
end

spi_slave #(
	.CPOL       	( CPOL          ),
	.CPHA       	( CPHA          ),
	.CE_LEVEL   	( CE_LEVEL      ),
	.CTRL_WIDTH 	( CTRL_WIDTH    ),
	.ADDR_WIDTH 	( ADDR_WIDTH    ),
	.DATA_WIDTH 	( DATA_WIDTH    ),
	.LEN_WIDTH  	( LEN_WIDTH     ),
	.CTRL_WRITE 	( CTRL_WRITE    ),
	.CTRL_READ  	( CTRL_READ     ))
u_spi_slave(
	.clock        	( clock         ),
	.reset        	( ~locked       ),
	
    .hbc_cal_pass 	( hbc_cal_pass  ),
	.burst_len    	( 32'd8         ),
	
    .ctrl         	( ctrl          ),
	.address      	( address       ),
	
    .tx_en        	( tx_en         ),
	.tx_valid     	( tx_valid      ),
	.tx_data      	( tx_data       ),
	
    .rx_en        	( rx_en         ),
	.rx_data      	( rx_data       ),
	
    .spi_done     	( spi_done      ),
	
    .sclk         	( sclk          ),
	.ce           	( ce            ),
	.mosi         	( mosi          ),
	.miso         	( miso          ));

sync_fifo #(
	.INPUT_WIDTH       	( DATA_WIDTH ),
	.OUTPUT_WIDTH      	( DATA_WIDTH ),
	.WR_DEPTH          	( 512        ),
	.RD_DEPTH          	( 512        ),
	.MODE              	( "Standard" ),
	.DIRECTION         	( "MSB"      ),
	.ECC_MODE          	( "no_ecc"   ),
	.PROG_EMPTY_THRESH 	( 10         ),
	.PROG_FULL_THRESH  	( 10         ),
	.USE_ADV_FEATURES  	( 16'h1F1F   ))
u_sync_fifo(
	.clock         	( clock          ),
	.reset         	( ~locked        ),
	.wr_en         	( rx_en          ),
	.wr_ready      	(                ),
	.din           	( rx_data        ),
	.rd_en         	( tx_en          ),
	.valid         	( tx_valid       ),
	.dout          	( tx_data        ),
	.full          	( full           ),
	.empty         	( empty          ),
	.wr_data_count 	(                ),
	.wr_data_space 	(                ),
	.rd_data_count 	(                ),
	.rd_data_space 	(                ),
	.almost_full   	(                ),
	.almost_empty  	(                ),
	.prog_full     	(                ),
	.prog_empty    	(                ),
	.overflow      	(                ),
	.underflow     	(                ),
	.wr_ack        	(                ),
	.sbiterr       	(                ),
	.dbiterr       	(                ));

endmodule
