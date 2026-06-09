module branch_add_gen #(
    parameter WIDTH = 32 
)
(   
    input logic jalr_en ,
    input logic[WIDTH-1:0] pc_id,
    input logic[WIDTH-1:0] rs1_id ,
    input logic[WIDTH-1:0] imm  ,
    output logic[WIDTH-1:0] branch_add 

);

    assign branch_add = imm  + ((jalr_en)?  rs1_id : pc_id);

endmodule
