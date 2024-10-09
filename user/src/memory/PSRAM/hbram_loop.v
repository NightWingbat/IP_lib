module hbram_loop #(
    parameter    INPUT_WIDTH  = 12,
    parameter    OUTPUT_WIDTH = 12
) (
    input         ram_clk,
    input         ram_clk_cal,

    input         native_clk,

    input         locked,

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
    output [1:0]  hbc_rwds_OE
);

wire            native_wr_buf_ready;
wire        	native_ram_en;
wire        	native_ram_rdwr;
wire [31:0] 	native_ram_address;
wire [10:0] 	native_ram_burst_len;
wire        	native_wr_en;
wire [31:0] 	native_wr_data;
wire [31:0]     native_rd_data;
wire [3:0]  	native_wr_datamask;

wire            hbc_cal_pass;

hbram_ctrl u_hbram_ctrl(
	.native_clk           	( native_clk            ),
	.rst_n                	( locked                ),
	
    .hbc_cal_pass         	( hbc_cal_pass          ),
	.native_ctrl_idle     	( native_ctrl_idle      ),
	
    .native_ram_en        	( native_ram_en         ),
	.native_ram_rdwr      	( native_ram_rdwr       ),
	.native_ram_address   	( native_ram_address    ),
	.native_ram_burst_len 	( native_ram_burst_len  ),
	
    .native_wr_buf_ready  	( native_wr_buf_ready   ),
	.native_wr_en         	( native_wr_en          ),
	.native_wr_data       	( native_wr_data        ),
	.native_wr_datamask   	( native_wr_datamask    ),
	
    .native_rd_valid      	( native_rd_valid       ));

hbram_controller u_hbram_controller(
    .ram_clk_cal            (ram_clk_cal),
    .ram_clk                (ram_clk),
    .rst                    (~locked),
   
    .hbc_cal_debug_info     (),
    .hbc_cal_pass           (hbc_cal_pass),
    .hbc_ck_n_LO            (hbc_ck_n_LO),
    .hbc_ck_n_HI            (hbc_ck_n_HI),
    .hbc_ck_p_LO            (hbc_ck_p_LO),
    .hbc_ck_p_HI            (hbc_ck_p_HI),
    .hbc_cs_n               (hbc_cs_n),
    .hbc_rst_n              (hbc_rst_n),
    .hbc_cal_SHIFT_SEL      (),
    .hbc_cal_SHIFT          (),
    .hbc_cal_SHIFT_ENA      (),
    
    .native_clk             (native_clk),
    .native_ram_en          (native_ram_en),
    .native_ram_address     (native_ram_address),
    
    .dyn_pll_phase_sel      (),
    .dyn_pll_phase_en       (),
    
    .native_ctrl_idle       (native_ctrl_idle),
    .native_rd_valid        (native_rd_valid),
    .native_wr_buf_ready    (native_wr_buf_ready),
    .native_ram_burst_len   (native_ram_burst_len),
    .native_wr_en           (native_wr_en),
    .native_ram_rdwr        (native_ram_rdwr),
    
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
    
    .native_wr_data         (native_wr_data),
    .native_wr_datamask     (native_wr_datamask),
    .native_rd_data         (native_rd_data));

endmodule  //hbram_loop
