###############################################################################
# Created by write_sdc
###############################################################################
current_design tcam_top
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 100.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {addr[0]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {addr[1]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {addr[2]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {addr[3]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data[0]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data[1]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data[2]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data[3]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data[4]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data[5]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {op[0]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {op[1]}]
set_input_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {rst}]
set_output_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {match_addr[0]}]
set_output_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {match_addr[1]}]
set_output_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {match_addr[2]}]
set_output_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {match_addr[3]}]
set_output_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {match_valid}]
set_output_delay 20.0000 -clock [get_clocks {clk}] -add_delay [get_ports {multi_match}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {match_valid}]
set_load -pin_load 0.0334 [get_ports {multi_match}]
set_load -pin_load 0.0334 [get_ports {match_addr[3]}]
set_load -pin_load 0.0334 [get_ports {match_addr[2]}]
set_load -pin_load 0.0334 [get_ports {match_addr[1]}]
set_load -pin_load 0.0334 [get_ports {match_addr[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__clkinv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rst}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {addr[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {addr[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {addr[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {addr[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data[5]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data[4]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {op[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {op[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_capacitance 0.2000 [current_design]
set_max_fanout 6.0000 [current_design]
