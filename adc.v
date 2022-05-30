module adc(
    clk,
    start,
    done,
    dout,

    adc_cs,
    adc_clk,
    adc_din,
    adc_dout,
);

input clk;
input start;
output done;
output reg [9:0] dout;

output adc_cs;
output adc_clk;
output adc_din;
input adc_dout;

assign adc_clk = clk;

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

// Output: ADC_CS
assign adc_cs = (state == 6'd17);

// Output: DONE
assign done = (state == 6'd17);

// Output: ADC_DIN
always @ (state)
    case (state)
        6'd0: adc_din <= 1; // Start bit = 1
        default: adc_din <= 0; // Differential mode, CH0 = IN+, CH1 = IN-
    endcase

// Process input: ADC_DOUT
always @ (negedge clk)
    if (state >= 6'd7 && state <= 6'd16)
        dout[6'd16 - state] <= adc_dout;

endmodule