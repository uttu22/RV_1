module alu_input_logic #(parameter WIDTH = 32) (
    input logic[WIDTH-1:0] rs1 ,
    input logic[WIDTH-1:0] rs2 ,
    input logic[WIDTH-1:0] imm ,
    input logic[6:0]       opcode,
    output logic[WIDTH-1:0] in_a ,
    output logic[WIDTH-1:0] in_b ,
);

    always_comb begin : alu_input_logic
        in_a=rs1;
        if(opcode == OP_R_ARITH ) in_b = rs2
        else                      in_b=imm;
        
//         case(opcode)
//             OP_U_LUI    : in_b = imm,
//             OP_U_AIUPC  : in_b = imm, 
//             OP_J_JAL    : in_b = imm,
//             OP_I_JALR   : in_b = imm,
//             OP_I_LOAD   : in_b = imm,
//             OP_I_ARITH  : in_b = imm,
//             OP_I_SHIFT  : in_b = imm,
//             OP_B_BRANCH = ommitted because we are implementing it in decode stage
//             OP_S_STORE  : in_b = imm,
//             OP_R_ARITH  : in_b = rs2,
//             OP_FENCE    = 7'b0001111,
//             OP_SYS_CALL = 7'b1110011
//         endcase
    end


endmodule