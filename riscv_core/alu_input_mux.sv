module alu_input_mux #(parameter WIDTH =32 )
(
    input logic[WIDTH-1 : 0]  src,
    input logic[WIDTH-1 : 0]  mem_fwd,
    input logic[WIDTH-1 : 0]  wb_fwd,
    input logic[2:0]          alu_mux_sel ,
    output logic[WIDTH-1:0]   mux_op
);




assign mux_op = (src & ({WIDTH{alu_mux_sel[0]}})) |
                (mem_fwd & ({WIDTH{alu_mux_sel[1]}})) |
                (wb_fwd & ({WIDTH{alu_mux_sel[2]}})) ;
                

endmodule