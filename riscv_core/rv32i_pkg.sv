package rv32i_pkg;

    localparam  NOP = 32'h000000013;
    localparam  WIDTH = 32;

    typedef enum logic [6:0] {
        OP_U_LUI    = 7'b0110111,
        OP_U_AUIPC  = 7'b0010111,
        OP_J_JAL    = 7'b1101111,
        OP_I_JALR   = 7'b1100111,
        OP_I_LOAD   = 7'b0000011,
        OP_I_ARITH_SHIFT  = 7'b0010011,
        OP_B_BRANCH = 7'b1100011,
        OP_S_STORE  = 7'b0100011,
        OP_R_ARITH  = 7'b0110011,
        OP_FENCE    = 7'b0001111,
        OP_SYS_CALL = 7'b1110011
    } OPCODES ;

    typedef enum logic[2:0] { 
        F3_JALR = 3'b000
    } fun3_i_jalr;

    typedef enum logic[2:0] { 
        F3_LB = 3'b000,
        F3_LH = 3'b001,
        F3_LW = 3'b010,
        F3_LBU = 3'b100,
        F3_LHU = 3'b101
    } i_load_fun3;

    typedef enum logic[2:0] { 
        F3_ADDI = 3'b000,
        F3_SLTI = 3'b010,
        F3_SLTIU = 3'b011,
        F3_XORI = 3'b100,
        F3_ORI = 3'b110,
        F3_ANDI = 3'b111
    } i_arith_fun3;

    typedef enum logic[2:0] { 
        F3_SLI = 3'b001,
        F3_SRI = 3'b101
    } i_shift_fun3;

    typedef enum logic[2:0] { 
        F3_BEQ = 3'b000,
        F3_BNE = 3'b001,
        F3_BLT = 3'b100,
        F3_BGE = 3'b101,
        F3_BLTU = 3'b110,
        F3_BGEU = 3'b111
    } b_branch_fun3;

    typedef enum logic[2:0] {
        F3_SB = 3'b000 ,
        F3_SH = 3'b001 ,
        F3_SW = 3'b010 
    } s_store_fun3;
   


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
    } ALU_FUN3_FUN7_5 ;


    typedef struct packed {
        logic [WIDTH-1:0] pc ;
        logic [WIDTH-1:0] pc_pre_fetch ;
    }if_t;

    typedef struct packed {
        logic [WIDTH-1:0] inst;
        logic [WIDTH-1:0] pc;
    }if_id_t;

    typedef struct packed {
        logic [WIDTH-1:0] src_a;
        logic [WIDTH-1:0] src_b;
        logic [WIDTH-1:0] address_data;
        logic [4:0] rd_add;
        logic [4:0] rs1_add;
        logic [4:0] rs2_add;
        logic [3:0] byte_mask;
        logic [2:0] fun3;
        logic       fun7_5;
        logic       branch_taken;
        logic       load_en;
        logic       store_en;
    }id_ex_t;

    typedef struct packed {
        logic [WIDTH-1:0] ex_data;
        logic [4:0] rd_add;
        logic [2:0] fun3;
        logic       load_en;
    }ex_mem_t;

    typedef struct packed {
        logic [WIDTH-1:0] mem_data;
        logic [4:0] rd_add;
    }mem_wb_t;






endpackage  : rv32i_pkg