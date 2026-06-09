`default_nettype none


import rv32i_pkg::* ;

module datapath
#(parameter WIDTH =32 )
(
    input logic clk,
    input logic _reset,

    //from hazard logic 
    input logic stall_if,
    input logic stall_id,
    input logic stall_ex,
    input logic nop_id,
    input logic nop_ex,
    
    //from control logic 
    input logic id_jump_en,
    input logic id_b_inst_en,
    input logic id_imm_en,
    input logic id_jal_en,
    input logic id_load_en,
    input logic id_store_en,
    input logic id_auipc_en,
    input logic [4:0] id_rs1_add,
    input logic [4:0] id_rs2_add,
    input logic [4:0] id_rd_add,
    input logic [2:0] id_fun3,
    input logic id_fun7_5,

    //from forward block 
    input logic [1:0] id_rs1_mux_sel,
    input logic [1:0] id_rs2_mux_sel,
    input logic [2:0] ex_alu_a_mux_sel,
    input logic [2:0] ex_alu_b_mux_sel,


    // to other blocks 
    output logic [WIDTH-1:0] id_inst,    
    output logic [4:0] ex_rs1_add,
    output logic [4:0] ex_rs2_add,
    output logic [4:0] ex_rd_add,
    output logic [4:0] mem_rd_add,
    output logic [4:0] wb_rd_add
    output logic [3:0] ex_alu_flag,
    output logic mem_load_en ;
    output logic ex_branch_taken;

); 



rv32i_pkg::if_t     if_next     , if_reg;
rv32i_pkg::if_id_t  if_id_next  , if_id_reg;
rv32i_pkg::id_ex_t  id_ex_next  , id_ex_reg;
rv32i_pkg::ex_mem_t ex_mem_next , ex_mem_reg;
rv32i_pkg::mem_wb_t mem_wb_next , mem_wb_reg;


//----------------------------------
/// IF INTIALIZATIONS 
//---------------------------------

//FETCH STAGE SIGNALS

logic [WIDTH-1:0] if_inst_mem_o;   //instruction memory output 

inst_mem #(
    .WORD_WIDTH(32),
    .MEMORY_WIDTH(10)
)
u_inst_mem(
    .clk(clk),
    .read_en(~stall_if),
    .inst_add(if_next.pc),
    .data_out(if_inst_mem_o)
);

//------------------

always_comb begin
    if_next.pc = (id_ex_reg.branch_taken)? id_ex_reg.address_data : if_reg.pc_pre_fetch  ;
    if_next.pc_pre_fetch = if_next.pc + 32'd4;
end

assign if_id_next.inst = (nop_id)? 32'h13 : if_inst_mem_o ; 
assign if_id_next.pc = if_next.pc ;


//----------------------
// ID STAGE INITIALIZATIONS
//----------------------


//DECODE STAGE SIGNALS 

//helping signals 
logic [WIDTH-1:0] id_reg_bank_rs1;
logic [WIDTH-1:0] id_reg_bank_rs2;
logic [WIDTH-1:0] id_rs1;
logic [WIDTH-1:0] id_rs2;
logic [WIDTH-1:0] id_imm;
logic reg_we = (mem_wb_reg.rd_add != 5'b0 );
//REG BANK 
reg_bank u_id_reg_bank(
    .we(reg_we),
    .clk(clk),
    ._reset(_reset),
    .rd_in(mem_wb_reg.mem_data),  //<<-- unsolved
    .rs1_sel(id_rs1_add),
    .rs2_sel(id_rs2_add),
    .rd_sel (id_rd_add ),
    .rs1_out(id_reg_bank_rs1),
    .rs2_out(id_reg_bank_rs2)
);


//IMM GENERATOR
imm_gen u_id_imm_gen(
    .inst(if_id_reg.inst),
    .imm(id_imm)
);


always_comb begin
    case(id_rs1_mux_sel)
        'b00 : id_rs1 = id_reg_bank_rs1 ;
        'b01 : id_rs1 = ex_mem_reg.ex_data ;
        'b10 : id_rs1 = mem_wb_reg.mem_data ;
        'b11 : id_rs1 = 'b0 ;
    endcase
    
    case(id_rs2_mux_sel)
        'b00 : id_rs2 = id_reg_bank_rs2 ;
        'b01 : id_rs2 = ex_mem_reg.ex_data ;
        'b10 : id_rs2 = mem_wb_reg.mem_data ;
        'b11 : id_rs2 = 'b0 ;
    endcase
end


//BRANCH COMPARATOR / LOGIC 
branch_logic u_id_branch_logic(
    .branch_enable(id_b_inst_en),
    .jump_enable(id_jump_en),
    .id_rs1(id_rs1),
    .id_rs2(id_rs2),
    .fun3(id_fun3),
    .take_branch(id_ex_next.branch_taken)
);


    //src a / b reg input mux
    always_comb begin
        id_ex_next.src_a = (id_jump_en || id_auipc_en )?  if_reg.pc : id_rs1 ;
        id_ex_next.src_b = id_rs2;
        if(id_imm_en) id_ex_next.src_b = id_imm;
        else if(id_jump_en) id_ex_next.src_b = 'd4  ;
    end


    //address generator   
    //id_jump_en dosnt affect address calculation
    assign id_ex_next.address_data = id_imm + ((id_b_inst_en || id_jal_en )? if_id_reg.pc : id_rs1) ;



    assign id_ex_next.fun3     = id_fun3 ;
    assign id_ex_next.fun7_5   = id_fun7_5 ;
    assign id_ex_next.load_en  = id_load_en ;
    assign id_ex_next.store_en = id_store_en ;
    assign id_ex_next.rs1_add  = id_rs1_add ;
    assign id_ex_next.rs2_add  = id_rs2_add ;
    assign id_ex_next.rd_add   = id_rd_add ;

//-----------------
//EX STAGE INITIALIZATIONS
//----------------



assign ex_mem_next.fun3 = id_ex_reg.fun3 ;
assign ex_mem_next.rd_add = id_ex_reg.rd_add ;
assign ex_mem_next.load_en = id_ex_reg.load_en ;

//helping signals
logic [WIDTH-1:0] ex_alu_inp_a;
logic [WIDTH-1:0] ex_alu_inp_b;

//ALU INPUT A MUX
alu_input_mux u_ex_alu_input_a_mux(
    .src(id_ex_reg.src_a),
    .mem_fwd(ex_mem_reg.ex_data),
    .wb_fwd(mem_wb_reg.mem_data),
    .alu_mux_sel(ex_alu_a_mux_sel),
    .mux_op(ex_alu_inp_a)
);
//ALU INPUT B MUX
alu_input_mux u_ex_alu_input_b_mux(
    .src(id_ex_reg.src_b),
    .mem_fwd(ex_mem_reg.ex_data),
    .wb_fwd(mem_wb_reg.mem_data),
    .alu_mux_sel(ex_alu_b_mux_sel),
    .mux_op(ex_alu_inp_b)
);



//ALU
alu u_ex_alu(
    .FUN7_5(id_ex_reg.fun7_5),
    .FUN3(id_ex_reg.fun3),
    .A(ex_alu_inp_a),
    .B(ex_alu_inp_b),
    .C(ex_alu_flag[0]) , 
    .Z(ex_alu_flag[1]) ,
    .V(ex_alu_flag[2]) ,
    .S(ex_alu_flag[3]) ,
    .OUT(ex_mem_next.ex_data)
);



//------------------
//MEM STAGE INTIALISATION
//------------------



logic [WIDTH-1:0] ex_store_data;
logic [WIDTH-1:0] mem_load_data;

assign ex_store_data = ex_alu_inp_b;
assign mem_rd_add = ex_mem_reg.rd_add;


data_mem #(
    .WORD_WIDTH(32),
    .MEMORY_WIDTH(10)
)
u_data_mem(
    .clk(clk),
    .we(id_ex_reg.store_en),
    .re(id_ex_reg.load_en),
    ._reset(_reset),
    .byte_mask(), //<-- still nedd to fix
    .data_in(ex_store_data),
    .data_address(id_ex_reg.address_data),
    .data_out(mem_load_data)
);


assign mem_wb_next.mem_data = (ex_mem_reg.load_en)? mem_load_data : ex_mem_reg.ex_data;
assign mem_wb_next.rd_add = ex_mem_reg.rd_add;


//---------------------
// WRITE BACK STAGE INITIALIZATIONS 
//----------------------

//-----------------------------
//PIPELINE REGISTER 
//---------------------------



always_ff @(posedge clk or negedge _reset) begin
    if(!_reset) begin
        if_reg <= 'b0;
        if_id_reg <= 'b0;
        id_ex_reg <= 'b0;
        ex_mem_reg <= 'b0;
        mem_wb_reg <= 'b0;
    end
    else  begin
        if(~stall_if) if_reg <= if_next;
        if(~stall_id) if_id_reg <= if_id_next;
        if(~stall_ex) id_ex_reg <= id_ex_next;
        ex_mem_reg <= ex_mem_next;
        mem_wb_reg <= mem_wb_next;
    end
end


//output signals
assign id_inst = if_id_reg.inst;
//---------------
assign ex_rs1_add = id_ex_reg.rs1_add;
assign ex_rs2_add = id_ex_reg.rs2_add;
assign ex_rd_add = id_ex_reg.rd_add;
// ex_alu_flag , already outputed from ex_alu
//---------------
assign mem_rd_add = ex_mem_reg.rd_add;
//--------------
assign wb_rd_add = mem_wb_reg.rd_add;




endmodule