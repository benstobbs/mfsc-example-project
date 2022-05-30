module clkdiv32(
    input clkin,
    output clkout,
);
    reg [4:0] counter = 0;

    always @ (posedge clkin)
        counter <= counter + 1;

    assign clkout = counter[4];
    
endmodule