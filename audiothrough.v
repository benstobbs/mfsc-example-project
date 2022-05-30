module audiothrough(
    clk,

    adc_cs,
    adc_clk,
    adc_din,
    adc_dout,

    dac_cs,
    dac_clk,
    dac_sdi,

    data_out,

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

output adc_cs, adc_clk, adc_din, dac_cs, dac_clk, dac_sdi;
input clk, adc_dout, x0_neg, x1_neg, x2_neg, y1_neg, y2_neg;
input [16:0] x0, x1, x2, y1, y2;

output [9:0] data_out;


wire clk15; // 1.5MHz clock
clkdiv32 clkdiv32 (
    .clkin(clk),
    .clkout(clk15)
);

reg [5:0] counter = 0;
always @ (posedge clk15)
    if (counter >= 21)
        counter <= 0;
    else
        counter <= counter + 1;

wire start;
assign start = (counter == 0);

reg [9:0] dac_in = 0;
wire [9:0] adc_out, filter_out;

always @ (posedge clk15)
    if (counter == 21)
        dac_in <= filter_out;

assign data_out = dac_in;

reg filterclock;
always @ (posedge clk15)
    if (counter == 20)
        filterclock = 1;
    else
        filterclock = 0;

adc adc(
    .clk(clk15),
    .start(start),
    .dout(adc_out),

    .adc_cs(adc_cs),
    .adc_clk(adc_clk),
    .adc_din(adc_din),
    .adc_dout(adc_dout)
);

biquad_filter biquad_filter(
    .clk(filterclock),
    .x(adc_out),
    .y(filter_out),

    .x0(x0),
    .x0_neg(x0_neg),
    .x1(x1),
    .x1_neg(x1_neg),
    .x2(x2),
    .x2_neg(x2_neg),
    .y1(y1),
    .y1_neg(y1_neg),
    .y2(y2),
    .y2_neg(y2_neg)
);

dac dac(
    .clk(clk15),
    .start(start),
    .din({dac_in, 2'b0}),

    .dac_cs(dac_cs),
    .dac_clk(dac_clk),
    .dac_sdi(dac_sdi)
);

endmodule