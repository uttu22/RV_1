
module data_mem #(
    parameter DATA_WIDTH  = 32 ,
    parameter ADDRESS_WIDTH = 10,
)(
    input logic clk ,
    input logic we  ,
    input logic[DATA_WIDTH -1 : 0] data_in  
    input logic [ADDRESS_WIDTH-1:0] inst_add ,
    input logic [DATA_WIDTH - 1 :0] read_data ,
 )

logic [DATA_WIDTH-1:0] RAM [0:(1<<ADDRESS_WIDTH-1)];

always_ff @(posedge clk ) begin : inst_memory
    if(we) RAM[inst_add] <= data_in ;
end



endmodule

