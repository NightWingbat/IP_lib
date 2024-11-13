module ad9361_top (
    input         pl_clk,

    input         rx_clk_in_p,
    input         rx_clk_in_n,
    input   [5:0] rx_data_in_p,
    input   [5:0] rx_data_in_n,
    input         rx_frame_in_p,
    input         rx_frame_in_n,

    output        tx_clk_out_p,
    output        tx_clk_out_n,
    output  [5:0] tx_data_out_p,
    output  [5:0] tx_data_out_n,
    output        tx_frame_out_p,
    output        tx_frame_out_n,

    output        enable,
    output        txnrx,
    output  [3:0] ctrl_in,
    output        en_agc,
    output        sync_in,
    output        resetb,

    output        spi_csn,
    output        spi_clk,
    output        spi_mosi,
    input         spi_miso
    
);

wire            ref_clk300m;
wire            clk_50m;
wire            locked;

wire        	data_clk;

wire        	adc_d1q1_valid;
wire        	adc_d2q2_valid;
wire [11:0] 	adc_data_d1;
wire [11:0] 	adc_data_q1;
wire [11:0] 	adc_data_d2;
wire [11:0] 	adc_data_q2;

wire   	        init_done;

wire        	dac_valid;
wire [11:0] 	dac_d1;
wire [11:0] 	dac_d2;
wire [11:0] 	dac_q1;
wire [11:0] 	dac_q2;

wire [15:0] 	data_phase;
wire        	phase_tvalid;

wire [31:0]		dds_tdata;
wire			dds_tvalid;

assign          enable  = 1'b0;
assign          txnrx   = 1'b1;
assign          resetb  = 1'b1;
assign          sync_in = 1'b1;
assign          en_agc  = 1'b1;
assign          ctrl_in = 4'b0000;

wire			ad9361_config_read;
wire			ad9361_config_write;
wire	[9:0]	ad9361_config_address;
wire	[7:0]	ad9361_config_writedata;
wire    [7:0]	ad9361_config_readdata;
wire            ad9361_config_waitrequest;
wire			ad9361_config_init_done;
wire    [12:0]	index;

clk_wiz_0 delay_clock
   (
    // Clock out ports
    .clk_out1(ref_clk300m),     // output clk_out1
    .clk_out2(clk_50m),     // output clk_out2
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(pl_clk));      // input clk_in1

ad9361_phy u_ad9361_phy(
	.ref_clk300m    	( ref_clk300m     ),
	.rst_n          	( locked          ),
	.data_clk       	( data_clk        ),
	
    .rx_clk_in_p    	( rx_clk_in_p     ),
	.rx_clk_in_n    	( rx_clk_in_n     ),
	.rx_data_in_p   	( rx_data_in_p    ),
	.rx_data_in_n   	( rx_data_in_n    ),
	.rx_frame_in_p  	( rx_frame_in_p   ),
	.rx_frame_in_n  	( rx_frame_in_n   ),
	
    .adc_d1q1_valid 	( adc_d1q1_valid  ),
	.adc_d2q2_valid 	( adc_d2q2_valid  ),
	.adc_data_d1    	( adc_data_d1     ),
	.adc_data_q1    	( adc_data_q1     ),
	.adc_data_d2    	( adc_data_d2     ),
	.adc_data_q2    	( adc_data_q2     ),
	
    .tx_clk_out_p   	( tx_clk_out_p    ),
	.tx_clk_out_n   	( tx_clk_out_n    ),
	.tx_frame_out_p 	( tx_frame_out_p  ),
	.tx_frame_out_n 	( tx_frame_out_n  ),
	.tx_data_out_p  	( tx_data_out_p   ),
	.tx_data_out_n  	( tx_data_out_n   ),
	
    .dac_valid      	( dac_valid       ),
	.dac_data_d1    	( dac_d1          ),
	.dac_data_q1    	( dac_d2          ),
	.dac_data_d2    	( dac_q1          ),
	.dac_data_q2    	( dac_q2          ),
	
    .idelay_en      	( 8'h00           ),
	.idelay_tap     	( 9'd100          ),
	.phy_mode       	( 1'b0            )
);

// outports wire
wire        	read;
wire        	write;
wire [9:0]  	address;
wire [7:0]  	writedata;
wire        	chip_rst_n;
wire [11:0] 	init_index;

ad9361_init u_ad9361_init(
	.clk         	( clk_50m      				 ),
	.rst_n       	( locked       				 ),
	.read        	( ad9361_config_read         ),
	.write       	( ad9361_config_write        ),
	.address     	( ad9361_config_address		 ),
	.writedata   	( ad9361_config_writedata    ),
	.readdata    	( ad9361_config_readdata     ),
	.waitrequest 	( ad9361_config_waitrequest  ),
	.chip_rst_n  	( 						     ),
	.init_index  	( index        				 ),
	.init_done   	( init_done    				 )
);

ad9361_spi u_ad9361_spi(
	.clk         	( clk_50m      				 ),
	.rst_n       	( locked       				 ),
	.read        	( ad9361_config_read         ),
	.write       	( ad9361_config_write        ),
	.address     	( ad9361_config_address      ),
	.writedata   	( ad9361_config_writedata    ),
	.readdata    	( ad9361_config_readdata     ),
	.waitrequest 	( ad9361_config_waitrequest  ),
	.spi_clk     	( spi_clk      			     ),
	.spi_csn     	( spi_csn      			     ),
	.spi_sdo     	( spi_mosi     			     ),
	.spi_sdi     	( spi_miso     			     )
);

dds_compiler_0 dds_iq (
  .aclk(data_clk),                                // input wire aclk
  .s_axis_phase_tvalid(phase_tvalid),  // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata(data_phase),    // input wire [15 : 0] s_axis_phase_tdata
  .m_axis_data_tvalid(dds_tdata),    // output wire m_axis_data_tvalid
  .m_axis_data_tdata(dds_tvalid)      // output wire [31 : 0] m_axis_data_tdata
);

dds_dq u_dds_dq(
	.dq_data_clk  	( data_clk      ),
	.phy_mode     	( 1'b0          ),
	.rst_n        	( locked        ),
	
	.dac_valid    	( dac_valid     ),
	.dac_d1       	( dac_d1        ),
	.dac_d2       	( dac_d2        ),
	.dac_q1       	( dac_q1        ),
	.dac_q2       	( dac_q2        ),
	
	.dds_inc      	( 12'd128       ),
	.dds_tdata    	( dds_tdata     ),
	.dds_t_valid  	( dds_tvalid    ),
	.data_phase   	( data_phase    ),
	.phase_tvalid 	( phase_tvalid  )
);

endmodule //ad9361_top
