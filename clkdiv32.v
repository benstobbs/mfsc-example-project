module clkdiv32(
    clkin,
    clkout,
);

    input clkin;
    output clkout = 0;

    reg [4:0] counter = 0;

    always @ (posedge clkin)
        counter <= counter + 1;

    assign clkout = counter[4];
    
endmodule