module hbram_loop #(
    //sync_fifo input data width
    parameter    FIFO_INPUT_WIDTH  = 8,
    //sync_fifo outpit data width
    parameter    FIFO_OUTPUT_WIDTH = 8,
    //The depth parameter of sync_fifo writing mem
    parameter    FIFO_WR_DEPTH     = 256,
    //The depth parameter of sync_fifo reading mem
    parameter    FIFO_RD_DEPTH     = 256,
    //The parameter for clock idle state level
    parameter    CPOL              = 1, 
    //The parameter for clock phase
    parameter    CPHA              = 1, 
    //chip selection enable level
    parameter    CE_LEVEL          = 0, 
    //The width parameter for register control
    parameter    CTRL_WIDTH        = 8,
    //The width parameter for register address
    parameter    ADDR_WIDTH        = 8,
    //The width parameter for writing or receiving data
    parameter    DATA_WIDTH        = 8,
    //Burst read or write length
    parameter    LEN_WIDTH         = 11,
    //SPI write command
    parameter    CTRL_WRITE        = 8'h3a, 
    //SPI read  command
    parameter    CTRL_READ         = 8'h3b 
) (
    //internal oscillator
    input         intosc_clkout,
    output        intosc_en,
    //hyperram clock
    input         ram_clk,
    input         ram_clk_cal,
    //spi and fifo clock
    input         native_clk,
    input         locked,
    //PLL Phase setting
    output [2:0]  hbc_cal_SHIFT,
    output [4:0]  hbc_cal_SHIFT_SEL,
    output        hbc_cal_SHIFT_ENA,
    output        sysClk_pll_rstn,
    output        hbramClk_pll_rstn,
    //hyperram_phy
    output        hbc_rst_n,
    output        hbc_cs_n,
    output        hbc_ck_p_HI,
    output        hbc_ck_p_LO,
    output        hbc_ck_n_HI,
    output        hbc_ck_n_LO,
    output [1:0]  hbc_rwds_OUT_HI,
    output [1:0]  hbc_rwds_OUT_LO,
    input  [1:0]  hbc_rwds_IN_HI,
    input  [1:0]  hbc_rwds_IN_LO,
    input  [15:0] hbc_dq_IN_LO,
    input  [15:0] hbc_dq_IN_HI,
    output [15:0] hbc_dq_OUT_HI,
    output [15:0] hbc_dq_OUT_LO,
    output [15:0] hbc_dq_OE,
    output [1:0]  hbc_rwds_OE,
    //spi_phy
    input         sclk,
    input         ce,
    input         mosi,
    output        miso
);

//Hyperram complete signal
wire                            hbc_cal_pass;

//SPI control and address signal
wire                            spi_done;
wire [CTRL_WIDTH-1:0] 	        spi_ctrl;
wire [ADDR_WIDTH-1:0] 	        spi_address;

//SPI Data Write
wire  [DATA_WIDTH-1:0]	        slave_rx_data;            

//SPI Data Read
wire					        slave_tx_en;
wire					        slave_tx_valid;
wire  [DATA_WIDTH-1:0]	        slave_tx_data;

//Hyperram 
wire        	                native_ram_en;
wire        	                native_ram_rdwr;
wire [31:0] 	                native_ram_address;
wire [10:0] 	                native_ram_burst_len = 11'd256;
wire                            native_ctrl_idle;

//Hyperram Date Write
wire        	                native_wr_en;
wire [31:0] 	                native_wr_data = {24'd0,slave_rx_data};
wire                            native_wr_buf_ready;
wire [3:0]  	                native_wr_datamask = 4'hf;

//Hyperram Date Read
wire                            native_rd_valid;
wire [31:0]                     native_rd_data;

//Hyperram PLL_Phase
wire                            dyn_pll_phase_en;
wire                            dyn_pll_phase_sel;

//fifo empty and full signal
wire                            full;
wire                            empty;
//fifo data count
wire [$clog2(FIFO_WR_DEPTH):0] 	wr_data_count;
wire [$clog2(FIFO_WR_DEPTH):0] 	wr_data_space;
wire [$clog2(FIFO_RD_DEPTH):0] 	rd_data_count;
wire [$clog2(FIFO_RD_DEPTH):0] 	rd_data_space;
//wait_cnt
reg  [31:0]                     wait_cnt;
reg                             wait_valid;

assign                          intosc_en         = 1'b1;
assign                          hbramClk_pll_rstn = 1'b1;
assign                          sysClk_pll_rstn   = 1'b1;

assign                          dyn_pll_phase_en  = 1'b1;
assign                          dyn_pll_phase_sel = 3'b010;

always @(posedge native_clk or negedge locked) begin
    if(locked == 1'b0)begin
        wait_cnt   <= 32'd0;
        wait_valid <= 1'b0;
    end
    else if(wait_cnt < 32'd4000000)begin
        wait_cnt   <= wait_cnt + 1'b1;
        wait_valid <= 1'b0;
    end
    else begin
        wait_cnt   <= wait_cnt;
        wait_valid <= 1'b1;
    end
end

hbram_ctrl #(
	.CTRL_WIDTH 	( CTRL_WIDTH        ),
	.ADDR_WIDTH 	( ADDR_WIDTH        ),
	.CTRL_WRITE 	( CTRL_WRITE        ),
	.CTRL_READ  	( CTRL_READ         ))
u_hbram_ctrl(
	.clock        	( native_clk        ),
	.reset        	( ~locked           ),
	.hbc_cal_pass 	( hbc_cal_pass & wait_valid     ),
	.spi_done     	( spi_done          ),
	.ctrl         	( spi_ctrl          ),
	.address      	( spi_address       ),
    .burst_len      ( native_ram_burst_len),
	.ram_idle     	( native_ctrl_idle  ),
	.ram_en       	( native_ram_en     ),
	.ram_addr     	( native_ram_address),
	.ram_rdwr     	( native_ram_rdwr   ));

hbram_controller u_hbram_controller(
    //hyperram clock
    .ram_clk_cal            (ram_clk_cal),
    .ram_clk                (ram_clk),
    .rst                    (~locked),
    //hyperram_phy
    .hbc_cal_debug_info     (),
    .hbc_cal_pass           (hbc_cal_pass),
    .hbc_ck_n_LO            (hbc_ck_n_LO),
    .hbc_ck_n_HI            (hbc_ck_n_HI),
    .hbc_ck_p_LO            (hbc_ck_p_LO),
    .hbc_ck_p_HI            (hbc_ck_p_HI),
    .hbc_cs_n               (hbc_cs_n),
    .hbc_rst_n              (hbc_rst_n),
    .hbc_cal_SHIFT_SEL      (hbc_cal_SHIFT_SEL),
    .hbc_cal_SHIFT          (hbc_cal_SHIFT),
    .hbc_cal_SHIFT_ENA      (hbc_cal_SHIFT_ENA),
    
    .native_clk             (native_clk),
    .native_ram_en          (native_ram_en),
    .native_ram_address     (native_ram_address),
    
    .dyn_pll_phase_sel      (dyn_pll_phase_sel),
    .dyn_pll_phase_en       (dyn_pll_phase_en),
    
    .native_ctrl_idle       (native_ctrl_idle),
    .native_rd_valid        (native_rd_valid),
    .native_wr_buf_ready    (native_wr_buf_ready),
    .native_ram_burst_len   (native_ram_burst_len),
    .native_wr_en           (native_wr_en),
    .native_ram_rdwr        (native_ram_rdwr),
    //hyperram_phy
    .hbc_dq_OE              (hbc_dq_OE),
    .hbc_dq_IN_LO           (hbc_dq_IN_LO),
    .hbc_dq_IN_HI           (hbc_dq_IN_HI),
    .hbc_dq_OUT_LO          (hbc_dq_OUT_LO),
    .hbc_dq_OUT_HI          (hbc_dq_OUT_HI),
    .hbc_rwds_OE            (hbc_rwds_OE),
    .hbc_rwds_IN_LO         (hbc_rwds_IN_LO),
    .hbc_rwds_IN_HI         (hbc_rwds_IN_HI),
    .hbc_rwds_OUT_LO        (hbc_rwds_OUT_LO),
    .hbc_rwds_OUT_HI        (hbc_rwds_OUT_HI),
    //read and write data
    .native_wr_data         (native_wr_data),
    .native_wr_datamask     (native_wr_datamask),
    .native_rd_data         (native_rd_data));

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
	.clock        	( native_clk    ),
	.reset        	( ~locked       ),
	
    .hbc_cal_pass 	( hbc_cal_pass & wait_valid  ),
	.burst_len    	( 11'd16        ),
	.ctrl         	( spi_ctrl      ),
	.address      	( spi_address   ),
	
    .tx_en        	( slave_tx_en   ),
	.tx_valid     	( slave_tx_valid),
	.tx_data      	( slave_tx_data ),
	
    .rx_en        	( native_wr_en  ),
	.rx_data      	( slave_rx_data ),
	
    .spi_done     	( spi_done      ),
	
    .sclk         	( sclk          ),
	.ce           	( ce            ),
	.mosi         	( mosi          ),
	.miso         	( miso          ));

sync_fifo #(
	.INPUT_WIDTH       	( FIFO_INPUT_WIDTH    ),
	.OUTPUT_WIDTH      	( FIFO_OUTPUT_WIDTH   ),
	.WR_DEPTH          	( FIFO_WR_DEPTH       ),
	.RD_DEPTH          	( FIFO_RD_DEPTH       ),
	.MODE              	( "Standard"          ),
	.DIRECTION         	( "MSB"               ),
	.ECC_MODE          	( "no_ecc"            ),
	.PROG_EMPTY_THRESH 	( 10                  ),
	.PROG_FULL_THRESH  	( 10                  ),
	.USE_ADV_FEATURES  	( 16'h0000            ))
u_sync_fifo(
	.clock         	( native_clk     ),
	.reset         	( ~locked        ),
	
    .wr_en         	( native_rd_valid),
	.wr_ready      	(                ),
	.din           	( native_rd_data[7:0] ),
	
    .rd_en         	( slave_tx_en    ),
	.valid         	( slave_tx_valid ),
	.dout          	( slave_tx_data  ),
	
    .full          	( full           ),
	.empty         	( empty          ),
	
    .wr_data_count 	( wr_data_count  ),
	.wr_data_space 	( wr_data_space  ),
	.rd_data_count 	( rd_data_count  ),
	.rd_data_space 	( rd_data_space  ),
	
    .almost_full   	(                ),
	.almost_empty  	(                ),
	.prog_full     	(                ),
	.prog_empty    	(                ),
	.overflow      	(                ),
	.underflow     	(                ),
	.wr_ack        	(                ),
	.sbiterr       	(                ),
	.dbiterr       	(                ));

endmodule  //hbram_loop
