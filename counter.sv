module counter#(parameter WIDTH = 5)(
    input logic clk, rst_, load, enable,
    input logic [WIDTH-1:0] data,
    output logic [WIDTH-1:0] count
);
    timeunit 1ns;
    timeprecision 100ps;

    always_ff @(posedge clk, negedge rst_) begin
        if(!rst_) begin
            count <= '0;
        end else if(load) begin
            count <= data;
        end else if(enable) begin
            count <= count + 1;
        end 
    end
endmodule
