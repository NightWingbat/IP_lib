`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module ad9361_phy(
	input	wire 			ref_clk300m,//300m idelay ctrl ref clock
	input	wire 			rst_n,
	output	wire 			data_clk,
	
	//ad936x io port
	input	wire 			rx_clk_in_p,
	input	wire 			rx_clk_in_n,
	input	wire	[5:0] 	rx_data_in_p,
	input	wire 	[5:0]	rx_data_in_n,
	input	wire 			rx_frame_in_p,
	input	wire 			rx_frame_in_n,	
	//adc result
	output	wire 			adc_d1q1_valid,
	output	wire 			adc_d2q2_valid,
	output	wire 	[11:0]	adc_data_d1,
	output	wire 	[11:0]	adc_data_q1,
	output	wire 	[11:0]	adc_data_d2,
	output	wire 	[11:0]	adc_data_q2,
	//ad936x io tx
	output  wire 			tx_clk_out_p,
	output  wire 			tx_clk_out_n,
	output	wire 			tx_frame_out_p,
	output	wire 			tx_frame_out_n,
	output	wire 	[5:0]	tx_data_out_p,
	output	wire 	[5:0]	tx_data_out_n,
	// dac  output 
	input 	wire 			dac_valid,
	input 	wire 	[11:0]	dac_data_d1,
	input 	wire 	[11:0]	dac_data_q1,
	input 	wire 	[11:0]	dac_data_d2,
	input 	wire 	[11:0]	dac_data_q2,
	//var load idelay signals
	input	wire	[6:0]	idelay_en,
	input	wire 	[8:0]	idelay_tap,
	input 	wire 	        phy_mode //==1 is r1 mode;  == 2 is r2 mode

    );   
    
    wire sync_rstn;
    reg rst_n_r3_reg;
    reg rst_n_r2_reg;
    reg rst_n_r1_reg;
    reg rst_n_r0_reg;
    always@(posedge data_clk)begin
        rst_n_r3_reg<=rst_n_r2_reg;
        rst_n_r2_reg<=rst_n_r1_reg;
        rst_n_r1_reg<=rst_n_r0_reg;
        rst_n_r0_reg<=rst_n;
    end
    assign sync_rstn=rst_n_r3_reg;
    
	phy_rx phy_rx_inst
	(
		.ref_clk300m(ref_clk300m),//200m idelay ctrl ref clock
		.rst_n(sync_rstn),
		.data_clk(data_clk),

		.rx_clk_in_p(rx_clk_in_p),
		.rx_clk_in_n(rx_clk_in_n),
		.rx_data_in_p(rx_data_in_p),
		.rx_data_in_n(rx_data_in_n),
		.rx_frame_in_p(rx_frame_in_p),
		.rx_frame_in_n(rx_frame_in_n),

		.adc_d1q1_valid(adc_d1q1_valid),
		.adc_d2q2_valid(adc_d2q2_valid),
		.adc_data_d1(adc_data_d1),
		.adc_data_q1(adc_data_q1),
		.adc_data_d2(adc_data_d2),
		.adc_data_q2(adc_data_q2),

		.idelay_en(idelay_en),
		.idelay_tap(idelay_tap),
		.phy_mode(phy_mode) //0 2R2T 1 1R1T
	);
	
	phy_tx phy_tx_inst
	(
		.rst_n(sync_rstn),
		.data_clk(data_clk),
		
		.tx_clk_out_p(tx_clk_out_p),
		.tx_clk_out_n(tx_clk_out_n),
		.tx_frame_out_p(tx_frame_out_p),
		.tx_frame_out_n(tx_frame_out_n),
		.tx_data_out_p(tx_data_out_p),
		.tx_data_out_n(tx_data_out_n),
		
		.dac_valid(dac_valid),
		.dac_data_d1(dac_data_d1),
		.dac_data_q1(dac_data_q1),
		.dac_data_d2(dac_data_d2),
		.dac_data_q2(dac_data_q2),
		.phy_mode(phy_mode) //0 2R2T 1 1R1T
	);
	
endmodule
