// tcam_top_interface.v - external interface of the project (ports only, no logic).
// 16 x 8 ternary CAM with priority encoder. SKY130, 1.8 V, clock <= 10 MHz.
// Inputs: clk, rst + 12 data pins (op, addr, data). Outputs: 6.
module tcam_top (
    input  wire        clk,          // external clock, <= 10 MHz
    input  wire        rst,          // external reset, active-high, synchronous
    input  wire [1:0]  op,           // 00 NOP, 01 LOAD_RULE, 10 LOAD_SEARCH, 11 COMMIT
    input  wire [3:0]  addr,         // entry address (used on COMMIT)
    input  wire [5:0]  data,         // serial data chunk
    output wire [3:0]  match_addr,   // lowest matching entry index (0 when no match)
    output wire        match_valid,  // at least one entry matches
    output wire        multi_match   // two or more entries match
);
endmodule
