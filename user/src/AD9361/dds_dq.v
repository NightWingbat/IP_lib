`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////


module dds_dq(
	input 		dq_data_clk,
	input 		phy_mode,
	input 		rst_n,
	output reg  dac_valid,
	output reg [11:0] dac_d1,
	output reg [11:0] dac_d2,
	output reg [11:0] dac_q1,
	output reg [11:0] dac_q2,

	input [11:0] dds_inc,

	input [31:0]dds_tdata,
	input wire dds_t_valid,

	output reg [15:0]data_phase,
	output reg phase_tvalid    
    );

	parameter PHY_MODE_1R1T=1;
	parameter PHY_MODE_2R2T=0;
    wire [15:0]dds_phase_in;
    wire dds_phase_valid;
    
    reg [1:0] cnt_reg;
    always @(posedge dq_data_clk) begin
        if(!rst_n) begin
            cnt_reg <='d0;
        end
        else if (phy_mode == PHY_MODE_2R2T) begin
            cnt_reg <= cnt_reg + 1'b1;
        end
    end
    //phase tdata
    always @(posedge dq_data_clk ) begin
        if(!rst_n) begin
            phase_tvalid <= 1'b0;
        end 
        else if(phy_mode==PHY_MODE_1R1T ) begin //1r1t
            phase_tvalid <= phase_tvalid + 1;
        end
        else if (phy_mode == PHY_MODE_2R2T && cnt_reg == 'd3) begin
            phase_tvalid <= 1'b1;
        end
        else begin
            phase_tvalid <= 1'b0;
        end
    end
    //dds phase auto increament
    always @(posedge dq_data_clk) begin
        if(!rst_n) begin
            data_phase <='d0;
        end
        else if (phase_tvalid == 1'b1) begin
            data_phase <= data_phase + dds_inc;
        end
    end

    always @(posedge dq_data_clk) begin
        if(!rst_n) begin
            dac_valid <= 1'b0;
            dac_d1 <= 'd0;
            dac_q1 <= 'd0;
            dac_d2 <= 'd0;
            dac_q2 <= 'd0;
        end
        else begin
            dac_valid <= dds_t_valid;
            dac_d1 <= dds_tdata[27:16];
            dac_q1 <= dds_tdata[11:0];
            dac_d2 <= dds_tdata[27:16];
            dac_q2 <= dds_tdata[11:0];
        end
    end
	endmodule

