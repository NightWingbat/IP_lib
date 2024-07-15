set TB_NAME  tb_async_fifo
set SWITCH_1 SIM
set SWITCH_2 EFX_IPM

## new lib

vlib work
vmap work work

## load design

vlog  F:/FPGA_Project/IP_lib/user/sim/tb_sync_fifo.v
vlog  F:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v
vlog  F:/FPGA_Project/IP_lib/user/src/memory/FIFO/DPRAM.v

## sim design

vsim work.$TB_NAME

## add wave

add wave sim:/tb_sync_fifo/sys_clk
add wave sim:/tb_sync_fifo/wr_en
add wave sim:/tb_sync_fifo/rd_en
add wave sim:/tb_sync_fifo/din
add wave sim:/tb_sync_fifo/dout
add wave sim:/tb_sync_fifo/valid
add wave sim:/tb_sync_fifo/full
add wave sim:/tb_sync_fifo/empty
add wave sim:/tb_sync_fifo/wr_data_count
add wave sim:/tb_sync_fifo/rd_data_count

## run

run 2us
