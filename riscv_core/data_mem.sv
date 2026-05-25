
module data_mem #(
    parameter   WORD_WIDTH  = 32 ,
    parameter  MEMORY_WIDTH = 10
)(
    input logic clk ,
    input logic we , re, 
    input logic _reset,
    input logic [3:0] byte_mask,
    input logic  [WORD_WIDTH    -1 : 0] data_in  ,
    input logic  [WORD_WIDTH-1     : 0] data_address  ,
    output logic [WORD_WIDTH -1    : 0] data_out 
 );


logic [ WORD_WIDTH-1:0] RAM [0:((1<< (MEMORY_WIDTH-2))-1)];
logic [ MEMORY_WIDTH-3:0] word_adress = data_address[ (MEMORY_WIDTH-1):2];

always_ff @(posedge clk ) begin : write_data
    if(we) begin
        if (byte_mask[0]) RAM[word_adress][7:0] <= data_in[7:0];
        if (byte_mask[1]) RAM[word_adress][15:8] <= data_in[15:8];
        if (byte_mask[2]) RAM[word_adress][23:16] <= data_in[23:16];
        if (byte_mask[3]) RAM[word_adress][31:24] <= data_in[31:24];
    end
end

always_ff @(posedge clk or negedge _reset) begin : read_data
    if(!_reset) data_out = { WORD_WIDTH{1'b0}};
    else if(re)begin
        data_out = { WORD_WIDTH{1'b0}};
        if (byte_mask[0]) data_out[7:0]    <= RAM[word_adress][7:0];
        if (byte_mask[1]) data_out[15:8]   <= RAM[word_adress][15:8];
        if (byte_mask[2]) data_out[23:16]  <= RAM[word_adress][23:16];
        if (byte_mask[3]) data_out[31:24]  <= RAM[word_adress][31:24];
    end 
end

endmodule

