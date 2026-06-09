module forwarding_unit
(
    

    input logic       mem_load_en,

    input logic [2:0] id_rs1_dependency, 
    input logic [2:0] id_rs2_dependency,
    input logic [1:0] ex_rs1_dependency, 
    input logic [1:0] ex_rs2_dependency,
 

    output logic [1:0] id_rs1_mux_sel,
    output logic [1:0] id_rs2_mux_sel,

    output logic [2:0] ex_alu_a_mux_sel,
    output logic [2:0] ex_alu_b_mux_sel

);

logic [1:0] fwd_rs1_id;
logic [1:0] fwd_rs2_id;
logic [1:0] fwd_rs1_ex;
logic [1:0] fwd_rs2_ex;


assign fwd_rs1_id[0] = id_rs1_dependency[1] && (~mem_load_en);
assign fwd_rs1_id[1] = id_rs1_dependency[2];

assign fwd_rs2_id[0] = id_rs2_dependency[1] && (~mem_load_en);
assign fwd_rs2_id[1] = id_rs2_dependency[2];

assign fwd_rs1_ex[0] = ex_rs1_dependency[0] && (~mem_load_en); 
assign fwd_rs1_ex[1] = ex_rs1_dependency[1];

assign fwd_rs2_ex[0] = ex_rs2_dependency[0] && (~mem_load_en);
assign fwd_rs2_ex[1] = ex_rs2_dependency[1];

always_comb begin
    // Defaults
    id_rs1_mux_sel   = 2'b00;
    id_rs2_mux_sel   = 2'b00;
    ex_alu_a_mux_sel = 3'b001;
    ex_alu_b_mux_sel = 3'b001;

    casez(fwd_rs1_id)
        2'b00 : id_rs1_mux_sel = 2'b00;   // select rs1_id
        2'b?1 : id_rs1_mux_sel = 2'b01;   // select mem_fwd
        2'b10 : id_rs1_mux_sel = 2'b10;   // select wb_fwd
    endcase

    casez(fwd_rs2_id)
        2'b00 : id_rs2_mux_sel = 2'b00;  // select rs2_id 
        2'b?1 : id_rs2_mux_sel = 2'b01;  // select mem_fwd 
        2'b10 : id_rs2_mux_sel = 2'b10;  // select wb_fwd 
    endcase

    casez(fwd_rs1_ex)
        2'b00 : ex_alu_a_mux_sel = 3'b001; // select src_a
        2'b?1 : ex_alu_a_mux_sel = 3'b010; // select mem_fwd
        2'b10 : ex_alu_a_mux_sel = 3'b100; // select wb_fwd
    endcase

    casez(fwd_rs2_ex)
        2'b00 : ex_alu_b_mux_sel = 3'b001; // select src_b
        2'b?1 : ex_alu_b_mux_sel = 3'b010; // select mem_fwd
        2'b10 : ex_alu_b_mux_sel = 3'b100; // select wb_fwd
    endcase
end

endmodule