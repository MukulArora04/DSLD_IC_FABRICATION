// tcam_array.v - 16 x 8 ternary storage + matchlines
// Cell encoding {r1,r0}: 00 = X (always match), 01 = logic 0,
//                        10 = logic 1, 11 = invalid (never matches)
// Entry i uses rule bits [2*j+1:2*j] for search bit j.
// Entries are invalid after reset; a commit sets the entry's valid bit.
module tcam_array (
    input  wire        clk,
    input  wire        rst,
    input  wire        commit,
    input  wire [3:0]  wr_addr,
    input  wire [15:0] wr_rule,
    input  wire [7:0]  sw,
    output wire [15:0] ml
);
    reg [15:0] mem [0:15];
    reg [15:0] valid;

    always @(posedge clk) begin
        if (commit) mem[wr_addr] <= wr_rule;
    end

    always @(posedge clk) begin
        if (rst)         valid <= 16'h0000;
        else if (commit) valid[wr_addr] <= 1'b1;
    end

    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : g_ent
            wire [7:0] mb;
            for (j = 0; j < 8; j = j + 1) begin : g_bit
                wire r1 = mem[i][2*j+1];
                wire r0 = mem[i][2*j];
                assign mb[j] = (r1 & r0) ? 1'b0 :
                               r1        ? sw[j] :
                               r0        ? ~sw[j] : 1'b1;
            end
            assign ml[i] = valid[i] & (&mb);
        end
    endgenerate
endmodule
