import typedefs::*;          // import typedefs
module alu(
    input logic [7:0] data, accum,
    input opcode_t opcode,
    input logic clk,
    output logic [7:0] out,
    output logic zero
);
    timeunit 1ns;
    timeprecision 100ps;
    // cases for the opcode with a synchronous output
    always_ff @(negedge clk) begin
        unique case(opcode)
            HLT: out <= accum;
            SKZ: out <= accum;
            ADD: out <= data + accum;
            AND: out <= data & accum;
            XOR: out <= data ^ accum;
            LDA: out <= data;
            STO: out <= accum;
            JMP: out <= accum;
        endcase
    end
    // zero 
    assign zero = (accum == 0);
    
endmodule