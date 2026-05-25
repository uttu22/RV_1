module imm_logic  
import rv32i_pkg::*; 
(
    input  logic [31:0] inst,
    output logic [31:0] imm 
);
    logic[6:0] opcode ;
    assign opcode = inst[6:0];
    
    always_comb begin : imm_logic
        case(opcode)
            OP_U_LUI    : imm = {inst[31:12] , 12'b0} ;
            OP_U_AUIPC  : imm = {inst[31:12] , 12'b0} ;
            OP_J_JAL    : imm = {{12{inst[31]}} , inst[19:12] , inst[20] ,inst[30:25] ,inst[24:21], 1'b0};
            OP_I_JALR   : imm = {{21{inst[31]}} ,inst[30:20]};
            OP_I_LOAD   : imm = {{21{inst[31]}} ,inst[30:20]};
            OP_I_ARITH_SHIFT  : imm = {{21{inst[31]}} ,inst[30:20]};
            OP_B_BRANCH : imm = {{20{inst[31]}} , inst[7] , inst[30:25] , inst[11:8] , {1'b0}};
            OP_S_STORE  : imm = {{21{inst[31]}} , inst[30:25] , inst[11:8] , inst[7]};
            default : imm = 32'b0;
        endcase 
    end

endmodule