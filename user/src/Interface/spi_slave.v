`timescale 1 ns / 1 ns

/*
*   Date : 2024-10-04
*   Author : cjh
*   Module Name:   spi_slave.v - spi_slave
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
/* @wavedrom 
{signal: [
  {name: 'sys_clk', wave: '01010101010101010101010101'},
  {name: 'SCLK', wave: '0...1...0...1...0...1...0.'},
  {name: 'spi_sck', wave: '0.....1...0...1...0...1...'},
  {name: 'miso', wave: '0.........1.......0.......'},
]}
*/

module spi_slave #(
    //The parameter for clock idle state level
    parameter    CPOL       = 0, // @suppress "Parameter 'CPOL' is never used locally"
    //The parameter for clock phase
    parameter    CPHA       = 0, // @suppress "Parameter 'CPHA' is never used locally"
    //chip selection enable level
    parameter    CE_LEVEL   = 0, // @suppress "Parameter 'CE_LEVEL' is never used locally"
    //The width parameter for register control
    parameter    CTRL_WIDTH = 8,
    //The width parameter for register address
    parameter    ADDR_WIDTH = 8,
    //The width parameter for writing or receiving data
    parameter    DATA_WIDTH = 24,
    //Burst read or write length
    parameter    LEN_WIDTH  = 32,
    //SPI write command
    parameter    CTRL_WRITE = 8'h3a, // @suppress "Parameter 'CTRL_WRITE' is never used locally"
    //SPI read  command
    parameter    CTRL_READ  = 8'h3b // @suppress "Parameter 'CTRL_READ' is never used locally"
) (
    //system clock input
    input                           clock,  // @suppress "Port 'clock' is never used locally"
    //system reset active low
    input                           reset, // @suppress "Port 'reset' is never used locally"
    //PSRAM or DDR is complete
    input                           hbc_cal_pass, // @suppress "Port 'hbc_cal_pass' is never used locally"
    //Burst write or read number
    input      [LEN_WIDTH  - 1 : 0] burst_len, // @suppress "Port 'burst_len' is never used locally"
    //register control signal
    output reg [CTRL_WIDTH - 1 : 0] ctrl, // @suppress "Port 'ctrl' is never used locally"
    //register address signal
    output reg [ADDR_WIDTH - 1 : 0] address, // @suppress "Port 'address' is never used locally"
    //data transmit enable active high
    output reg                      tx_en, // @suppress "Port 'tx_en' is never used locally"
    //data transmit enable active high
    input                           tx_valid, // @suppress "Port 'tx_valid' is never used locally"
    //data transmit
    input      [DATA_WIDTH - 1 : 0] tx_data, // @suppress "Port 'tx_data' is never used locally"
    //data receive enable active high
    output reg                      rx_en, // @suppress "Port 'rx_en' is never used locally"
    //data receive
    output reg [DATA_WIDTH - 1 : 0] rx_data, // @suppress "Port 'rx_data' is never used locally"
    //once SPI data interaction finished
    output reg                      spi_done, // @suppress "Port 'spi_done' is never used locally"
    //spi_phy port

    //spi clock
    input                           sclk, // @suppress "Port 'sclk' is never used locally"
    //select slave device chips
    input                           ce, // @suppress "Port 'ce' is never used locally"
    //master output slave input
    input                           mosi, // @suppress "Port 'mosi' is never used locally"
    //master input slave output
    output reg                      miso // @suppress "Port 'miso' is never used locally"
);

localparam                       IDLE  = 3'd0;
localparam                       CTRL  = 3'd1;
localparam                       ADDR  = 3'd2;
localparam                       WRITE = 3'd3;
localparam                       READ  = 3'd4;
localparam                       STOP  = 3'd5;

reg [2:0]                        state_now;
reg [2:0]                        state_next;

reg                              sclk_d1;
reg                              spi_sclk;
reg                              spi_sclk_d1;

reg                              ce_d1;
reg                              spi_ce;

reg                              mosi_d1;
reg                              spi_mosi;

wire                             sample_edge;
wire                             toggle_edge;

reg [$clog2(CTRL_WIDTH)     : 0] ctrl_cnt;
reg [$clog2(ADDR_WIDTH)     : 0] addr_cnt;
reg [$clog2(DATA_WIDTH)     : 0] data_cnt;
reg [LEN_WIDTH - 1          : 0] data_len;

reg [CTRL_WIDTH - 1         : 0] ctrl_d1;
reg [ADDR_WIDTH - 1         : 0] addr_d1;
reg [DATA_WIDTH - 1         : 0] rx_data_d1;

reg [$clog2(DATA_WIDTH)     : 0] data_cnt_d1;

always @(posedge clock or posedge reset) begin
  if(reset == 1'b1)begin
      //sclk_d1     <= 1'b0;
      spi_sclk    <= 1'b0;
      spi_sclk_d1 <= 1'b0;
  end
  else begin
      //sclk_d1     <= sclk;
      spi_sclk    <= sclk;
      spi_sclk_d1 <= spi_sclk;
  end
end

always @(posedge clock or posedge reset) begin
  if(reset == 1'b1)begin
      //ce_d1     <= 1'b0;
      spi_ce    <= 1'b0;
  end
  else begin
      //ce_d1     <= ce;
      spi_ce    <= ce;
  end
end

always @(posedge clock or posedge reset) begin
  if(reset == 1'b1)begin
      //mosi_d1  <= 1'b0;
      spi_mosi <= 1'b0;
  end
  else begin
      //mosi_d1  <= mosi;
      spi_mosi <= mosi;
  end
end

//sample and transmit time
generate

case (CPOL^CPHA)

  1'b0:begin
      
      assign toggle_edge = spi_sclk_d1    & (~spi_sclk);  //falling_edge
      assign sample_edge = (~spi_sclk_d1) & spi_sclk;     //rising_edge

  end

  1'b1:begin
      
      assign toggle_edge = (~spi_sclk_d1) & spi_sclk;     //rising_edge
      assign sample_edge = spi_sclk_d1    & (~spi_sclk);  //falling_edge

  end

  default:begin

      assign toggle_edge = spi_sclk_d1    & (~spi_sclk);
      assign sample_edge = (~spi_sclk_d1) & spi_sclk;

  end

endcase

endgenerate

//state transition
always @(posedge clock or posedge reset) begin
  if(reset == 1'b1)begin
      state_now <= IDLE;
  end
  else begin
      state_now <= state_next;
  end
end

always @(*) begin
  if(reset == 1'b1)begin
      state_next <= IDLE;
  end
  else begin
      case(state_now)

          IDLE:begin
            if(hbc_cal_pass)begin
                state_next <= CTRL;
            end
            else begin
                state_next <= IDLE;
            end
          end

          CTRL:begin
            if(spi_ce == CE_LEVEL)begin
                if(sample_edge && ctrl_cnt == CTRL_WIDTH - 1)begin
                    state_next <= ADDR;
                end
                else begin
                    state_next <= CTRL;
                end
            end
            else begin
                state_next <= CTRL;
            end
        end

        ADDR:begin
            if(spi_ce == CE_LEVEL)begin
                if(sample_edge && addr_cnt == ADDR_WIDTH - 1)begin
                    case (ctrl_d1)
                        CTRL_WRITE : state_next <= WRITE;
                        CTRL_READ  : state_next <= READ;
                        default    : state_next <= CTRL;
                    endcase
                end
                else begin
                    state_next <= ADDR;
                end
            end
            else begin
                state_next <= CTRL;
            end
        end

        WRITE:begin
            if(spi_ce == CE_LEVEL)begin
                if(sample_edge && data_cnt == DATA_WIDTH - 1 && data_len == burst_len - 1'b1)
                    state_next <= STOP;
                else 
                    state_next <= WRITE;
            end
            else begin
                state_next <= CTRL;
            end
        end

        READ:begin
          if(spi_ce == CE_LEVEL)begin
            if(sample_edge && data_cnt == DATA_WIDTH - 1 && data_len == burst_len - 1'b1)
                state_next <= STOP;
            else 
                state_next <= READ;
        end
        else begin
            state_next <= CTRL;
        end
        end

        STOP:begin
            state_next <= CTRL;
        end

        default:begin
            state_next <= IDLE;
        end

      endcase
  end
end

//count the bit of signal from mosi
always @(posedge clock or posedge reset) begin
  if(reset == 1'b1)begin
      ctrl_cnt <= 1'b0;
      addr_cnt <= 1'b0;
      data_cnt <= 1'b0;
      data_len <= 1'b0;
  end
  else if(spi_ce != CE_LEVEL)begin
      ctrl_cnt <= 1'b0;
      addr_cnt <= 1'b0;
      data_cnt <= 1'b0;
      data_len <= 1'b0;
  end
  else begin
      case(state_now)

          IDLE:begin
              ctrl_cnt <= 1'b0;
              addr_cnt <= 1'b0;
              data_cnt <= 1'b0;
              data_len <= 1'b0;
          end

          CTRL:begin
              if(sample_edge)begin
                  if(ctrl_cnt == CTRL_WIDTH - 1)
                      ctrl_cnt <= ctrl_cnt;
                  else 
                      ctrl_cnt <= ctrl_cnt + 1'b1;
              end
              else begin
                  ctrl_cnt <= ctrl_cnt;
              end
          end

          ADDR:begin
              if(sample_edge)begin
                  if(addr_cnt == ADDR_WIDTH - 1)
                      addr_cnt <= addr_cnt;
                  else 
                      addr_cnt <= addr_cnt + 1'b1;
              end
              else begin
                  addr_cnt <= addr_cnt;
              end
          end

          WRITE:begin
              if(sample_edge)begin
                  if(data_cnt == DATA_WIDTH - 1)
                      data_cnt <= 1'b0;
                  else 
                      data_cnt <= data_cnt + 1'b1;
              end
              else begin
                  data_cnt <= data_cnt;
              end

              if(sample_edge && data_cnt == DATA_WIDTH - 1)begin
                  data_len <= data_len + 1'b1;
              end
              else begin
                  data_len <= data_len;
              end
          end

          READ:begin
            if(sample_edge)begin
              if(data_cnt == DATA_WIDTH - 1)
                  data_cnt <= 1'b0;
              else 
                  data_cnt <= data_cnt + 1'b1;
            end
            else begin
                data_cnt <= data_cnt;
            end

            if(sample_edge && data_cnt == DATA_WIDTH - 1)begin
                data_len <= data_len + 1'b1;
            end
            else begin
                data_len <= data_len;
            end
          end
          
          STOP:begin
              ctrl_cnt <= 1'b0;
              addr_cnt <= 1'b0;
              data_cnt <= 1'b0;
              data_len <= 1'b0;
          end

          default:begin
              ctrl_cnt <= 1'b0;
              addr_cnt <= 1'b0;
              data_cnt <= 1'b0;
              data_len <= 1'b0;
          end

      endcase
  end
end

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        data_cnt_d1 <= 1'b0;
    end
    else begin
        data_cnt_d1 <= data_cnt;
    end
end

//receive signal from mosi
always @(posedge clock or posedge reset) begin
  if(reset == 1'b1)begin
      ctrl_d1    <= 1'b0;
      addr_d1    <= 1'b0;
      rx_data_d1 <= 1'b0;
      //miso       <= 1'b0;
  end
  else if(spi_ce != CE_LEVEL)begin
      ctrl_d1    <= 1'b0;
      addr_d1    <= 1'b0;
      rx_data_d1 <= 1'b0;
      //miso       <= 1'b0;
  end
  else begin
      case(state_now)

          IDLE:begin
              ctrl_d1    <= 1'b0;
              addr_d1    <= 1'b0;
              rx_data_d1 <= 1'b0;
              //miso       <= 1'b0;
          end

          CTRL:begin
              //miso         <= 1'b0;
              if(sample_edge)begin
                  ctrl_d1[CTRL_WIDTH - 1 - ctrl_cnt]    <= spi_mosi;
              end
              else begin
                  ctrl_d1                               <= ctrl_d1;
              end
          end

          ADDR:begin
              //miso         <= 1'b0;
              if(sample_edge)begin
                  addr_d1[ADDR_WIDTH - 1 - addr_cnt]    <= spi_mosi;
              end
              else begin
                  addr_d1                               <= addr_d1;
              end
          end

          WRITE:begin
            //miso         <= 1'b0;
            if(sample_edge)begin
                rx_data_d1[DATA_WIDTH - 1 - data_cnt] <= spi_mosi;
            end
            else begin
                rx_data_d1                            <= rx_data_d1;
            end
          end

        //   READ:begin
        //       if(sample_edge)begin
        //           miso <= tx_data[DATA_WIDTH - 1 - data_cnt];
        //       end
        //       else begin
        //           miso <= miso;
        //       end
        //   end

          STOP:begin
              ctrl_d1    <= 1'b0;
              addr_d1    <= 1'b0;
              rx_data_d1 <= 1'b0;
              //miso       <= 1'b0;
          end

          default:begin
              ctrl_d1    <= 1'b0;
              addr_d1    <= 1'b0;
              rx_data_d1 <= 1'b0;
              //miso       <= 1'b0;
          end

      endcase
  end
end

always @(*) begin
    if(reset == 1'b1)begin
        miso <= 1'b0;
    end
    else if(spi_ce != CE_LEVEL)begin
        miso <= 1'b0;
  end
    else begin
        case(state_now)

          IDLE:begin
                miso <= 1'b0;
          end

          CTRL:begin
                miso <= 1'b0;
          end

          ADDR:begin
                miso <= 1'b0;
          end

          WRITE:begin
                miso <= 1'b0;
          end

          READ:begin
                miso <= tx_data[DATA_WIDTH - 1 - data_cnt];
          end

          STOP:begin
                miso <= 1'b0;
          end

          default:begin
                miso <= 1'b0;
          end

      endcase
    end
end

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        ctrl    <= 1'b0;
        address <= 1'b0;
    end
    else if(state_now == STOP)begin
        ctrl    <= ctrl_d1;
        address <= addr_d1;
    end
    else begin
        ctrl    <= ctrl;
        address <= address;
    end
end

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        rx_data <= 1'b0;
    end
    else if(state_now == WRITE)begin
        if(data_cnt == 1'b0 && data_len > 1'b0)
            rx_data <= rx_data_d1;
        else 
            rx_data <= rx_data;
    end
    else if(state_now == STOP)begin
        rx_data <= rx_data_d1;
    end
    else begin
        rx_data <= rx_data;
    end
end

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        rx_en <= 1'b0;
    end
    else if(state_now == WRITE)begin
        if(data_cnt_d1 == DATA_WIDTH - 1 && data_cnt == 1'b0)
            rx_en <= 1'b1;
        else 
            rx_en <= 1'b0;
    end
    else if(state_now == STOP && ctrl_d1 == CTRL_WRITE)begin
        rx_en <= 1'b1;
    end
    else begin
        rx_en <= 1'b0;
    end
end

always @(*) begin
  if(reset == 1'b1)begin
        tx_en <= 1'b0;
  end
  else if(state_now == ADDR && ctrl_d1 == CTRL_READ)begin
        if(sample_edge && addr_cnt == ADDR_WIDTH - 1)
            tx_en <= 1'b1;
        else
            tx_en <= 1'b0;
  end
  else if(state_now == READ)begin
        if(data_len < burst_len - 1'b1)begin
            if(sample_edge && data_cnt == DATA_WIDTH - 1)
                tx_en <= 1'b1;
            else 
                tx_en <= 1'b0;
        end
        else begin
            tx_en <= 1'b0;
        end
  end
  else begin
      tx_en <= 1'b0;
  end
end

always @(posedge clock or posedge reset) begin
  if(reset == 1'b1)begin
      spi_done <= 1'b0;
  end
  else if(state_now == STOP)begin
      spi_done <= 1'b1;
  end
  else begin
      spi_done <= 1'b0;
  end
end

endmodule
