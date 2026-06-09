
module branch_logic #(parameter WIDTH = 32)
(   
    input logic branch_enable,
    input logic jump_enable  ,
    input logic[WIDTH-1:0] id_rs1,
    input logic[WIDTH-1:0] id_rs2,
    input logic [2:0] fun3 ,
    output logic take_branch
);


import rv32i_pkg::* ;







always_comb begin
    take_branch = 1'b0;
    if(branch_enable) begin
        if(jump_enable) begin
            take_branch = 1'b1;
        end
        else begin
            case(fun3)
                F3_BEQ   : take_branch = ((id_rs1==id_rs2)   ? 1'b1 : 1'b0) ;
                F3_BNE   : take_branch = ((id_rs1!=id_rs2)   ? 1'b1 : 1'b0) ;
                F3_BLT   : take_branch = ((id_rs1<id_rs2)   ? 1'b1 : 1'b0) ;
                F3_BGE   : take_branch = ((id_rs1>=id_rs2)   ? 1'b1 : 1'b0) ;
                F3_BLTU  : take_branch = (($unsigned(id_rs1)<$unsigned(id_rs2))  ? 1'b1 : 1'b0) ;
                F3_BGEU : take_branch = (($unsigned(id_rs1)>=$unsigned(id_rs2)) ? 1'b1 : 1'b0) ;
                default : take_branch = 1'b0; 
            endcase
        end
    end
end

endmodule