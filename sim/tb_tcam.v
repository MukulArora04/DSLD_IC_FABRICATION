// tb_tcam.v - self-checking testbench (Verilog-2001)
// Directed tests with explicit expectations + randomized tests against an
// independent behavioral reference model.
`timescale 1ns/1ps
module tb_tcam;
    reg        clk, rst;
    reg  [1:0] op;
    reg  [3:0] addr;
    reg  [5:0] data;
    wire [3:0] match_addr;
    wire       match_valid, multi_match;

    tcam_top dut (.clk(clk), .rst(rst), .op(op), .addr(addr), .data(data),
                  .match_addr(match_addr), .match_valid(match_valid),
                  .multi_match(multi_match));

    initial clk = 1'b0;
    always #50 clk = ~clk;                 // 10 MHz

    reg [15:0] ref_mem [0:15];
    reg [15:0] ref_valid;
    reg [7:0]  ref_sw;
    integer    errors, checks;

    function [15:0] ref_ml;
        input [7:0] s;
        integer i, j;
        reg ok;
        reg [1:0] c;
        begin
            ref_ml = 16'h0000;
            for (i = 0; i < 16; i = i + 1) begin
                ok = ref_valid[i];
                for (j = 0; j < 8; j = j + 1) begin
                    c = ref_mem[i] >> (2*j);
                    case (c)
                        2'b01: if (s[j])  ok = 1'b0;
                        2'b10: if (!s[j]) ok = 1'b0;
                        2'b11: ok = 1'b0;
                        default: ;
                    endcase
                end
                ref_ml[i] = ok;
            end
        end
    endfunction

    // Drive on falling edge, sample just after the rising edge.
    task step;
        input [1:0] o; input [3:0] a; input [5:0] d;
        begin
            @(negedge clk); op = o; addr = a; data = d;
            @(posedge clk); #1;
        end
    endtask

    task load_rule;
        input [3:0] a; input [15:0] r;
        begin
            step(2'b01, a, {2'b00, r[15:12]});
            step(2'b01, a, r[11:6]);
            step(2'b01, a, r[5:0]);
            step(2'b11, a, 6'd0);
            ref_mem[a] = r; ref_valid[a] = 1'b1;
        end
    endtask

    task do_search;
        input [7:0] s;
        begin
            step(2'b10, 4'd0, {4'b0000, s[7:6]});
            step(2'b10, 4'd0, s[5:0]);
            ref_sw = s;
            step(2'b00, 4'd0, 6'd0);       // NOP: result must persist
        end
    endtask

    task check_exp;
        input       ev; input [3:0] ea; input [255:0] name;
        begin
            checks = checks + 1;
            if (match_valid !== ev || (ev && match_addr !== ea)) begin
                errors = errors + 1;
                $display("FAIL %0s: exp valid=%b addr=%0d, got valid=%b addr=%0d",
                         name, ev, ea, match_valid, match_addr);
            end else $display("PASS %0s", name);
        end
    endtask

    reg [15:0] m;
    reg [3:0]  ea;
    integer    k;
    task check_model;
        begin
            m = ref_ml(ref_sw);
            ea = 4'd0;
            for (k = 15; k >= 0; k = k - 1) if (m[k]) ea = k;
            checks = checks + 1;
            if (match_valid !== (|m) ||
                multi_match !== ((m & (m - 16'd1)) != 16'd0) ||
                ((|m) && match_addr !== ea)) begin
                errors = errors + 1;
                $display("FAIL model: sw=%h exp m=%b, got v=%b a=%0d mm=%b",
                         ref_sw, m, match_valid, match_addr, multi_match);
            end
        end
    endtask

    integer n, e;
    reg [15:0] rr;
    initial begin
        errors = 0; checks = 0; ref_valid = 16'h0000; ref_sw = 8'h00;
        rst = 1'b1; op = 2'b00; addr = 4'd0; data = 6'd0;
        repeat (3) @(posedge clk);
        @(negedge clk); rst = 1'b0;
        step(2'b00, 4'd0, 6'd0);

        check_exp(1'b0, 4'd0, "T0 empty after reset");

        load_rule(4'd3, 16'b01_01_01_01_01_01_01_01);   // matches 0x00
        load_rule(4'd5, 16'b10_10_10_10_10_10_10_10);   // matches 0xFF
        do_search(8'h00); check_exp(1'b1, 4'd3, "T1a exact 0x00 -> 3");
        do_search(8'hFF); check_exp(1'b1, 4'd5, "T1b exact 0xFF -> 5");
        do_search(8'h0F); check_exp(1'b0, 4'd0, "T1c 0x0F no match");

        // bit7 = 0, bit6 = 1, bits5..0 = X
        load_rule(4'd9, 16'b01_10_00_00_00_00_00_00);
        do_search(8'b0111_1111); check_exp(1'b1, 4'd9, "T2a wildcard hit");
        do_search(8'b1100_0000); check_exp(1'b0, 4'd0, "T2b wildcard miss");

        load_rule(4'd7, 16'b01_01_00_00_00_00_00_00);
        load_rule(4'd2, 16'b01_01_00_00_00_00_00_00);
        do_search(8'h00);
        check_exp(1'b1, 4'd2, "T3 priority -> 2");
        if (multi_match !== 1'b1) begin errors = errors + 1; $display("FAIL T3 multi_match"); end

        load_rule(4'd0, 16'b11_00_00_00_00_00_00_00);
        do_search(8'h00); check_exp(1'b1, 4'd2, "T4a invalid cell skipped");
        load_rule(4'd1, 16'h0000);
        do_search(8'hA5); check_exp(1'b1, 4'd1, "T4b all-X matches anything");

        load_rule(4'd1, 16'b10_10_10_10_10_10_10_10);
        do_search(8'hA5); check_exp(1'b0, 4'd0, "T5 overwrite entry 1 (no match)");
        do_search(8'hFF); check_exp(1'b1, 4'd1, "T5b overwritten entry matches 0xFF");

        @(negedge clk); rst = 1'b1; @(posedge clk); #1;
        @(negedge clk); rst = 1'b0; @(posedge clk); #1;
        ref_valid = 16'h0000;
        do_search(8'hFF);
        check_exp(1'b0, 4'd0, "T6 reset clears entries");

        for (n = 0; n < 400; n = n + 1) begin
            rr = $random;
            e  = $random;
            if (n % 2) rr = rr & $random;
            load_rule(e[3:0], rr);
            do_search($random);
            check_model;
        end

        if (errors == 0) $display("*** ALL TESTS PASSED (%0d checks) ***", checks);
        else             $display("*** %0d ERRORS ***", errors);
        $finish;
    end

    initial begin #5000000; $display("TIMEOUT"); $finish; end
endmodule
