import typedefs::*;      // import package
module control(
    input logic clk, rst_, zero,
    input opcode_t opcode,
    output logic load_ac, mem_rd, mem_wr, inc_pc, load_pc, load_ir, halt
);
    timeunit 1ns;
    timeprecision 100ps;

    state_t current_state, next_state;
    logic aluop;
    assign aluop = (opcode inside {ADD, AND, XOR, LDA});
    // state memory
    always_ff @(posedge clk, negedge rst_) begin: STATE_MEMORY
        if(!rst_) begin
            current_state <= INST_ADDR;
        end else begin
            current_state <= next_state;
        end
    end
    // state logic and output logic 
    always_comb begin: STATE_LOGIC_AND_OUTPUT
       {load_ac, load_pc, mem_rd, mem_wr, inc_pc, load_ir, halt} = 0;
       next_state = current_state;
        unique case(current_state)
            INST_ADDR: next_state = INST_FETCH;
            INST_FETCH: begin
                mem_rd = 1;
                next_state = INST_LOAD;
            end
            INST_LOAD: begin
                mem_rd = 1;
                load_ir = 1;
                next_state = IDLE;
            end
            IDLE: begin
                mem_rd = 1;
                load_ir = 1;
                next_state = OP_ADDR;
            end
            OP_ADDR: begin
                halt = (opcode == HLT);
                inc_pc = 1;
                next_state = OP_FETCH;
            end
            OP_FETCH: begin
                mem_rd = aluop;
                next_state = ALU_OP;
            end
            ALU_OP: begin
                mem_rd =  aluop;
                inc_pc = ((opcode == SKZ) && zero);
                load_ac = aluop;
                load_pc = (opcode == JMP);
                next_state = STORE;
            end
            STORE: begin
                mem_rd = aluop;
                inc_pc = (opcode == JMP);
                load_ac = aluop;
                load_pc = (opcode == JMP);
                mem_wr = (opcode == STO);
                next_state = INST_ADDR;
            end
        endcase
    end
endmodule