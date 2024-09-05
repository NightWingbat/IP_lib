# 设置工作目录

vlib work
vmap work work

# 编译 Verilog 文件

vlog -work work ../sim/tb_sync_fifo.v
vlog -work work ../src/memory/FIFO/sync_fifo.v
vlog -work work ../src/memory/FIFO/DPRAM.v
vlog -sv        ../src/memory/FIFO/ecc_encode.sv
vlog -sv        ../src/memory/FIFO/ecc_decode.sv
vlog -sv        ../sim/xpm_fifo.sv
vlog -sv        ../sim/xpm_memory.sv

# 加载仿真设计

vsim -t ps +notimingchecks -gui -voptargs="+acc" work.tb_sync_fifo

# 添加波形窗口

add wave /tb_sync_fifo/sys_rst
add wave /tb_sync_fifo/sys_clk

add wave -divider {wr_port}

add wave /tb_sync_fifo/wr_en
add wave /tb_sync_fifo/din
add wave /tb_sync_fifo/wr_data_count
add wave /tb_sync_fifo/wr_data_space

add wave -divider {rd_port}

add wave /tb_sync_fifo/rd_en
add wave /tb_sync_fifo/valid
add wave /tb_sync_fifo/dout

add wave /tb_sync_fifo/full
add wave /tb_sync_fifo/empty

add wave /tb_sync_fifo/rd_data_count
add wave /tb_sync_fifo/rd_data_space

add wave -divider {xpm_fifo}

add wave -color {yellow} /tb_sync_fifo/xpm_valid;
add wave -color {yellow} /tb_sync_fifo/xpm_dout;
add wave -color {yellow} /tb_sync_fifo/xpm_full;
add wave -color {yellow} /tb_sync_fifo/xpm_empty;
add wave -color {yellow} /tb_sync_fifo/xpm_wr_data_count;
add wave -color {yellow} /tb_sync_fifo/xpm_rd_data_count;

# add wave /tb_sync_fifo/almost_full
# add wave /tb_sync_fifo/almost_empty
# add wave /tb_sync_fifo/prog_full
# add wave /tb_sync_fifo/prog_empty
# add wave /tb_sync_fifo/overflow
# add wave /tb_sync_fifo/underflow
# add wave /tb_sync_fifo/wr_ack
# add wave /tb_sync_fifo/sbiterr
# add wave /tb_sync_fifo/dbiterr

# 启动仿真

run 4us
