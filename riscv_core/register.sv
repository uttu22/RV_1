module register 
#(parameter WIDTH = 32)
(
    input  logic             clk,
    input  logic             _reset,
    input  logic             enable,
    input  logic [WIDTH-1:0] reg_in,
    output logic [WIDTH-1:0] reg_out
);

always_ff @(posedge clk or negedge _reset) begin
    if(!_reset) reg_out <= 'b0;
    else if(enable) reg_out <= reg_in;

end

endmodule
