module biquad_filter(
    clk,
    x,
    y,

    x0,
    x0_neg,
    x1,
    x1_neg,
    x2,
    x2_neg,
    y1,
    y1_neg,
    y2,
    y2_neg,
);

input clk, x0_neg, x1_neg, x2_neg, y1_neg, y2_neg;
input [9:0] x;
input [16:0] x0, x1, x2, y1, y2;
output [9:0] y;

reg [9:0] x_1, x_2, y_1, y_2 = 0;

always @ (posedge clk) begin
    x_1 <= x;
    x_2 <= x_1;
    y_1 <= y;
    y_2 <= y_1;
end

wire [26:0] x0_calc, x1_calc, x2_calc, y1_calc, y2_calc;

assign x0_calc = (x0 * x) >> 10;
assign x1_calc = (x1 * x_1) >> 10;
assign x2_calc = (x2 * x_2) >> 10;
assign y1_calc = (y1 * y_1) >> 10;
assign y2_calc = (y2 * y_2) >> 10;

assign y = (x0_neg ? -x0_calc : x0_calc) + (x1_neg ? -x1_calc : x1_calc) + (x2_neg ? -x2_calc : x2_calc) + (y1_neg ? -y1_calc : y1_calc) + (y2_neg ? -y2_calc : y2_calc);

endmodule