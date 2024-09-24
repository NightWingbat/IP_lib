module spi_top #(
	//The parameter for clock idle state level
    parameter    CPOL       = 0,
    //The parameter for clock phase
    parameter    CPHA       = 0,
    //chip selection enable level
    parameter    CE_LEVEL   = 0,
    //The width parameter for writing data
    parameter    DATA_WIDTH = 8
)
(
    input      clk,
    input      locked,

    //spi clock
    input      sclk,
    //select slave device chips
    input      ce,
    //master output slave input
    input      mosi,
    //master input slave output
    output     miso,
    
    output     led,
    
    output     led2
);

wire [DATA_WIDTH-1:0]	rx_data;
wire 					spi_done;

spi_slave #(
	.CPOL       		( CPOL  	),
	.CPHA       		( CPHA  	),
	.CE_LEVEL   		( CE_LEVEL  ),
	.DATA_WIDTH 		( DATA_WIDTH))
u_spi_slave(
	//ports
	.clock    		( clk    		),
	.reset    		( ~locked    	),
	
	.tx_data  		( 8'h66   		),
	.rx_data  		( rx_data  		),
	
	.spi_done 		( spi_done 		),
	
	.sclk     		( sclk     		),
	.ce       		( ce       		),
	.mosi     		( mosi     		),
	.miso     		( miso     		)
);

assign led  = (rx_data == 8'h88) ? 1'b1 : 1'b0;
assign led2 = 1'b0;

endmodule // spi_top
