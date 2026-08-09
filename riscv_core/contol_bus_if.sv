interface control_bus_if (
    input clk ,
    input _reset 
);

    modport control_pins (
        input logic [WIDTH-1:0] id_inst,

        output logic [4:0] id_rs1_add,
        output logic [4:0] id_rs2_add,
        output logic [4:0] id_rd_add,
        output logic id_jump_en,
        output logic id_jal_en,
        output logic id_b_inst_en,
        output logic id_imm_en,
        output logic id_load_en,
        output logic id_store_en,
        output logic [2:0] id_fun3,
        output logic  id_fun7_5,
        output logic id_auipc_en
    );


    modport data_pins (
        output logic [WIDTH-1:0] id_inst,

        input logic [4:0] id_rs1_add,
        input logic [4:0] id_rs2_add,
        input logic [4:0] id_rd_add,
        input logic id_jump_en,
        input logic id_jal_en,
        input logic id_b_inst_en,
        input logic id_imm_en,
        input logic id_load_en,
        input logic id_store_en,
        input logic [2:0] id_fun3,
        input logic  id_fun7_5,
        input logic id_auipc_en
    );
    





endinterface