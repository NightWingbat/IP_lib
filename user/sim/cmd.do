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

add wave -divider {tb_sync_fifo}

add wave /tb_sync_fifo/sys_clk
add wave /tb_sync_fifo/sys_rst

# add wave /tb_async_fifo/wr_clk
add wave /tb_sync_fifo/wr_en
add wave /tb_sync_fifo/din

# add wave /tb_sync_fifo/rd_clk
add wave /tb_sync_fifo/rd_en
add wave /tb_sync_fifo/valid
add wave /tb_sync_fifo/dout

add wave /tb_sync_fifo/full
add wave /tb_sync_fifo/empty

add wave /tb_sync_fifo/wr_data_count
add wave /tb_sync_fifo/wr_data_space
add wave /tb_sync_fifo/rd_data_count
add wave /tb_sync_fifo/rd_data_space

add wave -divider {RESET}

add wave /tb_sync_fifo/u_sync_fifo/sys_rst
# add wave /tb_sync_fifo/u_sync_fifo/rd_rst
# add wave /tb_sync_fifo/u_sync_fifo/wr_rst

# add wave -divider {sync_fifo}

# add wave /tb_sync_fifo/u_sync_fifo/BIG_TO_SMALL_RAM/ram_sel

add wave -divider {wr_port}

add wave /tb_sync_fifo/u_sync_fifo/ram_wr_en
add wave /tb_sync_fifo/u_sync_fifo/wr_ptr
add wave /tb_sync_fifo/u_sync_fifo/wr_ptr_b
add wave /tb_sync_fifo/u_sync_fifo/ram_wr_addr
add wave /tb_sync_fifo/u_sync_fifo/ram_wr_addr_b
# add wave /tb_sync_fifo/u_sync_fifo/ram_wr_addr_b_d2

add wave -divider {rd_port}

add wave /tb_sync_fifo/u_sync_fifo/ram_rd_data
add wave /tb_sync_fifo/u_sync_fifo/ram_rd_en
add wave /tb_sync_fifo/u_sync_fifo/rd_ptr
add wave /tb_sync_fifo/u_sync_fifo/rd_ptr_b
add wave /tb_sync_fifo/u_sync_fifo/ram_rd_addr
add wave /tb_sync_fifo/u_sync_fifo/ram_rd_addr_b
# add wave /tb_sync_fifo/u_sync_fifo/ram_rd_addr_b_d2
# add wave /tb_sync_fifo/u_sync_fifo/ram_rd_addr_g_d2

add wave -divider {fwft_mode}

add wave /tb_sync_fifo/u_sync_fifo/rd_ptr
add wave /tb_sync_fifo/u_sync_fifo/rd_ptr_d1

add wave /tb_sync_fifo/u_sync_fifo/rd_ptr_fwft
add wave /tb_sync_fifo/u_sync_fifo/rd_ptr_fwft_d1

add wave -divider {fwft_valid}

add wave /tb_sync_fifo/u_sync_fifo/fwft_valid
# add wave /tb_async_fifo/u_async_fifo/BIG_TO_SMALL_RAM/rd_en_d1
# add wave /tb_async_fifo/u_async_fifo/BIG_TO_SMALL_RAM/rd_en_d2

# 启动仿真

run 4us
