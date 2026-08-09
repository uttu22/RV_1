
module data_mem #(
    parameter   WORD_WIDTH  = 32 ,
    parameter  MEMORY_WIDTH = 10
)(
    input logic clk ,
    input logic we , re, 
    input logic _reset,
    input logic [2:0] fun_3,
    input logic  [WORD_WIDTH    -1 : 0] data_in  ,
    input logic  [WORD_WIDTH-1     : 0] data_address  ,
    output logic [WORD_WIDTH -1    : 0] data_out 
 );

import rv32i_pkg::* ;

logic [ WORD_WIDTH-1:0] RAM [0:((1<< (MEMORY_WIDTH-2))-1)];
logic [ MEMORY_WIDTH-3:0] word_adress = data_address[ (MEMORY_WIDTH-1):2];
logic [WORD_WIDTH-1 :0] data_out_temp;

logic [3:0] byte_mask ;

always_comb begin 
    case(fun_3[1:0])
        2'b00: byte_mask = 4'b0001; 
        2'b01: byte_mask = 4'b0011; 
        2'b10: byte_mask = 4'b1111;
        default : byte_mask = 4'b0000;  
    endcase
end


// store data 
always_ff @(posedge clk ) begin 
    if(we) begin
        if (byte_mask[0]) RAM[word_adress][7:0] <= data_in[7:0];
        if (byte_mask[1]) RAM[word_adress][15:8] <= data_in[15:8];
        if (byte_mask[2]) RAM[word_adress][23:16] <= data_in[23:16];
        if (byte_mask[3]) RAM[word_adress][31:24] <= data_in[31:24];
    end
end

//load data 
always_ff @(posedge clk or negedge _reset) begin 
    data_out_temp = 'b0 ;
    if(!_reset) data_out = { WORD_WIDTH{1'b0}};
    else if(re)begin
        if (byte_mask[0]) data_out_temp[7:0]    <= RAM[word_adress][7:0];
        if (byte_mask[1]) data_out_temp[15:8]   <= RAM[word_adress][15:8];
        if (byte_mask[2]) data_out_temp[23:16]  <= RAM[word_adress][23:16];
        if (byte_mask[3]) data_out_temp[31:24]  <= RAM[word_adress][31:24];
    end
end

always_comb begin
    if(fun_3[2]==1) data_out = data_out_temp;
    else begin
        case(fun_3[1:0])
             2'b00 :  data_out = {{(WIDTH-8){data_out_temp[7]}} , data_out_temp[7:0]};
             2'b01 :  data_out = {{(WIDTH-16){data_out_temp[15]}} , data_out_temp[7:0]};
             2'b10 :  data_out = data_out_temp;
             default data_out = 'b0;
        endcase
    end
end




endmodule

