# 设置工作目录

vlib work
vmap work work

# 编译 Verilog 文件

vlog -work work ../sim/tb_sync_fifo.v
vlog -work work ../src/memory/FIFO/sync_fifo.v
vlog -work work ../src/memory/FIFO/DPRAM.v

# 加载仿真设计

vsim -t ps +notimingchecks -gui -voptargs="+acc" work.tb_sync_fifo

# 添加波形窗口

add wave /tb_sync_fifo/sys_clk
add wave /tb_sync_fifo/sys_rst

add wave /tb_sync_fifo/rd_en
add wave /tb_sync_fifo/valid
add wave /tb_sync_fifo/dout
add wave /tb_sync_fifo/full
add wave /tb_sync_fifo/empty
add wave /tb_sync_fifo/wr_data_count
add wave /tb_sync_fifo/rd_data_count
add wave /tb_sync_fifo/wr_data_space
add wave /tb_sync_fifo/rd_data_space

add wave /tb_sync_fifo/wr_en
add wave /tb_sync_fifo/din

add wave -divider {CP_fifo}

add wave /tb_sync_fifo/CP_fifo/empty
add wave /tb_sync_fifo/CP_fifo/pre_read

add wave /tb_sync_fifo/CP_fifo/rd_ptr
add wave /tb_sync_fifo/CP_fifo/rd_ptr_next
add wave /tb_sync_fifo/CP_fifo/rd_ptr_fwft
add wave /tb_sync_fifo/CP_fifo/ram_rd_addr_b
add wave /tb_sync_fifo/CP_fifo/fwft_valid

add wave /tb_sync_fifo/CP_fifo/ram_rd_en

# 启动仿真

run 4us
