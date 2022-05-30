module biquad_filter(
    clk,
    x,
    y,
);

input clk;
input [9:0] x;
output [9:0] y;

reg [9:0] x_1, x_2, y_1, y_2 = 0;

always @ (posedge clk) begin
    x_1 <= x;
    x_2 <= x_1;
    y_1 <= y;
    y_2 <= y_1;
end

endmodule