interface core_if;

    // Parameters / widths
    parameter int WIDTH = 32;

    // Global control signals
    logic clk;   // in D
    logic reset; // in D

  
    logic [WIDTH-1:0] id_inst;    // in C,D
    logic id_jump_en;             // in C,D
    logic id_imm_en;              // in C,D
    logic id_jal_en;              // in C,D
    logic id_load_en;             // in C,D
    logic id_store_en;            // in C,D
    logic id_auipc_en;            // in C,D
    logic id_b_inst_en;           // in C,D,H
    logic [4:0] id_rs1_add;       // in C,D,H
    logic [4:0] id_rs2_add;       // in C,D,H
    logic [4:0] id_rd_add;        // in C,D
    logic [2:0] id_fun3;          // in C,D
    logic id_fun7_5;              // in C,D


    logic [4:0] ex_rs1_add;       // in H,D
    logic [4:0] ex_rs2_add;       // in H,D
    logic [4:0] ex_rd_add;        // in H,D
    logic [4:0] mem_rd_add;       // in H,D
    logic [4:0] wb_rd_add;        // in H,D
    logic mem_load_en;            // in H,D,F
    logic ex_branch_taken;        // in H,D
    
    logic stall_if;               // in H,D
    logic stall_id;               // in H,D
    logic stall_ex;               // in H,D
    logic nop_id;                 // in H,D
    logic nop_ex;                 // in H,D

    logic [3:0] ex_alu_flag;      // in D

    // Forward unit <--> Data path
    logic [1:0] id_rs1_mux_sel;   // in F,D
    logic [1:0] id_rs2_mux_sel;   // in F,D
    logic [2:0] ex_alu_a_mux_sel; // in F,D
    logic [2:0] ex_alu_b_mux_sel; // in F,D

    // Hazard unit <--> Forwarding unit
    logic [2:0] id_rs1_dependency; // in H,F
    logic [2:0] id_rs2_dependency; // in H,F
    logic [1:0] ex_rs1_dependency; // in H,F
    logic [1:0] ex_rs2_dependency; // in H,F


    modport control_pins (
        // data_path --> control_unit
        input  id_inst,

        // control_unit --> data_path
        output id_jump_en,
        output id_b_inst_en,
        output id_imm_en,
        output id_jal_en,
        output id_load_en,
        output id_store_en,
        output id_auipc_en,
        output id_rs1_add,
        output id_rs2_add,
        output id_rd_add,
        output id_fun3,
        output id_fun7_5
    );

    modport data_pins (
        input clk,
        input reset,

        // from hazard unit
        input stall_if,
        input stall_id,
        input stall_ex,
        input nop_id,
        input nop_ex,

        // from control unit
        input id_jump_en,
        input id_b_inst_en,
        input id_imm_en,
        input id_jal_en,
        input id_load_en,
        input id_store_en,
        input id_auipc_en,
        input id_rs1_add,
        input id_rs2_add,
        input id_rd_add,
        input id_fun3,
        input id_fun7_5,

        // from forwarding unit
        input id_rs1_mux_sel,
        input id_rs2_mux_sel,
        input ex_alu_a_mux_sel,
        input ex_alu_b_mux_sel,

        // data_path --> control_unit
        output id_inst,

        // data_path --> hazard unit
        output ex_rs1_add,
        output ex_rs2_add,
        output ex_rd_add,
        output mem_rd_add,
        output wb_rd_add,
        output mem_load_en,
        output ex_branch_taken,

        // optional / debug
        output ex_alu_flag
    );

    modport forward_pins (
        // hazard unit --> forwarding unit
        input id_rs1_dependency,
        input id_rs2_dependency,
        input ex_rs1_dependency,
        input ex_rs2_dependency,

        // forwarding unit <--> data_path
        input  mem_load_en,
        output id_rs1_mux_sel,
        output id_rs2_mux_sel,
        output ex_alu_a_mux_sel,
        output ex_alu_b_mux_sel
    );

    modport hazard_pins (
        // hazard_unit <-- control_unit
        input id_rs1_add,
        input id_rs2_add,
        input id_b_inst_en,

        // hazard_unit <-- data_path
        input ex_rs1_add,
        input ex_rs2_add,
        input ex_rd_add,
        input mem_rd_add,
        input wb_rd_add,
        input ex_branch_taken,
        input mem_load_en,

        // hazard_unit --> data_path / forwarding unit
        output stall_if,
        output stall_id,
        output stall_ex,
        output nop_id,
        output nop_ex,
        output id_rs1_dependency,
        output id_rs2_dependency,
        output ex_rs1_dependency,
        output ex_rs2_dependency
    );

endinterface // core_if
