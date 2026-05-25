
typedef enum logic[3:0] {
    ADD = 4'b0000,
    SUB = 4'b0001,
    SLL = 4'b0010,
    SLT = 4'b0100,
    SLTU = 4'b0110,
    XOR = 4'b1000,   
    SRL = 4'b1010,
    SRA = 4'b1011,
    OR  = 4'b1100,
    AND = 4'b1110
} FUN3 ;



module alu #(parameter WIDTH = 32)( 
  input logic FUN7_5,
  input logic[2:0] FUN3,
  input logic[WIDTH-1:0] A,B ,
  output logic C,Z,V,S,
  output logic[WIDTH-1:0] OUT
);


logic [WIDTH : 0] sub33;
assign sub33 = {1'b0,A} - {1'b0,B} ; 
logic C0 = sub33[WIDTH];
logic S0 = sub33[WIDTH-1];
logic V0 = ((A[WIDTH-1]!=B[WIDTH-1]) && (A[WIDTH-1]!=sub33[WIDTH-1]));



always_comb begin
  OUT = {(WIDTH){1'b0}} ;
  V = 1'b0;
  C = 1'b0;
  case({FUN3,FUN7_5})
    //-------
    ADD:  begin 
      {C,OUT} = {1'b0,A} + {1'b0,B} ; 
      if((A[WIDTH-1]==B[WIDTH-1]) && (A[WIDTH-1]!= OUT[WIDTH-1])) V=1'b1;
      else V=1'b0;
    end
    //------
    SUB :  begin
      {C,OUT} = sub33 ;
      V = V0 ;
    end
    //-----
    SLT :  begin
      OUT = (V0^S0)? 'b1 : 'b0;
    end
    //-----
    SLTU :  begin
      OUT = (C)? 'b0 : 'b1;
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
assign Z = ~|(A[WIDTH-1:0]^B[WIDTH-1:0]);
 
endmodule
