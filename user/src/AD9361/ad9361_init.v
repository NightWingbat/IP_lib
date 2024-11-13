////////////////////////////////////////////////////////////////////////////////
// File:	ad9361_init.v
// Author:	FPGA_master <1975670198@qq.com>
// Description:
//	ad9361 init module.
//
////////////////////////////////////////////////////////////////////////////////
module ad9361_init(
	input 				clk,
	input 				rst_n,
	output 	reg			read,
	output 	reg			write,
	output 	reg	[9:0]	address,
	output 	reg	[7:0]	writedata,
	input 		[7:0]	readdata,
	input 				waitrequest,
	output	reg			chip_rst_n,
	output	 	[11:0]  init_index,
	output 	reg			init_done
);

//`define MODELSIM
    `define SPI_CLK_FREQ       25 //MHz	
    `include "ad9361_lut.v"
	reg	   [11:0]	index;
	(* mark_debug = "true" *)reg	   [2:0]	state;
	reg    [31:0] 	delay_cnt;
	reg    [18:0]	command;
	
    assign init_index = index;
	always @ (posedge clk)	command <= ad9361_lut(index);
		
	always @ (posedge clk or negedge rst_n)
	begin
		if(!rst_n) begin 
            index       <= 0;
            write       <= 0;
            read        <= 0;
            address     <= 0;
            writedata   <= 0;
            init_done   <= 0;
            state       <= 0;
            delay_cnt   <= 0;
            chip_rst_n  <= 0;
        end
		else 
			case (state)
                3'd0    :   begin
                                if(delay_cnt != `SPI_CLK_FREQ * 1000)   //1ms
                                    delay_cnt <= delay_cnt+1;
                                else 
                                    begin
                                        chip_rst_n  <= 1;
                                        delay_cnt   <= 0;
                                        state       <= 1;
                                    end
                            end
                            
				3'd1    :   begin 
                                {write, address, writedata} <= command;
                                read <= ~command[18];
                                state <= 2;
                            end
                            
				3'd2    :   begin
                                if(~waitrequest) begin 
                                    state <= read ? 3 : 4;
                                end
				            end
				            
				3'd3    :   begin
                                case(command)
                                    {1'b0,10'h037,8'h08}:begin if( readdata[3]) state<=state+1;else state<=1;end//ReadPartNumber   		
                                    {1'b0,10'h05E,8'h80}:begin if( readdata[7]) state<=state+1;else state<=1;end//BBPLL_INDEX  			
                                    {1'b0,10'h244,8'h80}:begin if( readdata[7]) state<=state+1;else state<=1;end//RX_CPCAL_INDEX  		
                                    {1'b0,10'h284,8'h80}:begin if( readdata[7]) state<=state+1;else state<=1;end//TX_CPCAL_INDEX  		
                                    {1'b0,10'h247,8'h02}:begin if( readdata[1]) state<=state+1;else state<=1;end//RX_PLL_LOCK_INDEX 		
                                    {1'b0,10'h287,8'h02}:begin if( readdata[1]) state<=state+1;else state<=1;end//TX_PLL_LOCK_INDEX 		
                                    {1'b0,10'h016,8'h80}:begin if(!readdata[7]) state<=state+1;else state<=1;end//RX_FIR_TUNE_INDEX 		
                                    {1'b0,10'h016,8'h40}:begin if(!readdata[6]) state<=state+1;else state<=1;end//TX_FIR_TUNE_INDEX 		
                                    {1'b0,10'h016,8'h01}:begin if(!readdata[0]) state<=state+1;else state<=1;end//BBDC_OFFSET_CAL_INDEX 	
                                    {1'b0,10'h016,8'h02}:begin if(!readdata[1]) state<=state+1;else state<=1;end//RFDC_OFFSET_CAL_INDEX	
                                    {1'b0,10'h016,8'h10}:begin if(!readdata[4]) state<=state+1;else state<=1;end//TX_QUAD_CAL_INDEX		
                                    {1'b0,10'h016,8'h20}:begin if(!readdata[5]) state<=state+1;else state<=1;end//RX_QUAD_CAL_INDEX	
                                    {1'b0,10'h017,8'h1A}:begin if(readdata[3:0]==4'd10) state<=state+1;else state<=1;end//RX_QUAD_CAL_INDEX	
                                    {1'b0,10'h3FF,8'h01}:begin											//wait 1ms
                                                             if (delay_cnt != `SPI_CLK_FREQ * 1000) 
                                                                 delay_cnt <= delay_cnt+1;								
                                                             else 
                                                                 begin 
                                                                     delay_cnt <= 0;
                                                                     state <= state + 1;
                                                                 end 
                                                         end
                                    {1'b0,10'h3FF,8'h14}:begin											//wait 20ms
                                                             if (delay_cnt != `SPI_CLK_FREQ * 20000) 
                                                                 delay_cnt <= delay_cnt + 1;							
                                                             else 
                                                                 begin
                                                                     delay_cnt <= 0;
                                                                     state <= state + 1;
                                                                 end	
                                                         end		  	  														
                                    {1'b0,10'h3FF,8'hFF}:begin state <= 7; end								//command end
                                    default:    begin state <= state + 1;end
                                endcase
                            end
				3'd4    :   begin 
				                index <= index + 1;
				                state <= state + 1;
                            end
				3'd5    :   begin 
				                state <= state + 1;
                            end
				3'd6    :   begin 
				                state <= 1;
                            end
				3'd7    :   begin 
                                init_done <= 1;
                            end
				default :   state <= 0;
			endcase
	end
	
endmodule