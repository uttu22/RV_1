module comparator (
    input logic C,Z,V,S,
    input logic [2:0] fun3 ,
    output logic EQ,NE,LT,GE,LTU,GTEU
);

assign EQ =   Z ;
assign NE =  ~Z ;
assign LT =  V^S;
assign GE =   Z | ~(V^S);
assign LTU =  ~C;
assign GTEU = C | Z ;


endmodule

