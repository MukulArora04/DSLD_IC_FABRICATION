// tb_wave.v - short scenario that dumps a waveform (wave.vcd) for the validation document.
`timescale 1ns/1ps
module tb_wave;
    reg clk = 0, rst = 1; reg [1:0] op = 0; reg [3:0] addr = 0; reg [5:0] data = 0;
    wire [3:0] match_addr; wire match_valid, multi_match;
    tcam_top dut (.clk(clk), .rst(rst), .op(op), .addr(addr), .data(data),
                  .match_addr(match_addr), .match_valid(match_valid), .multi_match(multi_match));
    always #50 clk = ~clk;   // 10 MHz
    task step; input [1:0] o; input [3:0] a; input [5:0] d;
        begin @(negedge clk); op = o; addr = a; data = d; @(posedge clk); #1; end endtask
    task load_rule; input [3:0] a; input [15:0] r;
        begin step(2'b01,a,{2'b00,r[15:12]}); step(2'b01,a,r[11:6]); step(2'b01,a,r[5:0]); step(2'b11,a,6'd0); end endtask
    task do_search; input [7:0] s;
        begin step(2'b10,4'd0,{4'b0000,s[7:6]}); step(2'b10,4'd0,s[5:0]); step(2'b00,4'd0,6'd0); end endtask
    initial begin
        $dumpfile("wave.vcd"); $dumpvars(0, tb_wave);
        repeat (3) @(posedge clk); @(negedge clk); rst = 0; step(0,0,0);
        load_rule(4'd3, 16'b01_01_01_01_01_01_01_01);   // exact 0x00 -> entry 3
        load_rule(4'd5, 16'b10_10_10_10_10_10_10_10);   // exact 0xFF -> entry 5
        do_search(8'h00);                               // expect match_addr 3
        do_search(8'hFF);                               // expect match_addr 5
        do_search(8'h0F);                               // expect no match
        load_rule(4'd2, 16'b01_01_00_00_00_00_00_00);   // 00xxxxxx -> entry 2
        do_search(8'h00);                               // entries 2 and 3 match: addr 2, multi_match
        step(0,0,0); step(0,0,0);
        $finish;
    end
endmodule
