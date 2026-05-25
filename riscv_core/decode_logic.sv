module decode_logic #(parameter WIDTH = 32)(
    input logic clk,
    input logic[WIDTH-1:0] inst,
    output logic[4:0] rs1_sel, 
    output logic[4:0] rs2_sel, 
    output logic[4:0] rd_sel, 
)

assign {C,sum} = (add==1'b1)? ({1'b0,A} + {1'b0,B}) : ({1'b0,A} - {1'b0,B}) ;
assign Z = sum;  

endmodule