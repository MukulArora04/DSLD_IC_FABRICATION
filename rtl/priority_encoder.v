// priority_encoder.v - 16 matchlines -> 4-bit address, lowest index wins
module priority_encoder (
    input  wire [15:0] ml,
    output reg  [3:0]  addr,
    output wire        valid,
    output wire        multi      // more than one matchline set
);
    integer k;
    always @(*) begin
        addr = 4'd0;
        for (k = 15; k >= 0; k = k - 1)
            if (ml[k]) addr = k[3:0];   // last assignment = lowest index
    end
    assign valid = |ml;
    assign multi = ((ml & (ml - 16'd1)) != 16'd0);
endmodule
