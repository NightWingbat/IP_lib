# heijing XC7A35T-FGG484-1

## CLK
# set_property IOSTANDARD LVCMOS18 [get_ports clk]
# set_property PACKAGE_PIN Y18 [get_ports clk]

## reset
# set_property IOSTANDARD LVCMOS18 [get_ports reset]
# set_property PACKAGE_PIN F20 [get_ports reset]

# set_property IOSTANDARD LVCMOS18 [get_ports sclk]
# set_property PACKAGE_PIN F19 [get_ports sclk]

# set_property IOSTANDARD LVCMOS18 [get_ports ce]
# set_property PACKAGE_PIN E21 [get_ports ce]

# set_property IOSTANDARD LVCMOS18 [get_ports mosi]
# set_property PACKAGE_PIN D20 [get_ports mosi]

# set_property IOSTANDARD LVCMOS18 [get_ports miso]
# set_property PACKAGE_PIN C20 [get_ports miso]

# xczu3eg-sfvc784-2-i
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS18} [get_ports pl_clk]

set_property -dict {PACKAGE_PIN L3 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_clk_in_p]
set_property -dict {PACKAGE_PIN L2 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_clk_in_n]
set_property -dict {PACKAGE_PIN K4 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_frame_in_p]
set_property -dict {PACKAGE_PIN K3 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_frame_in_n]
set_property -dict {PACKAGE_PIN W8 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_p[0]}]
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_n[0]}]
set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_p[1]}]
set_property -dict {PACKAGE_PIN T7 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_n[1]}]
set_property -dict {PACKAGE_PIN U8 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_p[2]}]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_n[2]}]
set_property -dict {PACKAGE_PIN U9 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_p[3]}]
set_property -dict {PACKAGE_PIN V9 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_n[3]}]
set_property -dict {PACKAGE_PIN R8 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_p[4]}]
set_property -dict {PACKAGE_PIN T8 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_n[4]}]
set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_p[5]}]
set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports {rx_data_in_n[5]}]

set_property -dict {PACKAGE_PIN AF7 IOSTANDARD LVDS} [get_ports tx_clk_out_p]
set_property -dict {PACKAGE_PIN AF6 IOSTANDARD LVDS} [get_ports tx_clk_out_n]
set_property -dict {PACKAGE_PIN AE5 IOSTANDARD LVDS} [get_ports tx_frame_out_p]
set_property -dict {PACKAGE_PIN AF5 IOSTANDARD LVDS} [get_ports tx_frame_out_n]

set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVDS} [get_ports {tx_data_out_p[0]}]
set_property -dict {PACKAGE_PIN AC7 IOSTANDARD LVDS} [get_ports {tx_data_out_n[0]}]
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVDS} [get_ports {tx_data_out_p[1]}]
set_property -dict {PACKAGE_PIN AC6 IOSTANDARD LVDS} [get_ports {tx_data_out_n[1]}]
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVDS} [get_ports {tx_data_out_p[2]}]
set_property -dict {PACKAGE_PIN AC8 IOSTANDARD LVDS} [get_ports {tx_data_out_n[2]}]
set_property -dict {PACKAGE_PIN AG9 IOSTANDARD LVDS} [get_ports {tx_data_out_p[3]}]
set_property -dict {PACKAGE_PIN AH9 IOSTANDARD LVDS} [get_ports {tx_data_out_n[3]}]
set_property -dict {PACKAGE_PIN AE9 IOSTANDARD LVDS} [get_ports {tx_data_out_p[4]}]
set_property -dict {PACKAGE_PIN AE8 IOSTANDARD LVDS} [get_ports {tx_data_out_n[4]}]
set_property -dict {PACKAGE_PIN AD7 IOSTANDARD LVDS} [get_ports {tx_data_out_p[5]}]
set_property -dict {PACKAGE_PIN AE7 IOSTANDARD LVDS} [get_ports {tx_data_out_n[5]}]

set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS18} [get_ports enable]
set_property -dict {PACKAGE_PIN AB1 IOSTANDARD LVCMOS18} [get_ports txnrx]

set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS18} [get_ports {ctrl_in[0]}]
set_property -dict {PACKAGE_PIN AB3 IOSTANDARD LVCMOS18} [get_ports {ctrl_in[1]}]
set_property -dict {PACKAGE_PIN AD4 IOSTANDARD LVCMOS18} [get_ports {ctrl_in[2]}]
set_property -dict {PACKAGE_PIN AG4 IOSTANDARD LVCMOS18} [get_ports {ctrl_in[3]}]

set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS18} [get_ports en_agc]
set_property -dict {PACKAGE_PIN P6 IOSTANDARD LVCMOS18} [get_ports sync_in]
set_property -dict {PACKAGE_PIN P7 IOSTANDARD LVCMOS18} [get_ports resetb]

set_property -dict {PACKAGE_PIN N6 IOSTANDARD LVCMOS18} [get_ports spi_csn]
set_property PULLUP true [get_ports spi_csn]
set_property -dict {PACKAGE_PIN N8 IOSTANDARD LVCMOS18} [get_ports spi_clk]
set_property -dict {PACKAGE_PIN M8 IOSTANDARD LVCMOS18} [get_ports spi_mosi]
set_property -dict {PACKAGE_PIN N7 IOSTANDARD LVCMOS18} [get_ports spi_miso]


# clocks

create_clock -period 4.000 -name rx_clk [get_ports rx_clk_in_p]
# create_clock -period 40.000 -name spi_sclk [get_ports spi_sclk]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list delay_clock/inst/clk_out2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {u_ad9361_init/state[0]} {u_ad9361_init/state[1]} {u_ad9361_init/state[2]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets spi_clk_OBUF]
