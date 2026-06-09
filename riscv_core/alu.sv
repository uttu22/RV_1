




module alu #(parameter WIDTH = 32) (
  input logic FUN7_5,
  input logic[2:0] FUN3,
  input logic[WIDTH-1:0] A,B,
  output logic C,Z,V,S,
  output logic[WIDTH-1:0] OUT
);

import rv32i_pkg::* ;
 

logic[WIDTH :0] sum ;
logic[WIDTH :0] diff  ;

logic Csum , Cdiff , Ssum , Sdiff , Vsum , Vdiff ; 


assign diff = {1'b0,A} - {1'b0,B} ;
assign sum = {1'b0,A} + {1'b0,B} ;

assign Csum = sum[WIDTH];
assign Cdiff = diff[WIDTH];

assign Ssum = sum[WIDTH-1]; 
assign Sdiff = diff[WIDTH-1];

assign Vsum = ((A[WIDTH-1]==B[WIDTH-1]) && (A[WIDTH-1]!= sum[WIDTH-1]))? 1'b1 : 1'b0;
assign Vdiff = (!(A[WIDTH-1]==B[WIDTH-1]) && (A[WIDTH-1]!= diff[WIDTH-1]))? 1'b1 : 1'b0;


always_comb begin
  OUT = {(WIDTH){1'b0}} ;
  V = 1'b0;
  C = 1'b0;
  case({FUN3,FUN7_5})
    //-------
    ADD:  begin 
      {C,OUT} = sum ; 
      V = Vsum;
    end
    //------
    SUB :  begin
      {C,OUT} = diff ; 
      V=Vdiff ;
    end
    //-----
    SLT :  begin
      OUT = (Vdiff^Sdiff)? 'b1 : 'b0;
    end
    //-----
    SLTU :  begin
      OUT = (Cdiff)? 'b0 : 'b1;
    end
    //-----
    AND : begin
      OUT=A&B;
    end
    //-----
    OR  : begin
      OUT=A|B; 
    end
    //-----
    XOR :  begin
      OUT=A^B; 
    end
    //-----
    SLL : begin
      OUT = A<<B[4:0]; 
    end
    //-----
    SRL : begin
      OUT = A>>B[4:0]; 
    end
    //-----
    SRA : begin
      OUT = ($signed(A)>>>B[4:0]); 
    end
    //------
    default: begin
        OUT = {(WIDTH){1'b0}} ;
        V = 1'b0;
        C = 1'b0;
    end
  endcase

end


assign S = OUT[WIDTH-1];
assign Z = ~|(OUT);
 
endmodule
