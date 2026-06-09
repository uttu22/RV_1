module control_path 
#(parameter WIDTH = 32)
(



    input logic [WIDTH-1:0] id_inst,

    output logic [4:0] id_rs1_add,
    output logic [4:0] id_rs2_add,
    output logic [4:0] id_rd_add,
    output logic id_jump_en,
    output logic id_jal_en,
    output logic id_b_inst_en,
    output logic id_imm_en,
    output logic id_load_en,
    output logic id_store_en,
    output logic [2:0] id_fun3,
    output logic  id_fun7_5,
    output logic id_auipc_en


);

import rv32i_pkg::* ;

logic [6:0] opcode ;
logic [4:0] inst_rs1_add ;
logic [4:0] inst_rs2_add;
logic [4:0] inst_rd_add ;
logic [2:0] inst_fun3 ;
logic inst_fun7_5 ;


assign opcode = id_inst[6:0];
assign inst_rs1_add = id_inst[19:15];
assign inst_rs2_add = id_inst[24:20];
assign inst_rd_add = id_inst[11:7];
assign inst_fun3 = id_inst[14:12];
assign inst_fun7_5 = id_inst[30]; //<<--doubt



always_comb begin
    id_rs1_add = 'b0;
    id_rs2_add = 'b0;
    id_rd_add  = 'b0;
    id_jump_en = 'b0;
    id_jal_en =  'b0;
    id_b_inst_en = 'b0;
    id_imm_en =    'b0;         
    id_load_en =   'b0;
    id_store_en =  'b0;
    id_fun3     =  3'b000; //ADD
    id_fun7_5   =  1'b0;
    id_auipc_en = 'b0;


    case(opcode)
        OP_U_LUI  :  begin
            id_imm_en = 'b1;
            id_rd_add = inst_rd_add;
            end

        OP_U_AUIPC:  begin
            id_imm_en = 'b1;
            id_auipc_en = 'b1;
            id_rd_add = inst_rd_add;
            
            end

        OP_J_JAL  :  begin
            id_jump_en = 'b1;
            id_jal_en = 'b1;
            id_rd_add = inst_rd_add;
            end

        OP_I_JALR :  begin
            id_imm_en = 'b1;
            id_jump_en = 'b1;
            id_rd_add = inst_rd_add;
            //address calculator take rs1 as default 
            end

        OP_I_LOAD :  begin
            id_load_en = 'b1;
            id_fun3 = inst_fun3;
            id_rd_add = inst_rd_add;
            end

        OP_I_ARITH_SHIFT  :begin
            id_rs1_add = inst_rs1_add;
            id_imm_en = 'b1;
            id_fun3 = inst_fun3;
            id_rd_add = inst_rd_add;
            id_fun7_5 = inst_fun7_5;
            end
        OP_B_BRANCH :begin
            id_b_inst_en = 'b1;
            id_fun3 = inst_fun3;
            
            end
        OP_S_STORE  :begin
            id_store_en = 'b1;
            id_fun3 = inst_fun3;
            id_rs2_add = inst_rs2_add;
            end
        OP_R_ARITH  :begin
            id_rs1_add = inst_rs1_add;
            id_rs2_add = inst_rs2_add;
            id_rd_add = inst_rd_add;
            id_fun3 = inst_fun3;
            id_fun7_5 = inst_fun7_5;

            end
        OP_FENCE    :begin


            
            end
        OP_SYS_CALL :begin
            
            end 
        default :begin
                id_rs1_add = 'b0;
                id_rs2_add = 'b0;
                id_rd_add  = 'b0;
                id_jump_en = 'b0;
                id_jal_en =  'b0;
                id_b_inst_en = 'b0;
                id_imm_en =    'b0;         
                id_load_en =   'b0;
                id_store_en =  'b0;
                id_fun3     =  3'b000; //ADD
                id_fun7_5   =  1'b0;
                id_auipc_en = 'b0;
        end
    endcase
end

endmodule
