module dac(
    clk,
    start,
    done,
    din,

    dac_cs,
    dac_clk,
    dac_sdi,
);

input clk;
input start;
output done;
input [11:0] din;

output dac_cs;
output dac_clk;
output dac_sdi;

assign dac_clk = clk;

reg [5:0] state = 6'd17;

// State transition
always @ (negedge clk)
    if (state == 6'd17)
        if (start == 1'b1)
            state <= 0;
        else
            state <= 6'd17;
    else
        state <= state + 1;

// Output: DAC_CS
assign dac_cs = (state == 6'd17);

// Output: DONE
assign done = (state == 6'd17);

// Output: DAC_SDI
always @ (state)
    if (state == 0)
        dac_sdi <= 0;     // Channel A
    else if (state == 1)
        dac_sdi <= 0;     // Unbuffered Vref??
    else if (state == 2)
        dac_sdi <= 1;     // 1x output gain
    else if (state == 3)
        dac_sdi <= 1;     // No shutdown
    else if (state >= 4 && state <= 15)
        dac_sdi <= din[15 - state];
    else
        dac_sdi <= 0;

endmodule