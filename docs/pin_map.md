# Pin map
Inputs (14): clk, rst, op[1:0], addr[3:0], data[5:0]  (12 data pins + clk + rst)
Outputs (6): match_addr[3:0], match_valid, multi_match
Limits of the call: up to 14 inputs / 14 outputs, one clk, one rst, <= 10 MHz.
See README.md for the command protocol.
