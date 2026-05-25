typedef enum logic[2:0] {
    EQ = 3'b000,
    NE = 3'b001,
    LT = 3'b100,
    GE = 3'b101,
    LTU= 3'b110,
    GTEU= 3'b111
} B_FUN3 ;


module branch_logic #(parameter WIDTH = 32)(
    input logic eq,ne,lt,ge,ltu,gteu ,
    input logic [2:0] fun3 ,
    output logic take_branch
);

always_comb begin
    take_branch = 1'b0;
    case(fun3)
        EQ   : take_branch = ((eq)   ? 1'b1 : 1'b0) ;
        NE   : take_branch = ((ne)   ? 1'b1 : 1'b0) ;
        LT   : take_branch = ((lt)   ? 1'b1 : 1'b0) ;
        GE   : take_branch = ((ge)   ? 1'b1 : 1'b0) ;
        LTU  : take_branch = ((ltu)  ? 1'b1 : 1'b0) ;
        GTEU : take_branch = ((gteu) ? 1'b1 : 1'b0) ;
        default : take_branch = 1'b0; 
    endcase
end

endmodule