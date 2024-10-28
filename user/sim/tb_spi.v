`timescale 1 ns / 1 ns

module tb_spi();

parameter    CPOL       = 0;
parameter    CPHA       = 0;
parameter    CE_LEVEL   = 0;
parameter    CTRL_WIDTH = 8;
parameter    ADDR_WIDTH = 32;
parameter    DATA_WIDTH = 8;
parameter    CLK_FREQ   = 28'd200_000_000;
parameter    SPI_FREQ   = 28'd30_000_000;

parameter	 BURST_LEN  = 32'd640;

parameter MAIN_FRE   = 200; //unit MHz
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
reg [551:0]    			tx_data;
wire					miso;

reg [5:0]				wait_cnt;

reg 					hbc_cal_pass;
wire					slave_tx_valid;
wire  [DATA_WIDTH-1:0]	slave_tx_data;
wire [CTRL_WIDTH-1:0] 	ctrl;
wire [ADDR_WIDTH-1:0]	address;
wire					slave_tx_en;
wire					slave_rx_en;
wire [DATA_WIDTH-1:0]	slave_rx_data;
wire					slave_done;

reg	 [2:0]				cnt;

wire					full;
wire					empty;

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
		hbc_cal_pass <= 1'b0;
	end
	else if(wait_cnt == 6'd63)begin
		hbc_cal_pass <= 1'b1;
	end
	else begin
		hbc_cal_pass <= 1'b0;
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
		cnt <= 3'd0;
	end
	else if(slave_done)begin
		if(cnt == 3'd6)
			cnt <= cnt;
		else 
			cnt <= cnt + 1'b1;
	end
	else begin
		cnt <= cnt;
	end
end

always @(posedge sys_clk or posedge sys_rst) begin
	if(sys_rst == 1'b1)begin
		tx_data[7:0]     <= 8'd0;   // byte0
		tx_data[15:8]    <= 8'd1;   // byte1
		tx_data[23:16]   <= 8'd2;   // byte2
		tx_data[31:24]   <= 8'd3;   // byte3
		tx_data[39:32]   <= 8'd4;   // byte4
		tx_data[47:40]   <= 8'd5;   // byte5
		tx_data[55:48]   <= 8'd6;   // byte6
		tx_data[63:56]   <= 8'd7;   // byte7
		tx_data[71:64]   <= 8'd8;   // byte8
		tx_data[79:72]   <= 8'h9;   // byte9
		tx_data[87:80]   <= 8'd10;  // byte10
		tx_data[95:88]   <= 8'd11;  // byte11
		tx_data[103:96]  <= 8'd12;  // byte12
		tx_data[111:104] <= 8'd13;  // byte13
		tx_data[119:112] <= 8'd14;  // byte14
		tx_data[127:120] <= 8'd15;  // byte15
		tx_data[135:128] <= 8'd16;  // byte16
		tx_data[143:136] <= 8'd17;  // byte17
		tx_data[151:144] <= 8'd18;  // byte18
		tx_data[159:152] <= 8'd19;  // byte19
		tx_data[167:160] <= 8'd20;  // byte20
		tx_data[175:168] <= 8'd21;  // byte21
		tx_data[183:176] <= 8'd22;  // byte22
		tx_data[191:184] <= 8'd23;  // byte23
		tx_data[199:192] <= 8'd24;  // byte24
		tx_data[207:200] <= 8'd25;  // byte25
		tx_data[215:208] <= 8'd26;  // byte26
		tx_data[223:216] <= 8'd27;  // byte27
		tx_data[231:224] <= 8'd28;  // byte28
		tx_data[239:232] <= 8'd29;  // byte29
		tx_data[247:240] <= 8'd30;  // byte30
		tx_data[255:248] <= 8'd31;  // byte31
		tx_data[263:256] <= 8'd32;  // byte32
		tx_data[271:264] <= 8'd33;  // byte33
		tx_data[279:272] <= 8'd34;  // byte34
		tx_data[287:280] <= 8'd35;  // byte35
		tx_data[295:288] <= 8'd36;  // byte36
		tx_data[303:296] <= 8'd37;  // byte37
		tx_data[311:304] <= 8'd38;  // byte38
		tx_data[319:312] <= 8'd39;  // byte39
		tx_data[327:320] <= 8'd40;  // byte40
		tx_data[335:328] <= 8'd41;  // byte41
		tx_data[343:336] <= 8'd42;  // byte42
		tx_data[351:344] <= 8'd43;  // byte43
		tx_data[359:352] <= 8'd44;  // byte44
		tx_data[367:360] <= 8'd45;  // byte45
		tx_data[375:368] <= 8'd46;  // byte46
		tx_data[383:376] <= 8'd47;  // byte47
		tx_data[391:384] <= 8'd48;  // byte48
		tx_data[399:392] <= 8'd49;  // byte49
		tx_data[407:400] <= 8'd50;  // byte50
		tx_data[415:408] <= 8'd51;  // byte51
		tx_data[423:416] <= 8'd52;  // byte52
		tx_data[431:424] <= 8'd53;  // byte53
		tx_data[439:432] <= 8'd54;  // byte54
		tx_data[447:440] <= 8'd55;  // byte55
		tx_data[455:448] <= 8'd56;  // byte56
		tx_data[463:456] <= 8'd57;  // byte57
		tx_data[471:464] <= 8'd58;  // byte58
		tx_data[479:472] <= 8'd59;  // byte59
		tx_data[487:480] <= 8'd60;  // byte60
		tx_data[495:488] <= 8'd61;  // byte61
		tx_data[503:496] <= 8'd62;  // byte62
		tx_data[511:504] <= 8'd63;  // byte63
		tx_data[543:512] <= 32'd0;  //address
		tx_data[551:544] <= 8'h3a;  // write
	end
	else if(cnt < 2'd3)begin
		if(spi_done)begin
			tx_data[7:0]     <= tx_data[7:0]     + 1'b1;  // byte0
			tx_data[15:8]    <= tx_data[15:8]    + 1'b1;  // byte1
			tx_data[23:16]   <= tx_data[23:16]   + 1'b1;  // byte2
			tx_data[31:24]   <= tx_data[31:24]   + 1'b1;  // byte3
			tx_data[39:32]   <= tx_data[39:32]   + 1'b1;  // byte4
			tx_data[47:40]   <= tx_data[47:40]   + 1'b1;  // byte5
			tx_data[55:48]   <= tx_data[55:48]   + 1'b1;  // byte6
			tx_data[63:56]   <= tx_data[63:56]   + 1'b1;  // byte7
			tx_data[71:64]   <= tx_data[71:64]   + 1'b1;  // byte8
			tx_data[79:72]   <= tx_data[79:72]	 + 1'b1;  // byte9
			tx_data[87:80]   <= tx_data[87:80]   + 1'b1;  // byte10
			tx_data[95:88]   <= tx_data[95:88]   + 1'b1;  // byte11
			tx_data[103:96]  <= tx_data[103:96]  + 1'b1;  // byte12
			tx_data[111:104] <= tx_data[111:104] + 1'b1;  // byte13
			tx_data[119:112] <= tx_data[119:112] + 1'b1;  // byte14
			tx_data[127:120] <= tx_data[127:120] + 1'b1;  // byte15
			tx_data[135:128] <= tx_data[135:128] + 1'b1;  // byte16
			tx_data[143:136] <= tx_data[143:136] + 1'b1;  // byte17
			tx_data[151:144] <= tx_data[151:144] + 1'b1;  // byte18
			tx_data[159:152] <= tx_data[159:152] + 1'b1;  // byte19
			tx_data[167:160] <= tx_data[167:160] + 1'b1;  // byte20
			tx_data[175:168] <= tx_data[175:168] + 1'b1;  // byte21
			tx_data[183:176] <= tx_data[183:176] + 1'b1;  // byte22
			tx_data[191:184] <= tx_data[191:184] + 1'b1;  // byte23
			tx_data[199:192] <= tx_data[199:192] + 1'b1;  // byte24
			tx_data[207:200] <= tx_data[207:200] + 1'b1;  // byte25
			tx_data[215:208] <= tx_data[215:208] + 1'b1;  // byte26
			tx_data[223:216] <= tx_data[223:216] + 1'b1;  // byte27
			tx_data[231:224] <= tx_data[231:224] + 1'b1;  // byte28
			tx_data[239:232] <= tx_data[239:232] + 1'b1;  // byte29
			tx_data[247:240] <= tx_data[247:240] + 1'b1;  // byte30
			tx_data[255:248] <= tx_data[255:248] + 1'b1;  // byte31
			tx_data[263:256] <= tx_data[263:256] + 1'b1;  // byte32
			tx_data[271:264] <= tx_data[271:264] + 1'b1;  // byte33
			tx_data[279:272] <= tx_data[279:272] + 1'b1;  // byte34
			tx_data[287:280] <= tx_data[287:280] + 1'b1;  // byte35
			tx_data[295:288] <= tx_data[295:288] + 1'b1;  // byte36
			tx_data[303:296] <= tx_data[303:296] + 1'b1;  // byte37
			tx_data[311:304] <= tx_data[311:304] + 1'b1;  // byte38
			tx_data[319:312] <= tx_data[319:312] + 1'b1;  // byte39
			tx_data[327:320] <= tx_data[327:320] + 1'b1;  // byte40
			tx_data[335:328] <= tx_data[335:328] + 1'b1;  // byte41
			tx_data[343:336] <= tx_data[343:336] + 1'b1;  // byte42
			tx_data[351:344] <= tx_data[351:344] + 1'b1;  // byte43
			tx_data[359:352] <= tx_data[359:352] + 1'b1;  // byte44
			tx_data[367:360] <= tx_data[367:360] + 1'b1;  // byte45
			tx_data[375:368] <= tx_data[375:368] + 1'b1;  // byte46
			tx_data[383:376] <= tx_data[383:376] + 1'b1;  // byte47
			tx_data[391:384] <= tx_data[391:384] + 1'b1;  // byte48
			tx_data[399:392] <= tx_data[399:392] + 1'b1;  // byte49
			tx_data[407:400] <= tx_data[407:400] + 1'b1;  // byte50
			tx_data[415:408] <= tx_data[415:408] + 1'b1;  // byte51
			tx_data[423:416] <= tx_data[423:416] + 1'b1;  // byte52
			tx_data[431:424] <= tx_data[431:424] + 1'b1;  // byte53
			tx_data[439:432] <= tx_data[439:432] + 1'b1;  // byte54
			tx_data[447:440] <= tx_data[447:440] + 1'b1;  // byte55
			tx_data[455:448] <= tx_data[455:448] + 1'b1;  // byte56
			tx_data[463:456] <= tx_data[463:456] + 1'b1;  // byte57
			tx_data[471:464] <= tx_data[471:464] + 1'b1;  // byte58
			tx_data[479:472] <= tx_data[479:472] + 1'b1;  // byte59
			tx_data[487:480] <= tx_data[487:480] + 1'b1;  // byte60
			tx_data[495:488] <= tx_data[495:488] + 1'b1;  // byte61
			tx_data[503:496] <= tx_data[503:496] + 1'b1;  // byte62
			tx_data[511:504] <= tx_data[511:504] + 1'b1;  // byte63
			tx_data[543:512] <= tx_data[543:512] + 32'd64; // byte64
			tx_data[551:544] <= 8'h3a;  		  		   // write
		end
		else begin
			tx_data <= tx_data;
		end
	end
	else if(cnt == 2'd3)begin
		tx_data[543:512] <= 32'd0; // address
		tx_data[551:544] <= 8'h3b; 
	end
	else if(cnt > 2'd3 && cnt <= 2'd5)begin
		if(spi_done)begin
			tx_data[543:512] <= tx_data[543:512] + 32'd64; // address
			tx_data[551:544] <= 8'h3b; 
		end
		else begin
			tx_data <= tx_data;
		end
	end
	else if(cnt == 2'd6)begin
		tx_data <= 552'd0; 
	end
	else begin
		tx_data <= tx_data;
	end
end

SPI #(
	.CPOL       	( CPOL      ),
	.CPHA       	( CPHA      ),
	.CE_LEVEL   	( CE_LEVEL  ),
	.DATA_WIDTH 	( 552		),
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

/*
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
*/

spi_slave #(
	.CPOL       	( CPOL     ),
	.CPHA       	( CPHA     ),
	.CE_LEVEL   	( CE_LEVEL ),
	.CTRL_WIDTH 	( 8        ),
	.ADDR_WIDTH 	( 32       ),
	.DATA_WIDTH 	( 8        ),
	.LEN_WIDTH  	( 32       ),
	.CTRL_WRITE 	( 8'h3a    ),
	.CTRL_READ  	( 8'h3b    ))
u_spi_slave(
	.clock        	( sys_clk       ),
	.reset        	( sys_rst       ),
	
	.hbc_cal_pass 	( hbc_cal_pass  ),
	.burst_len    	( 32'd64        ),
	.ctrl         	( ctrl          ),
	.address      	( address       ),
	
	.tx_en        	( slave_tx_en   ),
	.tx_valid     	( slave_tx_valid),
	.tx_data      	( slave_tx_data ),
	
	.rx_en        	( slave_rx_en   ),
	.rx_data      	( slave_rx_data ),
	
	.spi_done     	( slave_done    ),
	
	.sclk         	( sclk          ),
	.ce           	( ce            ),
	.mosi         	( mosi          ),
	.miso         	( miso          ));

sync_fifo #(
	.INPUT_WIDTH       	( 8	        ),
	.OUTPUT_WIDTH      	( 8         ),
	.WR_DEPTH          	( 512       ),
	.RD_DEPTH          	( 512       ),
	.MODE              	( "Standard"),
	.DIRECTION         	( "MSB"     ),
	.ECC_MODE          	( "no_ecc"  ),
	.PROG_EMPTY_THRESH 	( 10        ),
	.PROG_FULL_THRESH  	( 10        ),
	.USE_ADV_FEATURES  	( 16'h0000  ))
u_sync_fifo(
	.clock         	( sys_clk        ),
	.reset         	( sys_rst        ),
	
	.wr_en         	( slave_rx_en    ),
	.wr_ready      	( 		         ),
	.din           	( slave_rx_data  ),
	
	.rd_en         	( slave_tx_en    ),
	.valid         	( slave_tx_valid ),
	.dout          	( slave_tx_data  ),
	
	.full          	( full	         ),
	.empty         	( empty	         ),
	
	.wr_data_count 	(   			 ),
	.wr_data_space 	(   			 ),
	.rd_data_count 	(   			 ),
	.rd_data_space 	(   			 ),
	
	.almost_full   	(     		     ),
	.almost_empty  	(     		     ),
	.prog_full     	(       		 ),
	.prog_empty    	(      			 ),
	.overflow      	(        		 ),
	.underflow     	(       		 ),
	.wr_ack        	(          		 ),
	.sbiterr       	(         		 ),
	.dbiterr       	(         		 ));

// wire                  	ram_en;
// wire [31:0]           	ram_addr;
// wire                  	ram_rdwr;
// wire					ram_idle;

// hbram_ctrl #(
// 	.CTRL_WIDTH 	( 8     ),
// 	.ADDR_WIDTH 	( 8     ),
// 	.CTRL_WRITE 	( 8'h3a ),
// 	.CTRL_READ  	( 8'h3b ))
// u_hbram_ctrl(
// 	.clock        	( sys_clk       ),
// 	.reset        	( sys_rst       ),
// 	.hbc_cal_pass 	( hbc_cal_pass  ),
// 	.spi_done     	( burst_en    	),
// 	.ctrl         	( ctrl          ),
// 	.address      	( address       ),
// 	.ram_idle     	( ram_idle      ),
// 	.ram_en       	( ram_en        ),
// 	.ram_addr     	( ram_addr      ),
// 	.ram_rdwr     	( ram_rdwr      ));

initial begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, tb_spi);    
    #6000000 $finish;
end

endmodule  //TOP
