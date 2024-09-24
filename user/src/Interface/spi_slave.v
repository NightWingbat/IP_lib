module spi_slave #(
    //The parameter for clock idle state level
    parameter    CPOL       = 0,
    //The parameter for clock phase
    parameter    CPHA       = 0,
    //chip selection enable level
    parameter    CE_LEVEL   = 0,
    //The width parameter for writing data
    parameter    DATA_WIDTH = 24
) (
    //system clock input
    input                           clock,
    //system reset active low
    input                           reset,
    //data transmit
    input      [DATA_WIDTH - 1 : 0] tx_data,
    //data receive
    output reg [DATA_WIDTH - 1 : 0] rx_data,
    //once SPI data interaction finished
    output reg                      spi_done,
    //spi_phy port

    //spi clock
    input                           sclk,
    //select slave device chips
    input                           ce,
    //master output slave input
    input                           mosi,
    //master input slave output
    output reg                      miso

);

reg                              sclk_d1;
reg                              spi_sclk;
reg                              spi_sclk_d1;


reg                              ce_d1;
reg                              spi_ce;

reg                              mosi_d1;
reg                              spi_mosi;

wire                             sample_edge;
wire                             toggle_edge;

reg [$clog2(DATA_WIDTH) - 1 : 0] bit_cnt;
reg [DATA_WIDTH - 1 : 0]         rx_data_d1;

//Synchronize shooting to eliminate metastable states
assign spi_sclk_ris = (~spi_sclk_d1) & spi_sclk;
assign spi_sclk_fal = spi_sclk_d1    & (~spi_sclk);

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        sclk_d1     <= 1'b0;
        spi_sclk    <= 1'b0;
        spi_sclk_d1 <= 1'b0;
    end
    else begin
        sclk_d1     <= sclk;
        spi_sclk    <= sclk_d1;
        spi_sclk_d1 <= spi_sclk;
    end
end

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        ce_d1     <= 1'b0;
        spi_ce    <= 1'b0;
    end
    else begin
        ce_d1     <= ce;
        spi_ce    <= ce_d1;
    end
end

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        mosi_d1  <= 1'b0;
        spi_mosi <= 1'b0;
    end
    else begin
        mosi_d1  <= mosi;
        spi_mosi <= mosi_d1;
    end
end

//sample and transmit time
generate

  case (CPOL^CPHA)

    1'b0:begin
        
        assign sample_edge = spi_sclk_d1    & (~spi_sclk);  //falling_edge
        assign toggle_edge = (~spi_sclk_d1) & spi_sclk;     //rising_edge

    end

    1'b1:begin
        
        assign sample_edge = (~spi_sclk_d1) & spi_sclk;     //rising_edge
        assign toggle_edge = spi_sclk_d1    & (~spi_sclk);  //falling_edge

    end

    default:begin

        assign sample_edge = spi_sclk_d1    & (~spi_sclk);
        assign toggle_edge = (~spi_sclk_d1) & spi_sclk;

    end

  endcase

endgenerate

//count the bit of rx_data or tx_data
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        bit_cnt <= 1'b0;
    end
    else if(sample_edge && spi_ce == CE_LEVEL)begin
        if(bit_cnt == DATA_WIDTH - 1)begin
            bit_cnt <= 1'b0;
        end
        else begin
            bit_cnt <= bit_cnt + 1'b1;
        end
    end
    else begin
        bit_cnt <= bit_cnt;
    end
end

//receive data from mosi
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        rx_data_d1 <= 1'b0;
    end
    else if(sample_edge && spi_ce == CE_LEVEL)begin
        rx_data_d1[DATA_WIDTH - 1 - bit_cnt] <= spi_mosi;
    end
    else begin
        rx_data_d1 <= rx_data_d1;
    end
end

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        rx_data <= 1'b0;
    end
    else if(spi_ce == ~CE_LEVEL && spi_sclk == CPOL)begin
        rx_data <= rx_data_d1;
    end
    else begin
        rx_data <= rx_data;
    end
end

//transmit data to miso
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        miso <= 1'b0;
    end
    else if(sample_edge && spi_ce == CE_LEVEL)begin
        miso <= tx_data[DATA_WIDTH - 1 - bit_cnt];
    end
    else begin
        miso <= miso;
    end
end

//spi_done
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        spi_done <= 1'b0;
    end
    else if(spi_ce == ~CE_LEVEL && spi_sclk == CPOL)begin
        spi_done <= 1'b1;
    end
    else begin
        spi_done <= 1'b0;
    end
end

endmodule
