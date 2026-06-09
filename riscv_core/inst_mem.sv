module inst_mem #(
    parameter WORD_WIDTH  = 32 ,
    parameter MEMORY_WIDTH = 10
)(
    input logic   clk ,
    input logic   read_en,
    input logic  [WORD_WIDTH-1:0] inst_add ,
    output logic [WORD_WIDTH -1 : 0] data_out  
 );

logic [WORD_WIDTH-1:0] ROM [0:((1<<(MEMORY_WIDTH-2))-1)];
logic [MEMORY_WIDTH-3:0] word_address ;

assign word_address = inst_add[MEMORY_WIDTH-1:2];

always_ff @(posedge clk ) begin : inst_memory
    if(read_en == 1'b1)data_out <= ROM[word_address];
end

endmodule



