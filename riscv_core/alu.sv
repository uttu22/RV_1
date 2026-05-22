typedef enum logic [2:0] {
      ADD_SUB = 3'b000,
      SLL     = 3'b001,
      SLT     = 3'b010,
      SLTU    = 3'b011,
      XOR     = 3'b100,
      SR      = 3'b101,
      OR      = 3'b110,
      AND     = 3'b111
  } arith_op;

/*
operations --
  add , sub 
  boolean = xor , or , and 
  shift = sll , srl , sra
*/

module alu #(parameter width = 32)
( input  logic [width-1:0] in_a,  
  input  logic [width-1:0] in_b,
  input  arith_op          func3, // Used the enum type here
  input  logic             func7, // Explicitly declared as logic
  output logic [width-1:0] out_z );

  always_comb begin 
      out_z = 'b0 ; 
      case (func3) 
        XOR    : out_z = in_a ^ in_b ;
        // Added $signed() for arithmetic shift. Corrected operand order to match SLL
        SR     : out_z = (func7) ? ($signed(in_a) >>> in_b) : (in_a >> in_b) ;  
        OR     : out_z = in_a | in_b;
        AND    : out_z = in_a & in_b;        
        // Simplified the condition
        ADD_SUB: out_z = (func7) ? (in_a + in_b) : (in_a - in_b) ; 
        SLL    : out_z = in_a << in_b ;
        // Added $signed() cast for signed comparison
        SLT    : out_z = ($signed(in_a) < $signed(in_b));
        // Removed unnecessary $unsigned since signals are already unsigned
        SLTU   : out_z = (in_a < in_b); 
      endcase
  end

endmodule