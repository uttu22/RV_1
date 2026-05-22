module inst_mem #(
    parameter DATA_WIDTH  = 32 ,
    parameter ADDRESS_WIDTH = 10,
)(
    input logic clk ,
    input logic [ADDRESS_WIDTH-1:0] inst_add ,
    input logic [DATA_WIDTH - 1 :0] read_data ,
    output logic[DATA_WIDTH -1 : 0] data_out  
 )

logic [DATA_WIDTH-1:0]ROM [0:(1<<ADDRESS_WIDTH-1)];

always_ff @(posedge clk ) begin : inst_memory
    data_out <= ROM[inst_add];
end

endmodule



