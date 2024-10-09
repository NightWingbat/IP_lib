`timescale 1 ns / 1 ns

/*
*   Date : 2024-09-05
*   Author : cjh
*   Module Name:   SPI.v - SPI
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
module SPI #(
    //The parameter for clock idle state level
    parameter    CPOL       = 0,
    //The parameter for clock phase
    parameter    CPHA       = 0,
    //chip selection enable level
    parameter    CE_LEVEL   = 0,
    //The width parameter for writing data
    parameter    DATA_WIDTH = 24,
    //system clock frequency
    parameter    CLK_FREQ   = 28'd50_000_000,
    //spi sclk frequency
    parameter    SPI_FREQ   = 28'd400_000
) (
    //system clock input
    input                           clock,
    //system reset active low
    input                           reset,
    //start a SPI data interaction
    input                           spi_exe,
    //data transmit
    input      [DATA_WIDTH - 1 : 0] tx_data,
    //data receive
    output reg [DATA_WIDTH - 1 : 0] rx_data,
    //once SPI data interaction finished
    output reg                      spi_done,
    //spi_phy port

    //spi clock
    output reg                      sclk,
    //master output slave input
    output reg                      mosi,
    //master input slave output
    input                           miso,
    //select slave device chips
    output reg                      ce

);

localparam CNT   = (CLK_FREQ/SPI_FREQ);

localparam IDLE  = 2'd0;
localparam WAIT  = 2'd1;
localparam START = 2'd2;
localparam STOP  = 2'd3;

reg [1:0]                        state_now;
reg [1:0]                        state_next;

reg [$clog2(CNT)        - 1 : 0] wait_cnt;
reg [$clog2(CNT)        - 1 : 0] sclk_cnt;
reg [$clog2(DATA_WIDTH) - 1 : 0] bit_cnt;

reg                              sample_edge;
reg                              toggle_edge;

reg [DATA_WIDTH - 1 : 0]         rx_data_d1;

//Waiting for the system to stabilize
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
      wait_cnt <= 1'b0;
    end
    else if(state_now == WAIT)begin
      if(wait_cnt == CNT/2 - 1)begin
        wait_cnt <= 1'b0;
      end
      else begin
        wait_cnt <= wait_cnt + 1'b1;
      end
    end
    else begin
      wait_cnt <= 1'b0;
    end
end

//counter for spi sclk
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
      sclk_cnt <= 1'b0;
    end
    else if(state_now != IDLE && state_now != WAIT)begin
      if(sclk_cnt == CNT - 1)begin
        sclk_cnt <= 1'b0;
      end
      else begin
        sclk_cnt <= sclk_cnt + 1'b1;
      end
    end
    else begin
      sclk_cnt <= 1'b0;
    end
end

//counter for the number of data
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
      bit_cnt <= 1'b0;
    end
    else if(state_now == START)begin
      if(bit_cnt == DATA_WIDTH - 1 && sclk_cnt == CNT - 1)begin
        bit_cnt <= 1'b0;
      end
      else if(sclk_cnt == CNT - 1)begin
        bit_cnt <= bit_cnt + 1'b1;
      end
      else begin
        bit_cnt <= bit_cnt;
      end
    end
    else begin
      bit_cnt <= bit_cnt;
    end
end

generate

  case (CPHA)

    1'b0:begin : S1_T2

      always @(posedge clock or posedge reset) begin
        if(reset == 1'b1)begin
          sample_edge <= 1'b0;
        end
        else if(sclk_cnt == CNT/2 - 1)begin
          sample_edge <= 1'b1;
        end
        else begin
          sample_edge <= 1'b0;
        end
      end

      always @(posedge clock or posedge reset) begin
        if(reset == 1'b1)begin
          toggle_edge <= 1'b0;
        end
        else if(sclk_cnt == CNT - 1)begin
          toggle_edge <= 1'b1;
        end
        else begin
          toggle_edge <= 1'b0;
        end
      end

    end

    1'b1:begin : T1_S2

      always @(posedge clock or posedge reset) begin
        if(reset == 1'b1)begin
          sample_edge <= 1'b0;
        end
        else if(sclk_cnt == CNT - 1)begin
          sample_edge <= 1'b1;
        end
        else begin
          sample_edge <= 1'b0;
        end
      end

      always @(posedge clock or posedge reset) begin
        if(reset == 1'b1)begin
          toggle_edge <= 1'b0;
        end
        else if(sclk_cnt == CNT/2 - 1)begin
          toggle_edge <= 1'b1;
        end
        else begin
          toggle_edge <= 1'b0;
        end
      end

    end

    default:begin

      always @(posedge clock or posedge reset) begin
        sample_edge <= 1'b0;
      end

      always @(posedge clock or posedge reset) begin
        toggle_edge <= 1'b0;
      end
    end

  endcase

endgenerate

//State transition
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
      state_now <= IDLE;
    end
    else begin
      state_now <= state_next;
    end
end

//Predict the next state based on the current state
always @(*) begin
    if(reset)begin
      state_next <= IDLE;
    end
    else begin
      case(state_now)

        IDLE:begin
          if(spi_exe)begin
            state_next <= WAIT;
          end
          else begin
            state_next <= IDLE;
          end
        end

        WAIT:begin
          if(wait_cnt == CNT/2 - 1)begin
            state_next <= START;
          end
          else begin
            state_next <= WAIT;
          end
        end

        START:begin
          if(bit_cnt == DATA_WIDTH - 1 && sclk_cnt == CNT - 1)begin
            state_next <= STOP;
          end
          else begin
            state_next <= START;
          end
        end

        STOP:begin
          if(sclk_cnt == CNT - 1)begin
            state_next <= IDLE;
          end
          else begin
            state_next <= STOP;
          end
        end

        default:begin
          state_next <= IDLE;
        end
      endcase
    end
end

//sclk
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
      sclk <= CPOL;
    end
    else if(state_now == START)begin
      if(sclk_cnt <= CNT/2 - 1)
        sclk <= CPOL;
      else 
        sclk <= ~CPOL;
    end
    else begin
      sclk <= CPOL;
    end
end

//ce
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
      ce <= ~CE_LEVEL;
    end
    else if(spi_exe)begin
      ce <= CE_LEVEL;
    end
    else if(spi_done)begin
      ce <= ~CE_LEVEL;
    end
    else begin
      ce <= ce;
    end
end

//mosi
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
      mosi <= 1'b0;
    end
    else begin
      case(state_now)

        IDLE:begin
          mosi <= 1'b0;
        end

        START:begin
          if(sample_edge)begin
            mosi <= tx_data[DATA_WIDTH - 1 - bit_cnt];
          end
          else begin
            mosi <= mosi;
          end
        end

        STOP:begin
          if(sclk_cnt <= CNT/2 - 1)begin
            mosi <= mosi;
          end
          else begin
            mosi <= 1'b0;
          end
        end

        default:begin
          mosi <= 1'b0;
        end
      endcase
    end
end

//rx_data
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
      rx_data_d1 <= 1'b0;
    end
    else if(state_now == START)begin
      if(sample_edge)begin
        rx_data_d1[DATA_WIDTH - 1 - bit_cnt] <= miso;
      end
      else begin
        rx_data_d1 <= rx_data_d1;
      end
    end
    else begin
      rx_data_d1 <= rx_data_d1;
    end
end

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
      rx_data <= 1'b0;
    end
    else if(state_now == STOP)begin
      rx_data <= rx_data_d1;
    end
    else begin
      rx_data <= rx_data;
    end
end

//spi_done
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
      spi_done <= 1'b0;
    end
    else if(state_now == STOP && sclk_cnt == CNT - 1)begin
      spi_done <= 1'b1;
    end
    else begin
      spi_done <= 1'b0;
    end
end

endmodule  //SPI
