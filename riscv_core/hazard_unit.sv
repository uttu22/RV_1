
//done
module hazard_unit #(parameter WIDTH = 32)
(   
    //from control unit 
    input logic [4:0] id_rs1_add, 
    input logic [4:0] id_rs2_add, 
    input logic id_b_inst_en , 
    
    //from datapath
    input logic [4:0] ex_rs1_add, 
    input logic [4:0] ex_rs2_add, 
    input logic [4:0] ex_rd_add,
    input logic [4:0] mem_rd_add,
    input logic [4:0] wb_rd_add,
    input logic       mem_load_en, 
    input logic       ex_branch_taken , 

    //to datapath
    output logic stall_if, 
    output logic stall_id, 
    output logic stall_ex,
    output logic nop_id, 
    output logic nop_ex,

    //to forwarding unit
    output logic [2:0] id_rs1_dependency, 
    output logic [2:0] id_rs2_dependency,
    output logic [1:0] ex_rs1_dependency, 
    output logic [1:0] ex_rs2_dependency

);


logic ex_rd_add_not_x0;
logic mem_rd_add_not_x0;
logic wb_rd_add_not_x0;

assign ex_rd_add_not_x0  = |ex_rd_add;
assign mem_rd_add_not_x0 = |mem_rd_add;
assign wb_rd_add_not_x0  = |wb_rd_add;

assign id_rs1_dependency[0] = (id_rs1_add == ex_rd_add   ) && ex_rd_add_not_x0;
assign id_rs1_dependency[1] = (id_rs1_add == mem_rd_add  ) && mem_rd_add_not_x0;
assign id_rs1_dependency[2] = (id_rs1_add == wb_rd_add   ) && wb_rd_add_not_x0 ;

assign id_rs2_dependency[0] = (id_rs2_add == ex_rd_add   ) && ex_rd_add_not_x0 ;
assign id_rs2_dependency[1] = (id_rs2_add == mem_rd_add  ) && mem_rd_add_not_x0 ;
assign id_rs2_dependency[2] = (id_rs2_add == wb_rd_add   ) && wb_rd_add_not_x0  ;

assign ex_rs1_dependency[0] = (ex_rs1_add == mem_rd_add  ) && mem_rd_add_not_x0 ; 
assign ex_rs1_dependency[1] = (ex_rs1_add == wb_rd_add   ) && wb_rd_add_not_x0;
assign ex_rs2_dependency[0] = (ex_rs2_add == mem_rd_add  ) && mem_rd_add_not_x0 ;
assign ex_rs2_dependency[1] = (ex_rs2_add == wb_rd_add   ) && wb_rd_add_not_x0  ;

assign stall_if = stall_id;
// assign stall_ex = (ex_rs1_dependency[0] || ex_rs2_dependency[0]) && mem_load_en ;
// assign stall_id = (stall_|| ((id_b_inst_en && (~ex_branch_taken))&&((id_rs1_dependency[0] || id_rs2_dependency[0]) || ((id_rs1_dependency[1] || id_rs2_dependency[1])&&(mem_load_en)))) ;

always_comb begin
  
    stall_id = 1'b0;
    stall_ex = 1'b0;

    if(ex_rs1_dependency[0] || ex_rs2_dependency[0]) begin
        stall_ex= (mem_load_en)? 1'b1 : 1'b0 ;
    end

    if(stall_ex==1'b1) stall_id = 1'b1;
    else if(id_b_inst_en && (~ex_branch_taken) )begin
        if (id_rs1_dependency[0] || id_rs2_dependency[0]) stall_id = 1'b1 ;
        else if(id_rs1_dependency[1] || id_rs2_dependency[1]) stall_id = (mem_load_en)? 1'b1 : 1'b0  ;
    end
end



always_comb begin
    nop_id= 'b0;
    nop_ex= 'b0;

    if(ex_branch_taken) begin
        nop_id = 'b1;
        nop_ex = 'b1;
    end
    else if(stall_id && (~stall_ex)) begin
        nop_ex = 'b1;
    end


end



endmodule