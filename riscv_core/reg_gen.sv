module reg_gen #(parameter WIDTH = 32 ; )(
    input logic [WIDTH-1:0] in ,
    input clk,
    input reset_n ,
    output logic [WIDTH-1:0] out 
)

always_ff @(posedge clk or negedge reset ) begin : ff_block
   if(!negedge_n) out<= 'b0;
   else out<= in ;
end
endmodule

