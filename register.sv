module register #(parameter WIDTH = 8)(
    output logic [WIDTH-1:0] out,
    input logic [WIDTH-1:0] data,
    input logic clk, rst_,
    input logic enable
);
    timeunit 1ns;
    timeprecision 100ps;
    always_ff @(posedge clk, negedge rst_) begin: REGISTER
        if(!rst_) begin
            out <= '0;
        end else if(enable) begin
            out <= data;
        end
    end
endmodule