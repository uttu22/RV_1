`default_nettype none

module datapath
#(parameter WIDTH =32 )
import rv32i_pkg::* ;
(
    input ...
); 

//example 
//inst_mem_o  -->> instruction memory out 


//FETCH STAGE
logic [WIDTH-1:0] inst_mem_o;   //instruction memory output 
logic [WIDTH-1:0] curr_pc_o;
logic [WIDTH-1:0] pc_f_o;
logic [WIDTH-1:0] pc_plus_four_o;
logic [WIDTH-1:0] fetch_add_mux_o;

//DECODE STAGE SIGNALS 
logic [WIDTH-1:0] inst_dec_reg_o;
logic [WIDTH-1:0] imm_gen_o;
logic [WIDTH-1:0] pc_dec_o;
logic [WIDTH-1:0] add_gen_o;
logic [WIDTH-1:0] rs1_o;
logic [WIDTH-1:0] rs2_o;
logic [WIDTH-1:0] alu_src_a_mux_o;
logic [WIDTH-1:0] alu_src_b_mux_o;

//EXECUTE STAGE SIGNALS

logic [WIDTH-1:0] src_reg_a_o;
logic [WIDTH-1:0] src_reg_b_o;
logic [WIDTH-1:0] alu_o;
logic [WIDTH-1:0] alu_mux_o;


// LOAD STORE STAGE SIGNALS 

logic [WIDTH-1:0] exc_res_reg_o;
logic [WIDTH-1:0] 






inst_mem()





endmodule