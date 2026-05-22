module ld_st_logic #(parameter WIDTH =32 )(
    input logic [6:0] opcode,
    input logic [WIDTH-1 :0] data_in,
    input logic [WIDTH-1 :0] data_out, 
)

