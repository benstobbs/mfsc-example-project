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
);

output adc_cs, adc_clk, adc_din, dac_cs, dac_clk, dac_sdi;
input clk, adc_dout;

output [9:0] data_out;


wire clk15; // 1.5MHz clock
clkdiv32 clkdiv32 (
    .clkin(clk),
    .clkout(clk15)
);

reg [5:0] counter = 0;
always @ (posedge clk15)
    if (counter >= 20)
        counter <= 0;
    else
        counter <= counter + 1;

wire start;
assign start = (counter == 0);

reg [9:0] data = 0;
wire [9:0] adc_out;

always @ (posedge clk15)
    if (counter == 20)
        data <= adc_out;

assign data_out = data;

adc adc(
    .clk(clk15),
    .start(start),
    .dout(adc_out),

    .adc_cs(adc_cs),
    .adc_clk(adc_clk),
    .adc_din(adc_din),
    .adc_dout(adc_dout)
);

dac dac(
    .clk(clk15),
    .start(start),
    .din({data, 2'b0}),

    .dac_cs(dac_cs),
    .dac_clk(dac_clk),
    .dac_sdi(dac_sdi)
);

endmodule