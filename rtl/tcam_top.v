// tcam_top.v - 16 x 8 ternary CAM, serial-loaded, with priority encoder
// SKY130, 1.8 V, <= 10 MHz.  Inputs: 14, outputs: 6.
module tcam_top (
    input  wire        clk,
    input  wire        rst,          // active-high, synchronous
    input  wire [1:0]  op,           // 00 NOP, 01 LOAD_RULE, 10 LOAD_SEARCH, 11 COMMIT
    input  wire [3:0]  addr,         // entry address (used on COMMIT)
    input  wire [5:0]  data,         // serial data chunk
    output wire [3:0]  match_addr,   // lowest matching entry
    output wire        match_valid,  // at least one match
    output wire        multi_match   // two or more matches
);
    wire [15:0] rule_sh, ml;
    wire [7:0]  sw;
    wire        commit;

    tcam_ctrl u_ctrl (
        .clk(clk), .rst(rst), .op(op), .data(data),
        .rule_sh(rule_sh), .sw(sw), .commit(commit)
    );

    tcam_array u_arr (
        .clk(clk), .rst(rst), .commit(commit), .wr_addr(addr),
        .wr_rule(rule_sh), .sw(sw), .ml(ml)
    );

    priority_encoder u_pe (
        .ml(ml), .addr(match_addr), .valid(match_valid), .multi(multi_match)
    );
endmodule
