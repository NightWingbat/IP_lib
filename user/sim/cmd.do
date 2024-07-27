set TB_NAME  tb_async_fifo
set SWITCH_1 SIM
set SWITCH_2 EFX_IPM

## new lib

vlib work
vmap work work

## load design

vlog  F:/FPGA_Project/IP_lib/user/sim/testbench.v
vlog  F:/FPGA_Project/IP_lib/user/src/memory/sync_fifo_test.v
vlog  F:/FPGA_Project/IP_lib/user/src/memory/FIFO/DPRAM.v

## sim design

vsim work.$TB_NAME

## add wave

add wave sim:/testbench/sys_clk
add wave sim:/testbench/sys_rst
add wave sim:/testbench/clear
add wave sim:/testbench/i_tvalid
add wave sim:/testbench/i_tdata
add wave sim:/testbench/i_tready
add wave sim:/testbench/o_tvalid
add wave sim:/testbench/o_tdata
add wave sim:/testbench/o_tready
add wave sim:/testbench/space
add wave sim:/testbench/occupied

## run

run 2us
