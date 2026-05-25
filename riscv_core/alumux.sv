module alumux #(parameter WIDTH = 32)(
    input logic[WIDTH-1 :0] aluout,
    input logic alu_mux_sel , LT , LTU ,
    output logic[WIDTH-1 : 0] exout
)

logic [WIDTH-1:0 ] set = 'b1;
logic [WIDTH-1:0 ] unset = 'b0;

always_comb begin : alu_mux_sel_b
    exout = unset ;
    case(alu_mux_sel)
        2'b00 : exout = unset;
        2'b01 : exout = aluout;
        2'b10 : exout = (LT)? set : unset ;
        2'b10 : exout = (LTU)? set : unset ;
    default exout = unset ;
    endcase
end

endmodule