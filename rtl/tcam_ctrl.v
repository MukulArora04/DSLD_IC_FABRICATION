// tcam_ctrl.v - command decoder and serial load registers
// op: 00 NOP | 01 LOAD_RULE chunk | 10 LOAD_SEARCH chunk | 11 COMMIT
module tcam_ctrl (
    input  wire        clk,
    input  wire        rst,        // active-high, synchronous
    input  wire [1:0]  op,
    input  wire [5:0]  data,
    output reg  [15:0] rule_sh,    // rule shift register
    output reg  [7:0]  sw,         // search word register
    output wire        commit      // write rule_sh into entry addr this cycle
);
    assign commit = (op == 2'b11);

    always @(posedge clk) begin
        if (rst) begin
            sw      <= 8'h00;
            rule_sh <= 16'h0000;
        end else begin
            case (op)
                // 3 chunks c0,c1,c2 -> rule = {c0[3:0], c1[5:0], c2[5:0]}
                2'b01: rule_sh <= {rule_sh[9:0], data};
                // 2 chunks s0,s1   -> sw   = {s0[1:0], s1[5:0]}
                2'b10: sw      <= {sw[1:0], data};
                default: ;
            endcase
        end
    end
endmodule
