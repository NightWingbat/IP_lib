module phy_tx
(
	input	wire 			rst_n,
	input	wire 			data_clk,
	
	output  wire 			tx_clk_out_p,
	output  wire 			tx_clk_out_n,
	output	wire 			tx_frame_out_p,
	output	wire 			tx_frame_out_n,
	output	wire 	[5:0]	tx_data_out_p,
	output	wire 	[5:0]	tx_data_out_n,

	input 	wire 			dac_valid,
	input 	wire 	[11:0]	dac_data_d1,
	input 	wire 	[11:0]	dac_data_q1,
	input 	wire 	[11:0]	dac_data_d2,
	input 	wire 	[11:0]	dac_data_q2,
	
	input 	wire 	        phy_mode
);

    parameter PHY_MODE_1R1T=1;
    parameter PHY_MODE_2R2T=0;
    //reg define
    reg [1:0]	 tx_data_cnt_reg;
    reg [11:0]	 tx_data_d1_reg;
    reg [11:0]	 tx_data_q1_reg;
    reg [11:0]	 tx_data_d2_reg ;
    reg [11:0]	 tx_data_q2_reg;
    reg [5:0]	 tx_data_posedge_reg;
    reg [5:0]	 tx_data_negedge_reg;
    reg 		 tx_frame_reg;
    reg 		 tx_data_valid_reg;
    
    wire [2:0]	 tx_data_switch;
//data cnt counter
always @(posedge data_clk or negedge rst_n) begin
    if(!rst_n)begin
        tx_data_valid_reg<=1'b0;
    end
    else begin
        case(phy_mode)      
          PHY_MODE_2R2T:begin//2T2R
                if(dac_valid == 1'b0 && tx_data_valid_reg == 1'b1 && tx_data_cnt_reg == 'd3)tx_data_valid_reg <= 1'b0;
                else if(dac_valid == 1'b1) tx_data_valid_reg <= 1'b1;
            end
            PHY_MODE_1R1T:begin//1T1R
                if(dac_valid == 1'b0 && tx_data_valid_reg == 1'b1 && tx_data_cnt_reg == 'd1)tx_data_valid_reg <= 1'b0;
                else if(dac_valid == 1'b1) tx_data_valid_reg <= 1'b1;
            end
            default:;
        endcase
    end
end

always @(posedge data_clk or negedge rst_n) begin
    if(!rst_n)begin
        tx_data_cnt_reg<='d0;
    end
    else begin
        if(tx_data_valid_reg == 1'b1 )begin
        case(phy_mode)
            PHY_MODE_1R1T:begin//1T1R
                if(tx_data_cnt_reg=='d1) tx_data_cnt_reg <= 'd0;
                else tx_data_cnt_reg <= tx_data_cnt_reg + 'd1;
            end
            PHY_MODE_2R2T:begin //2T2R
                if(tx_data_cnt_reg == 'd3) tx_data_cnt_reg <= 'd0;
                else tx_data_cnt_reg <= tx_data_cnt_reg + 'd1;
            end
           default:;
           endcase
        end
    end
end

assign tx_data_switch = {phy_mode,tx_data_cnt_reg};
//input data regester
always @(posedge data_clk or negedge rst_n) begin
    if(!rst_n)begin
        tx_data_d1_reg<='d0;
        tx_data_q1_reg<='d0;
        tx_data_d2_reg<='d0;
        tx_data_q2_reg<='d0;
    end
    else begin
        if(dac_valid == 1'b1 ) begin
            tx_data_d1_reg <= dac_data_d1;
            tx_data_q1_reg <= dac_data_q1;
            tx_data_d2_reg <= dac_data_d2;
            tx_data_q2_reg <= dac_data_q2;
        end
    end
end
//tx data out logical
always @(posedge data_clk or negedge rst_n) begin
    if(!rst_n)begin
        tx_frame_reg<=1'b1;
        tx_data_posedge_reg<='d0;
        tx_data_negedge_reg<='d0;
    end
    else begin
        if(tx_data_valid_reg)begin
            case(tx_data_switch)         
            3'b101: begin                 // 1R1T
                tx_frame_reg <= 1'b0;
                tx_data_posedge_reg <= tx_data_d1_reg[5:0];
                tx_data_negedge_reg <= tx_data_q1_reg[5:0];
            end
            3'b100: begin 
                tx_frame_reg <= 1'b1;
                tx_data_posedge_reg <= tx_data_d1_reg[11:6];
                tx_data_negedge_reg <= tx_data_q1_reg[11:6];
            end
            3'b011:begin                //2R2T
                tx_frame_reg <= 1'b0;
                tx_data_posedge_reg <= tx_data_d2_reg[5:0];
                tx_data_negedge_reg <= tx_data_q2_reg[5:0];
            end
            3'b001:begin
                tx_frame_reg <= 1'b1;
                tx_data_posedge_reg <= tx_data_d1_reg[5:0];
                tx_data_negedge_reg <= tx_data_q1_reg[5:0];
            end       
            3'b000:begin
                tx_frame_reg <= 1'b1;
                tx_data_posedge_reg <= tx_data_d1_reg[11:6];
                tx_data_negedge_reg <= tx_data_q1_reg[11:6];
            end     
            3'b010:begin
                tx_frame_reg <= 1'b0;
                tx_data_posedge_reg <= tx_data_d2_reg[11:6];
                tx_data_negedge_reg <= tx_data_q2_reg[11:6];
            end
            default : begin
                tx_frame_reg <= 1'b0;
                tx_data_posedge_reg <= 0;
                tx_data_negedge_reg <= 0;		
            end
            endcase
        end
	end
end
/*-------------------output oddr buf logical---------*/
wire 			tx_clk;
wire 			tx_frame_out;
wire 	[5:0]	tx_data_out;
    //CLK
 ODDRE1 #(
   .IS_C_INVERTED(1'b0),      // Optional inversion for C
   .IS_D1_INVERTED(1'b0),     // Unsupported, do not use
   .IS_D2_INVERTED(1'b0),     // Unsupported, do not use
   .SRVAL(1'b0)               // Initializes the ODDRE1 Flip-Flops to the specified value (1'b0, 1'b1)
   ) ODDR_data_clk_inst  (
    .Q             (tx_clk), // 1-bit DDR output
    .C             (data_clk),  // 1-bit clock input
    .D1            (1'b0),   // 1-bit data input (positive edge)
    .D2            (1'b1),   // 1-bit data input (negative edge)
    .SR             (1'b0)         // 1-bit reset
	); 

   OBUFDS #(
   ) OBUFDS_data_clk_inst (
      .O(tx_clk_out_p),     // Diff_p output (connect directly to top-level port)
      .OB(tx_clk_out_n),   // Diff_n output (connect directly to top-level port)
      .I(tx_clk)      // Buffer input
   );
//FRAME
  ODDRE1 #(
   .IS_C_INVERTED(1'b0),      // Optional inversion for C
   .IS_D1_INVERTED(1'b0),     // Unsupported, do not use
   .IS_D2_INVERTED(1'b0),     // Unsupported, do not use
   .SRVAL(1'b0)               // Initializes the ODDRE1 Flip-Flops to the specified value (1'b0, 1'b1)
   ) ODDR_frame_inst (
	.Q             (tx_frame_out), // 1-bit DDR output
	.C             (data_clk),  // 1-bit clock input
	.D1            (tx_frame_reg),  // 1-bit data input (positive edge)
	.D2            (tx_frame_reg),// 1-bit data input (negative edge)
	.SR             (1'b0)         // 1-bit reset
    );        
		
   OBUFDS #(
   ) OBUFDS_frame_inst (
      .O(tx_frame_out_p),     // Diff_p output (connect directly to top-level port)
      .OB(tx_frame_out_n),   // Diff_n output (connect directly to top-level port)
      .I(tx_frame_out)      // Buffer input
   );
  //DATA
    genvar i;
    generate
        for(i=0;i<6;i=i+1) begin
           ODDRE1 #(
           .IS_C_INVERTED(1'b0),      // Optional inversion for C
           .IS_D1_INVERTED(1'b0),     // Unsupported, do not use
           .IS_D2_INVERTED(1'b0),     // Unsupported, do not use
           .SRVAL(1'b0)               // Initializes the ODDRE1 Flip-Flops to the specified value (1'b0, 1'b1)
           ) ODDR_tx_data_inst(
			.Q             (tx_data_out[i]), // 1-bit DDR output
			.C             (data_clk),  // 1-bit clock input
			.D1            (tx_data_posedge_reg[i]),  // 1-bit data input (positive edge)
			.D2            (tx_data_negedge_reg[i]),// 1-bit data input (negative edge)
			.SR             (1'b0)         // 1-bit reset
			);        
           OBUFDS #(
           ) OBUFDS_tx_data_inst (
              .O(tx_data_out_p[i]),     // Diff_p output (connect directly to top-level port)
              .OB(tx_data_out_n[i]),   // Diff_n output (connect directly to top-level port)
              .I(tx_data_out[i])      // Buffer input
           );		
        end
    endgenerate

endmodule