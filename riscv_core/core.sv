module core(
    input clk , 
    input _reset
);
    localparam WIDTH = 32 ;

    logic [WIDTH-1:0] id_inst,

    logic [4:0] id_rs1_add  ;
    logic [4:0] id_rs2_add  ;
    logic [4:0] id_rd_add   ;
    logic id_jump_en        ;
    logic id_jal_en         ;
    logic id_b_inst_en      ;
    logic id_imm_en         ;
    logic id_load_en        ;
    logic id_store_en       ;
    logic [2:0] id_fun3     ;
    logic  id_fun7_5        ;
    logic id_auipc_en       ;



    

endmodule