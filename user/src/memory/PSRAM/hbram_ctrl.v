`timescale 1 ns / 1 ns

/*
*   Date : 2024-10-07
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

module hbram_ctrl #(
    //The width parameter for register control
    parameter    CTRL_WIDTH = 8,
    //The width parameter for register address
    parameter    ADDR_WIDTH = 8,
    //SPI write command
    parameter    CTRL_WRITE = 1'b1, // @suppress "Parameter 'CTRL_WRITE' is never used locally"
    //SPI read  command
    parameter    CTRL_READ  = 1'b0, // @suppress "Parameter 'CTRL_READ' is never used locally"
    //Burst read or write length
    parameter    LEN_WIDTH  = 32
) (
    //system clock input
    input                           clock, // @suppress "Port 'clock' is never used locally"
    //system reset active low
    input                           reset, // @suppress "Port 'reset' is never used locally"
    //PSRAM or DDR is complete
    input                           hbc_cal_pass, // @suppress "Port 'hbc_cal_pass' is never used locally"
    //once SPI data interaction finished
    input                           spi_done, // @suppress "Port 'spi_done' is never used locally"
    //spi receive register control signal
    input      [CTRL_WIDTH - 1 : 0] ctrl, // @suppress "Port 'ctrl' is never used locally"
    //register address signal
    input      [ADDR_WIDTH - 1 : 0] address, // @suppress "Port 'address' is never used locally"
    //Burst write or read number
    input      [LEN_WIDTH  - 1 : 0] burst_len,
    //hyperram operation status  1: operating  0: idle
    input                           ram_idle, // @suppress "Port 'ram_idle' is never used locally"
    //hyperram operation control signal
    output reg                      ram_en, // @suppress "Port 'ram_en' is never used locally"
    //hyperram write or read start address
    output reg [31:0]               ram_addr, // @suppress "Port 'ram_addr' is never used locally"
    //hyperram write or read signal   0: write  1: read
    output reg                      ram_rdwr // @suppress "Port 'ram_rdwr' is never used locally"
);

localparam IDLE  = 3'd0;
localparam DONE  = 3'd1;
localparam WRITE = 3'd2;
localparam READ  = 3'd3;
localparam WAIT  = 3'd4;

reg [2:0]  state_now;
reg [2:0]  state_next;

reg        ram_idle_d1;
wire       ram_idle_pos;
wire       ram_idle_neg;

reg [31:0] data_cnt;
reg        read_valid;

assign ram_idle_pos = (~ram_idle_d1) & ram_idle;
assign ram_idle_neg = (~ram_idle)    & ram_idle_d1;

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        data_cnt <= 32'd0;
    end
    else if(spi_done && ctrl == CTRL_WRITE)begin
        data_cnt <= data_cnt + 32'd16;
    end
    else if(state_now == READ)begin
        data_cnt <= 32'd0;
    end
    else begin
        data_cnt <= data_cnt;
    end
end

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        read_valid <= 1'b0;
    end
    else if(state_now == WRITE)begin
        read_valid <= 1'b1;
    end
    else if(state_now == READ)begin
        read_valid <= 1'b0;
    end
end

always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        ram_idle_d1 <= 1'b0;
    end
    else begin
        ram_idle_d1 <= ram_idle;
    end
end

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
                    state_next <= DONE;
                end
                else begin
                    state_next <= IDLE;
                end
            end

            DONE:begin
                if(read_valid)begin
                    state_next <= READ;
                end
                else if(data_cnt >= burst_len)begin
                    state_next <= WRITE;
                end
                else begin
                    state_next <= DONE;
                end
            end

            WRITE:begin
                state_next <= WAIT;
                // if(ram_idle_neg)begin
                //     state_next <= WAIT;
                // end
                // else begin
                //     state_next <= WRITE;
                // end
            end

            READ:begin
                state_next <= WAIT;
                // if(ram_idle_neg)begin
                //     state_next <= WAIT;
                // end
                // else begin
                //     state_next <= READ;
                // end
            end

            WAIT:begin
                if(ram_idle_pos)begin
                    state_next <= DONE;
                end
                else begin
                    state_next <= WAIT;
                end
            end

            default:begin
                state_next <= IDLE;
            end

        endcase
    end 
end

//ram_en
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        ram_en <= 1'b0;
    end
    else if(state_now == WRITE || state_now == READ)begin
        ram_en <= 1'b1;
        // if(ram_idle)
        //     ram_en <= 1'b1;
        // else 
        //     ram_en <= 1'b0;
    end
    else begin
        ram_en <= 1'b0;
    end
end

//ram_addr
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        ram_addr       <= 32'h8000_0000;
    end
    else if(state_now == WRITE || state_now == READ)begin
        ram_addr[31]   <= 1'b0;
        ram_addr[30:0] <= address;
    end
    else begin
        ram_addr <= ram_addr;
    end
end

//ram_rdwr
always @(posedge clock or posedge reset) begin
    if(reset == 1'b1)begin
        ram_rdwr <= 1'b0;
    end
    else if(state_now == WRITE)begin
        ram_rdwr <= 1'b0;
    end
    else if(state_now == READ)begin
        ram_rdwr <= 1'b1;
    end
    else begin
        ram_rdwr <= 1'b0;
    end
end

endmodule