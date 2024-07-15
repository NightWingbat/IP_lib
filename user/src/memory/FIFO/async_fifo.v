`timescale 1 ns / 1 ns

/*
*   Date : 2024-07-02
*   Author : cjh
*   Module Name:   async_fifo.v - async_fifo
*   Target Device: [Target FPGA and ASIC Device]
*   Tool versions: vivado 18.3 & DC 2016
*   Revision Historyc :
*   Revision :
*       Revision 0.01 - File Created
*   Description : The synchronous dual-port SRAM has A, B ports to access the same memory location. 
*                 Both ports can be independently read or written from the memory array.
*                 1. In Vivado, EDA can directly use BRAM for synthesis.
*                 2. The module continuously outputs data when enabled, and when disabled, 
*                    it outputs the last data.
*                 3. When writing data to the same address on ports A and B simultaneously, 
*                    the write operation from port B will take precedence.
*                 4. In write mode, the current data input takes precedence for writing, 
*                    and the data from the address input at the previous clock cycle is read out. 
*                    In read mode, the data from the address input at the current clock cycle 
*                    is directly read out. In write mode, when writing to different addresses, 
*                    the data corresponding to the current address input at the current clock cycle 
*                    is directly read out.
*   Dependencies: none(FPGA) auto for BRAM in vivado | RAM_IP with IC 
*   Company : ncai Technology .Inc
*   Copyright(c) 1999, ncai Technology Inc, All right reserved
*/

// wavedom
/*
{signal: [
  {name: 'clka/b', wave: '101010101'},
  {name: 'ena/b', wave: '01...0...'},
  {name: 'wea/b', wave: '01...0...'},
  {name: 'addra/b', wave: 'x3...3.x.', data: ['addr0','addr2']},
  {name: 'dina/b', wave: 'x4.4.x...', data: ['data0','data1']},
  {name: 'douta/b', wave: 'x..5.5.x.', data: ['data0','data2']},
]}
*/

module async_fifo #(
    //The width parameter for writing data
    parameter    INPUT_WIDTH  = 128,
    //The width parameter for reading data
    parameter    OUTPUT_WIDTH = 16,
    /*
      The depth parameter of writing mem
      if INPUT_WIDTH < OUTPUT_WIDTH, WR_DEPTH = (OUTPUT_WIDTH/INPUT_WIDTH) * RD_DEPTH
    */
    parameter    WR_DEPTH     = 1024,
    /*
      The depth parameter of reading mem
      if INPUT_WIDTH > OUTPUT_WIDTH, RD_DEPTH = (INPUT_WIDTH/OUTPUT_WIDTH) * WR_DEPTH
    */
    parameter    RD_DEPTH     = 8192,
    //The parameter of reading method
    parameter    MODE         = "FWFT",
    //Is data stored from high bits or from low bits
    parameter    DIRECTION    = "MSB"
) (
    //wr_port

    //wr_port clock input
    input                              wr_clk,
    //wr_port reset active low
    input                              wr_rst,
    //wr_port enable active high
    input                              wr_en,
    //wr_port data input
    input   [INPUT_WIDTH - 1 : 0]      din,

    //rd_port

    //rd_port clock input
    input                              rd_clk,
    //rd_port reset active low
    input                              rd_rst,
    //rd_port enable active high
    input                              rd_en,
    //rd_port rd_data valid active high
    output  reg                        valid,
    //rd_port data output
    output  reg [OUTPUT_WIDTH - 1 : 0] dout,

    output                             full,
    output                             empty,

    //wr_port num of the input data
    output  reg [$clog2(WR_DEPTH) : 0] wr_data_count,
    //rd_port num of the output data
    output  reg [$clog2(RD_DEPTH) : 0] rd_data_count
);

//the number of ram needed to be operated
localparam RAM_NUM      = (INPUT_WIDTH >= OUTPUT_WIDTH) ? (INPUT_WIDTH/OUTPUT_WIDTH) : (OUTPUT_WIDTH/INPUT_WIDTH);

//the width of every operated ram
localparam RAM_WIDTH    = (INPUT_WIDTH >= OUTPUT_WIDTH) ? OUTPUT_WIDTH : INPUT_WIDTH;

//the depth of every operated ram
localparam RAM_DEPTH    = (INPUT_WIDTH >= OUTPUT_WIDTH) ? WR_DEPTH : (WR_DEPTH/RAM_NUM);

//the width of ram_wr_data
localparam RAM_WR_WIDTH = (INPUT_WIDTH >= OUTPUT_WIDTH) ? INPUT_WIDTH : OUTPUT_WIDTH;

//the width or ram_rd_data
localparam RAM_RD_WIDTH = RAM_WR_WIDTH;

reg  [$clog2(WR_DEPTH) : 0]      wr_ptr;         //mark the location of fifo writing
reg  [$clog2(RD_DEPTH) : 0]      rd_ptr;         //mark the location of fifo reading

reg  [$clog2(WR_DEPTH) : 0]      wr_ptr_d1;         
reg  [$clog2(RD_DEPTH) : 0]      rd_ptr_d1;
reg  [$clog2(RD_DEPTH) : 0]      rd_ptr_fwft;
reg  [$clog2(RD_DEPTH) : 0]      rd_ptr_fwft_d1;

//DPRAM_port
wire [RAM_NUM - 1 : 0]           ram_wr_en;     //DPRAM write enable signal
wire [RAM_NUM - 1 : 0]           ram_rd_en;     //DPRAM read  enable signal

wire [$clog2(RAM_DEPTH)     : 0] ram_wr_addr;   //DPRAM write address
wire [$clog2(RAM_DEPTH)     : 0] ram_rd_addr;   //DPRAM read  address

wire [RAM_WR_WIDTH      - 1 : 0] ram_wr_data;   //DPRAM write data
wire [RAM_RD_WIDTH      - 1 : 0] ram_rd_data;   //DPRAM read data

//full and empty judge
wire [$clog2(RAM_DEPTH)     : 0] ram_wr_addr_g;     //the gray code of ram_wr_addr
wire [$clog2(RAM_DEPTH)     : 0] ram_rd_addr_g;     //the gray code of ram_rd_addr

reg  [$clog2(RAM_DEPTH)     : 0] ram_wr_addr_g_d1;  //take one beat ram_wr_addr_g
reg  [$clog2(RAM_DEPTH)     : 0] ram_wr_addr_g_d2;  //take one beat ram_rd_addr_g

reg  [$clog2(RAM_DEPTH)     : 0] ram_rd_addr_g_d1; //take two beat ram_wr_addr_g
reg  [$clog2(RAM_DEPTH)     : 0] ram_rd_addr_g_d2; //take two beat ram_rd_addr_g

reg  [$clog2(RAM_DEPTH)     : 0] ram_wr_addr_b;    //the binary of the gray code of ram_wr_addr in read  clock domain
reg  [$clog2(RAM_DEPTH)     : 0] ram_rd_addr_b;    //the binary of the gray code of ram_rd_addr in write clock domain


reg                              fwft_valid;       //indicating signal for fwft mode

//mark the position of writing
always @(posedge wr_clk or negedge wr_rst) begin
    if(wr_rst == 1'b0)begin
        wr_ptr <= 1'b0;
    end
    else if(wr_en & (~full))begin
        wr_ptr <= wr_ptr + 1'b1;
    end
    else begin
        wr_ptr <= wr_ptr;
    end
end

//mark the position of reading
always @(posedge rd_clk or negedge rd_rst) begin
    if(rd_rst == 1'b0)begin
        rd_ptr <= 1'b0;
    end
    else if(rd_en & (~empty))begin
        rd_ptr <= rd_ptr + 1'b1;
    end
    else begin
        rd_ptr <= rd_ptr;
    end
end

//fwft_valid signal is used for fwft mode.When rd_en is set high,fwft_valid is set high
always @(posedge rd_clk or negedge rd_rst) begin
    if(rd_rst == 1'b0)begin
        fwft_valid <= 1'b0;
    end
    else if(rd_en)begin
        fwft_valid <= 1'b1;
    end
    else begin
        fwft_valid <= fwft_valid;
    end
end

//when in fwft mode,rd_ptr need to add one to pre-extract from fifo
always @(*) begin
    if(rd_rst == 1'b0)begin
        rd_ptr_fwft <= 1'b0;
    end
    else if(rd_en | fwft_valid)begin
        rd_ptr_fwft <= rd_ptr + 1'b1;
    end
    else begin
        rd_ptr_fwft <= rd_ptr;
    end
end

//buffer
always @(posedge rd_clk or negedge rd_rst) begin
    if(rd_rst == 1'b0)begin
        rd_ptr_d1 <= 1'b0;
    end
    else begin
        rd_ptr_d1 <= rd_ptr;
    end
end

always @(posedge rd_clk or negedge rd_rst) begin
    if(rd_rst == 1'b0)begin
        rd_ptr_fwft_d1 <= 1'b0;
    end
    else begin
        rd_ptr_fwft_d1 <= rd_ptr_fwft;
    end
end

genvar i;

//ram_rd_en and valid
generate if(MODE == "Standard") begin : standard_mode_read

    for(i=0;i<RAM_NUM;i=i+1)begin
        assign ram_rd_en[i] = rd_en & (~empty);
    end

    always @(posedge rd_clk or negedge rd_rst) begin
        if(rd_rst == 1'b0)begin
            valid <= 1'b0;
        end
        else begin
            valid <= rd_en & (~empty);
        end
    end

end
endgenerate

generate if(MODE == "FWFT") begin : fwft_mode_read

    reg empty_d1;
    
    for(i=0;i<RAM_NUM;i=i+1)begin
        assign ram_rd_en[i] = ~empty;
    end

    always @(posedge rd_clk or negedge rd_rst) begin
        if(rd_rst == 1'b0)begin
            empty_d1 <= 1'b0;
        end
        else begin
            empty_d1 <= empty;
        end
    end

    always @(*) begin
        if(rd_rst == 1'b0)begin
            valid <= 1'b0;
        end
        else begin
            valid <= rd_en & (~empty_d1);
        end
    end

end
endgenerate

generate if(INPUT_WIDTH >= OUTPUT_WIDTH) begin : BIG_TO_SMALL_RAM

    wire [$clog2(RD_DEPTH) : 0] channel_sel; //choose which ram rd_data to output

    if(MODE == "Standard")begin
        assign channel_sel = rd_ptr_d1;
    end
    else if(MODE == "FWFT")begin
        assign channel_sel = rd_ptr_fwft_d1;
    end

    assign ram_wr_addr = wr_ptr;
    
    for(i=0;i<RAM_NUM;i=i+1)begin

        assign ram_wr_en[i] = wr_en & (~full);

        DPRAM #(
	        .WIDTH 	( RAM_WIDTH  ),
	        .DEPTH 	( RAM_DEPTH  ))
        u_DPRAM(
	        .clka  	( wr_clk      ),
	        .ena   	( 1'b1        ),
	        .wea   	( ram_wr_en[i]),
	        .addra 	( ram_wr_addr[$clog2(RAM_DEPTH) - 1 : 0]),
	        .dina  	( din[(i+1) * RAM_WIDTH - 1 : i * RAM_WIDTH]),
	        .douta 	(             ),
	        .clkb  	( rd_clk      ),
	        .enb   	( ram_rd_en[i]),
	        .web   	(             ),
	        .addrb 	( ram_rd_addr[$clog2(RAM_DEPTH) - 1 : 0]),
	        .dinb  	(             ),
	        .doutb 	( ram_rd_data[(i+1) * RAM_WIDTH - 1 : i * RAM_WIDTH]));
    end

    //ram_rd_addr
    if(MODE == "Standard")begin
        assign ram_rd_addr = rd_ptr >> $clog2(RAM_NUM);
    end
    else if(MODE == "FWFT")begin
        assign ram_rd_addr = rd_ptr_fwft >> $clog2(RAM_NUM);
    end

    //rd_data
    case(RAM_NUM)

        4'd1:begin
            always @(*) begin
                if(rd_rst == 1'b0)begin
                    dout <= 1'b0;
            end
                else begin
                    dout <= ram_rd_data;
                end
            end
        end

        4'd2:begin
            if(DIRECTION == "MSB")begin
                always @(*) begin
                    if(rd_rst == 1'b0)begin
                        dout <= 1'b0;
                end
                    else begin
                        case(channel_sel[0])
                            1'b0 : dout <= ram_rd_data[OUTPUT_WIDTH * 2 - 1 : OUTPUT_WIDTH];
                            1'b1 : dout <= ram_rd_data[OUTPUT_WIDTH - 1 : 0];
                        endcase
                    end
                end
            end
            else if(DIRECTION == "LSB")begin
                always @(*) begin
                    if(rd_rst == 1'b0)begin
                        dout <= 1'b0;
                end
                    else begin
                        case(channel_sel[0])
                            1'b0 : dout <= ram_rd_data[OUTPUT_WIDTH - 1 : 0];
                            1'b1 : dout <= ram_rd_data[OUTPUT_WIDTH * 2 - 1 : OUTPUT_WIDTH];
                        endcase
                    end
                end
            end
        end

        4'd4:begin
            if(DIRECTION == "MSB")begin
                always @(*) begin
                    if(rd_rst == 1'b0)begin
                        dout <= 1'b0;
                end
                    else begin
                        case(channel_sel[1:0])
                            2'b00 : dout <= ram_rd_data[OUTPUT_WIDTH * 4 - 1 : OUTPUT_WIDTH * 3];
                            2'b01 : dout <= ram_rd_data[OUTPUT_WIDTH * 3 - 1 : OUTPUT_WIDTH * 2];
                            2'b10 : dout <= ram_rd_data[OUTPUT_WIDTH * 2 - 1 : OUTPUT_WIDTH];
                            2'b11 : dout <= ram_rd_data[OUTPUT_WIDTH - 1 : 0];
                        endcase
                    end
                end
            end
            else if(DIRECTION == "LSB")begin
                always @(*) begin
                    if(rd_rst == 1'b0)begin
                        dout <= 1'b0;
                end
                    else begin
                        case(channel_sel[1:0])
                            2'b00 : dout <= ram_rd_data[OUTPUT_WIDTH - 1 : 0];
                            2'b01 : dout <= ram_rd_data[OUTPUT_WIDTH * 2 - 1 : OUTPUT_WIDTH];
                            2'b10 : dout <= ram_rd_data[OUTPUT_WIDTH * 3 - 1 : OUTPUT_WIDTH * 2];
                            2'b11 : dout <= ram_rd_data[OUTPUT_WIDTH * 4 - 1 : OUTPUT_WIDTH * 3];
                        endcase
                    end
                end
            end
        end

        4'd8:begin
            if(DIRECTION == "MSB")begin
                always @(*) begin
                    if(rd_rst == 1'b0)begin
                        dout <= 1'b0;
                end
                    else begin
                        case(channel_sel[2:0])
                            3'b000 : dout <= ram_rd_data[OUTPUT_WIDTH * 8 - 1 : OUTPUT_WIDTH * 7];
                            3'b001 : dout <= ram_rd_data[OUTPUT_WIDTH * 7 - 1 : OUTPUT_WIDTH * 6];
                            3'b010 : dout <= ram_rd_data[OUTPUT_WIDTH * 6 - 1 : OUTPUT_WIDTH * 5];
                            3'b011 : dout <= ram_rd_data[OUTPUT_WIDTH * 5 - 1 : OUTPUT_WIDTH * 4];
                            3'b100 : dout <= ram_rd_data[OUTPUT_WIDTH * 4 - 1 : OUTPUT_WIDTH * 3];
                            3'b101 : dout <= ram_rd_data[OUTPUT_WIDTH * 3 - 1 : OUTPUT_WIDTH * 2];
                            3'b110 : dout <= ram_rd_data[OUTPUT_WIDTH * 2 - 1 : OUTPUT_WIDTH];
                            3'b111 : dout <= ram_rd_data[OUTPUT_WIDTH - 1 : 0];
                        endcase
                    end
                end
            end
            else if(DIRECTION == "LSB")begin
                always @(*) begin
                    if(rd_rst == 1'b0)begin
                        dout <= 1'b0;
                end
                    else begin
                        case(channel_sel[2:0])
                            3'b000 : dout <= ram_rd_data[OUTPUT_WIDTH - 1 : 0];
                            3'b001 : dout <= ram_rd_data[OUTPUT_WIDTH * 2 - 1 : OUTPUT_WIDTH];
                            3'b010 : dout <= ram_rd_data[OUTPUT_WIDTH * 3 - 1 : OUTPUT_WIDTH * 2];
                            3'b011 : dout <= ram_rd_data[OUTPUT_WIDTH * 4 - 1 : OUTPUT_WIDTH * 3];
                            3'b100 : dout <= ram_rd_data[OUTPUT_WIDTH * 5 - 1 : OUTPUT_WIDTH * 4];
                            3'b101 : dout <= ram_rd_data[OUTPUT_WIDTH * 6 - 1 : OUTPUT_WIDTH * 5];
                            3'b110 : dout <= ram_rd_data[OUTPUT_WIDTH * 7 - 1 : OUTPUT_WIDTH * 6];
                            3'b111 : dout <= ram_rd_data[OUTPUT_WIDTH * 8 - 1 : OUTPUT_WIDTH * 7];
                        endcase
                    end
                end
            end
        end

    endcase

    //wr_data_count
    always @(*) begin
        if(wr_rst == 1'b0)begin
            wr_data_count <= 1'b0;
        end
        else if(ram_wr_addr_g[$clog2(RAM_DEPTH)] ^ ram_rd_addr_g_d2[$clog2(RAM_DEPTH)])begin
            wr_data_count <= {1'b1,ram_wr_addr[$clog2(RAM_DEPTH) - 1 : 0]} - {1'b0,ram_rd_addr_b[$clog2(RAM_DEPTH) - 1 : 0]};
        end
        else begin
            wr_data_count <= ram_wr_addr - ram_rd_addr_b;
        end
    end

    //rd_data_count
    always @(*) begin
        if(rd_rst == 1'b0)begin
            rd_data_count <= 1'b0;
        end
        else if(ram_rd_addr_g[$clog2(RAM_DEPTH)] ^ ram_wr_addr_g_d2[$clog2(RAM_DEPTH)])begin
            rd_data_count <= RAM_NUM * {1'b1,ram_wr_addr_b[$clog2(RAM_DEPTH) - 1 : 0]} - {1'b0,rd_ptr[$clog2(RD_DEPTH) - 1 : 0]};
        end
        else begin
            rd_data_count <= RAM_NUM * ram_wr_addr_b - rd_ptr;
        end
    end

end
endgenerate

generate if(INPUT_WIDTH < OUTPUT_WIDTH) begin : SMALL_TO_BIG_RAM
    
    reg  [RAM_NUM - 1 : 0]           wr_en_d1;      //when input_width < output_width,enable each memory sequentially

    always @(posedge wr_clk or negedge wr_rst) begin
        if(wr_rst == 1'b0)begin
            wr_en_d1 <= 1'b1;
        end
        else if(wr_en)begin
            wr_en_d1 <= {wr_en_d1[RAM_NUM - 2 : 0],wr_en_d1[RAM_NUM - 1]};
        end
        else begin
            wr_en_d1 <= wr_en_d1;
        end
    end

    assign ram_wr_addr = wr_ptr >> $clog2(RAM_NUM);

    for(i=0;i<RAM_NUM;i=i+1)begin

        assign ram_wr_en[i] = wr_en & wr_en_d1[i] & (~full);

        if(DIRECTION == "LSB")begin
            DPRAM #(
	            .WIDTH 	( RAM_WIDTH  ),
	            .DEPTH 	( RAM_DEPTH  ))
            u_DPRAM(
	            .clka  	( wr_clk      ),
	            .ena   	( 1'b1        ),
	            .wea   	( ram_wr_en[i]),
	            .addra 	( ram_wr_addr[$clog2(RAM_DEPTH) - 1 : 0]),
	            .dina  	( din         ),
	            .douta 	(             ),
	            .clkb  	( rd_clk      ),
	            .enb   	( ram_rd_en[i]),
	            .web   	(             ),
	            .addrb 	( ram_rd_addr[$clog2(RAM_DEPTH) - 1 : 0]),
	            .dinb  	(             ),
	            .doutb 	( ram_rd_data[(i+1) * RAM_WIDTH - 1 : i * RAM_WIDTH]));
        end
        else if(DIRECTION == "MSB")begin
            DPRAM #(
	            .WIDTH 	( RAM_WIDTH  ),
	            .DEPTH 	( RAM_DEPTH  ))
            u_DPRAM(
	            .clka  	( wr_clk      ),
	            .ena   	( 1'b1        ),
	            .wea   	( ram_wr_en[i]),
	            .addra 	( ram_wr_addr[$clog2(RAM_DEPTH) - 1 : 0]),
	            .dina  	( din         ),
	            .douta 	(             ),
	            .clkb  	( rd_clk      ),
	            .enb   	( ram_rd_en[i]),
	            .web   	(             ),
	            .addrb 	( ram_rd_addr[$clog2(RAM_DEPTH) - 1 : 0]),
	            .dinb  	(             ),
	            .doutb 	( ram_rd_data[RAM_RD_WIDTH - i * RAM_WIDTH - 1 : RAM_RD_WIDTH - (i+1) * RAM_WIDTH]));
        end
    end

    //ram_rd_addr
    if(MODE == "Standard")begin
        assign ram_rd_addr = rd_ptr;
    end
    else if(MODE == "FWFT")begin
        assign ram_rd_addr = rd_ptr_fwft;
    end

    //rd_data
    always @(*) begin
        if(rd_rst == 1'b0)begin
            dout <= 1'b0;
        end
        else begin
            dout <= ram_rd_data;
        end
    end

    //wr_data_count
    always @(*) begin
        if(wr_rst == 1'b0)begin
            wr_data_count <= 1'b0;
        end
        else if(ram_wr_addr_g[$clog2(RAM_DEPTH)] ^ ram_rd_addr_g_d2[$clog2(RAM_DEPTH)])begin
            wr_data_count <= {1'b1,wr_ptr[$clog2(WR_DEPTH) - 1 : 0]} - RAM_NUM * {1'b0,ram_rd_addr_b[$clog2(RAM_DEPTH) - 1 : 0]};
        end
        else begin
            wr_data_count <= wr_ptr - RAM_NUM * ram_rd_addr_b;
        end
    end

    //rd_data_count
    always @(*) begin
        if(rd_rst == 1'b0)begin
            rd_data_count  <= 1'b0;
        end
        else if(ram_rd_addr_g[$clog2(RAM_DEPTH)] ^ ram_wr_addr_g_d2[$clog2(RAM_DEPTH)])begin
             rd_data_count <= {1'b1,ram_wr_addr_b[$clog2(RAM_DEPTH) - 1 : 0]} - {1'b0,ram_rd_addr[$clog2(RAM_DEPTH) - 1 : 0]};
        end
        else begin
            rd_data_count  <= ram_wr_addr_b - ram_rd_addr;
        end
    end

end
endgenerate

//full and empty operation
integer k;

assign ram_wr_addr_g = ram_wr_addr ^ (ram_wr_addr >>> 1);   //ram_wr_addr binary to gray
assign ram_rd_addr_g = ram_rd_addr ^ (ram_rd_addr >>> 1);   //ram_rd_addr binary to gray

//ram_wr_addr_g_d2 gray to binary
always @(*) begin
    if(rd_rst == 1'b0)begin
        ram_wr_addr_b <= 1'b0;
    end
    else begin
        ram_wr_addr_b[$clog2(RAM_DEPTH)] <= ram_wr_addr_g_d2[$clog2(RAM_DEPTH)];
        for(k=1;k<=$clog2(RAM_DEPTH);k=k+1)begin
            ram_wr_addr_b[k-1]    <= ram_wr_addr_g_d2[k-1] ^ ram_wr_addr_b[k];
        end
    end
end

//ram_rd_addr_g_d2 gray to binary
always @(*) begin
    if(wr_rst == 1'b0)begin
        ram_rd_addr_b <= 1'b0;
    end
    else begin
        ram_rd_addr_b[$clog2(RAM_DEPTH)] <= ram_rd_addr_g_d2[$clog2(RAM_DEPTH)];
        for(k=1;k<=$clog2(RAM_DEPTH);k=k+1)begin
            ram_rd_addr_b[k-1]    <= ram_rd_addr_g_d2[k-1] ^ ram_rd_addr_b[k];
        end
    end
end

//in read clock domain,ram_wr_addr_g takes two beats 
always @(posedge rd_clk or negedge rd_rst) begin
    if(rd_rst == 1'b0)begin
        ram_wr_addr_g_d1 <= 1'b0;
        ram_wr_addr_g_d2 <= 1'b0;
    end
    else begin
        ram_wr_addr_g_d1 <= ram_wr_addr_g;
        ram_wr_addr_g_d2 <= ram_wr_addr_g_d1;
    end
end

//in write clock domain,ram_rd_addr_g takes two beats 
always @(posedge wr_clk or negedge rd_rst) begin
    if(rd_rst == 1'b0)begin
        ram_rd_addr_g_d1 <= 1'b0;
        ram_rd_addr_g_d2 <= 1'b0;
    end
    else begin
        ram_rd_addr_g_d1 <= ram_rd_addr_g;
        ram_rd_addr_g_d2 <= ram_rd_addr_g_d1;
    end
end

assign full          = (ram_wr_addr_g[$clog2(RAM_DEPTH)]         != ram_rd_addr_g_d2[$clog2(RAM_DEPTH)]) && 
                       (ram_wr_addr_g[$clog2(RAM_DEPTH) - 1]     != ram_rd_addr_g_d2[$clog2(RAM_DEPTH) - 1]) &&
                       (ram_wr_addr_g[$clog2(RAM_DEPTH) - 2 : 0] == ram_rd_addr_g_d2[$clog2(RAM_DEPTH) - 2 : 0]) ? 1'b1 : 1'b0;

assign empty         = (ram_rd_addr_g == ram_wr_addr_g_d2) ? 1'b1 : 1'b0;

endmodule  //async_fifo
