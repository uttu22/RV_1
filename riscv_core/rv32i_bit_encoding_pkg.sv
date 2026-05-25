package rv32i_pkg;

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
   
    typedef enum logic[2:0] {
        F3_ADD_SUB = 'b000,
        F3_SLL = 'b001,
        F3_SLT = 'b010,
        F3_SLTU = 'b011,
        F3_XOR = 'b100,
        F3_SR = 'b101,
        F3_OR =  'b110,
        F3_AND = 'b111
    } r_arith_fun3;




endpackage 