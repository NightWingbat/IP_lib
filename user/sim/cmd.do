# 设置工作目录

vlib work
vmap work work

# 编译 Verilog 文件

vlog -work work ../sim/tb_spi.v
vlog -work work ../src/Interface/SPI.v
# vlog -work work ../src/Interface/spi_adi.v
vlog -work work ../src/Interface/spi_slave.v
vlog -work work ../src/memory/PSRAM/hbram_ctrl.v
vlog -work work ../src/memory/FIFO/DPRAM.v
vlog -sv        ../src/memory/FIFO/ecc_encode.sv
vlog -sv        ../src/memory/FIFO/ecc_decode.sv
vlog -work work ../src/memory/FIFO/sync_fifo.v
# vlog -sv        ../sim/xpm_fifo.sv
# vlog -sv        ../sim/xpm_memory.sv

# 加载仿真设计

vsim -t ps +notimingchecks -gui -voptargs="+acc" work.tb_spi

# 添加波形窗口

add wave /tb_spi/sys_rst
add wave /tb_spi/sys_clk

add wave /tb_spi/rx_data
add wave /tb_spi/spi_done
add wave /tb_spi/sclk
add wave /tb_spi/mosi
add wave /tb_spi/ce

add wave /tb_spi/spi_exe
add wave /tb_spi/tx_data
add wave /tb_spi/miso

add wave /tb_spi/wait_cnt

add wave /tb_spi/u_SPI/state_now
add wave /tb_spi/u_SPI/sclk_cnt
add wave /tb_spi/u_SPI/bit_cnt
add wave /tb_spi/u_SPI/sample_edge
add wave /tb_spi/u_SPI/toggle_edge

# add wave -divider {spi_adi}

# add wave -color {yellow} /tb_spi/wr_end
# add wave -color {yellow} /tb_spi/spi_clk
# add wave -color {yellow} /tb_spi/spi_enb
# add wave -color {yellow} /tb_spi/spi_di

# add wave -color {yellow} /tb_spi/u_spi_adi/div_clk
# add wave -color {yellow} /tb_spi/u_spi_adi/wr_state
# add wave -color {yellow} /tb_spi/u_spi_adi/wr_cnt
# add wave -color {yellow} /tb_spi/u_spi_adi/wr_en

add wave -divider {spi_slave}

add wave -color {yellow} /tb_spi/hbc_cal_pass
add wave -color {yellow} /tb_spi/slave_tx_valid
add wave -color {yellow} /tb_spi/slave_tx_data
add wave -color {yellow} /tb_spi/ctrl
add wave -color {yellow} /tb_spi/address
add wave -color {yellow} /tb_spi/slave_tx_en
add wave -color {yellow} /tb_spi/slave_rx_en
add wave -color {yellow} /tb_spi/slave_rx_data
add wave -color {yellow} /tb_spi/slave_done

add wave -divider {u_spi_slave}

add wave -color {orange} /tb_spi/u_spi_slave/state_now

add wave -color {orange} /tb_spi/u_spi_slave/ctrl_d1
add wave -color {orange} /tb_spi/u_spi_slave/ctrl_cnt

add wave -color {orange} /tb_spi/u_spi_slave/addr_d1
add wave -color {orange} /tb_spi/u_spi_slave/addr_cnt

add wave -color {orange} /tb_spi/u_spi_slave/rx_data_d1
add wave -color {orange} /tb_spi/u_spi_slave/data_cnt
add wave -color {orange} /tb_spi/u_spi_slave/data_len

# add wave -divider {wr_port}

# add wave /tb_spi/wr_en
# add wave /tb_spi/din
# add wave /tb_spi/wr_data_count
# add wave /tb_spi/wr_data_space

# add wave -divider {rd_port}

# add wave /tb_sync_fifo/rd_en
# add wave /tb_sync_fifo/valid
# add wave /tb_sync_fifo/dout

# add wave /tb_sync_fifo/full
# add wave /tb_sync_fifo/empty

# add wave /tb_sync_fifo/rd_data_count
# add wave /tb_sync_fifo/rd_data_space

# add wave -divider {xpm_fifo}

# add wave -color {yellow} /tb_sync_fifo/xpm_valid;
# add wave -color {yellow} /tb_sync_fifo/xpm_dout;
# add wave -color {yellow} /tb_sync_fifo/xpm_full;
# add wave -color {yellow} /tb_sync_fifo/xpm_empty;
# add wave -color {yellow} /tb_sync_fifo/xpm_wr_data_count;
# add wave -color {yellow} /tb_sync_fifo/xpm_rd_data_count;

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

run 1ms
