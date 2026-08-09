module reg_bank #(parameter WIDTH = 32 )(
    input logic            clk,
    input logic            _reset,
    input logic[WIDTH-1:0] rd_in,
    input logic[4:0]       rs1_sel,
    input logic[4:0]       rs2_sel,
    input logic[4:0]       rd_sel,
    output logic[WIDTH-1:0] rs1_out,
    output logic[WIDTH-1:0] rs2_out
);
    logic [WIDTH-1:0] REG [0:31] ;
    
    assign rs1_out = (rs1_sel == 5'b0 )? 'b0 : REG[rs1_sel] ;
    assign rs2_out = (rs2_sel == 5'b0 )? 'b0 : REG[rs2_sel] ;

    always_ff @( posedge clk or negedge _reset ) begin : reg_bank
        if(!_reset) begin
            foreach  (REG[i]) begin
                REG[i]<= 'b0 ;
            end
        end
        else if (rd_sel != 5'b0) begin
            REG[rd_sel] <= rd_in ;
        end 
    end


endmodule