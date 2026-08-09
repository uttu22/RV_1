# RV32I Base Instruction Set - Complete Reference

## U-Type Instructions (Load Upper Immediate)
| Instruction | Description | imm[31:12] | rd | Opcode |
|---|---|---|---|---|
| LUI | Load Upper Immediate | imm[31:12] | rd | 0110111 |
| AUIPC | Add Upper Immediate to PC | imm[31:12] | rd | 0010111 |

## J-Type Instructions (Jump)
| Instruction | Description | imm[20\|10:1\|11\|19:12] | rd | Opcode |
|---|---|---|---|---|
| JAL | Jump and Link | imm[20\|10:1\|11\|19:12] | rd | 1101111 |

## I-Type Instructions (Immediate)
| Instruction | Description | imm[11:0] | rs1 | funct3 | rd | Opcode |
|---|---|---|---|---|---|---|
| JALR | Jump and Link Register | imm[11:0] | rs1 | 000 | rd | 1100111 |
| LB | Load Byte | imm[11:0] | rs1 | 000 | rd | 0000011 |
| LH | Load Halfword | imm[11:0] | rs1 | 001 | rd | 0000011 |
| LW | Load Word | imm[11:0] | rs1 | 010 | rd | 0000011 |
| LBU | Load Byte Unsigned | imm[11:0] | rs1 | 100 | rd | 0000011 |
| LHU | Load Halfword Unsigned | imm[11:0] | rs1 | 101 | rd | 0000011 |
| ADDI | Add Immediate | imm[11:0] | rs1 | 000 | rd | 0010011 |
| SLTI | Set Less Than Immediate | imm[11:0] | rs1 | 010 | rd | 0010011 |
| SLTIU | Set Less Than Immediate Unsigned | imm[11:0] | rs1 | 011 | rd | 0010011 |
| XORI | XOR Immediate | imm[11:0] | rs1 | 100 | rd | 0010011 |
| ORI | OR Immediate | imm[11:0] | rs1 | 110 | rd | 0010011 |
| ANDI | AND Immediate | imm[11:0] | rs1 | 111 | rd | 0010011 |

## I-Type Shift Instructions
| Instruction | Description | funct7 | shamt | rs1 | funct3 | rd | Opcode |
|---|---|---|---|---|---|---|---|
| SLLI | Shift Left Logical Immediate | 0000000 | shamt | rs1 | 001 | rd | 0010011 |
| SRLI | Shift Right Logical Immediate | 0000000 | shamt | rs1 | 101 | rd | 0010011 |
| SRAI | Shift Right Arithmetic Immediate | 0100000 | shamt | rs1 | 101 | rd | 0010011 |

## B-Type Instructions (Branch)
| Instruction | Description | imm[12\|10:5] | rs2 | rs1 | funct3 | imm[4:1\|11] | Opcode |
|---|---|---|---|---|---|---|---|
| BEQ | Branch if Equal | imm[12\|10:5] | rs2 | rs1 | 000 | imm[4:1\|11] | 1100011 |
| BNE | Branch if Not Equal | imm[12\|10:5] | rs2 | rs1 | 001 | imm[4:1\|11] | 1100011 |
| BLT | Branch if Less Than | imm[12\|10:5] | rs2 | rs1 | 100 | imm[4:1\|11] | 1100011 |
| BGE | Branch if Greater or Equal | imm[12\|10:5] | rs2 | rs1 | 101 | imm[4:1\|11] | 1100011 |
| BLTU | Branch if Less Than Unsigned | imm[12\|10:5] | rs2 | rs1 | 110 | imm[4:1\|11] | 1100011 |
| BGEU | Branch if Greater or Equal Unsigned | imm[12\|10:5] | rs2 | rs1 | 111 | imm[4:1\|11] | 1100011 |

## S-Type Instructions (Store)
| Instruction | Description | imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | Opcode |
|---|---|---|---|---|---|---|---|
| SB | Store Byte | imm[11:5] | rs2 | rs1 | 000 | imm[4:0] | 0100011 |
| SH | Store Halfword | imm[11:5] | rs2 | rs1 | 001 | imm[4:0] | 0100011 |
| SW | Store Word | imm[11:5] | rs2 | rs1 | 010 | imm[4:0] | 0100011 |

## R-Type Instructions (Register)
| Instruction | Description | funct7 | rs2 | rs1 | funct3 | rd | Opcode |
|---|---|---|---|---|---|---|---|
| ADD | Add | 0000000 | rs2 | rs1 | 000 | rd | 0110011 |
| SUB | Subtract | 0100000 | rs2 | rs1 | 000 | rd | 0110011 |
| SLL | Shift Left Logical | 0000000 | rs2 | rs1 | 001 | rd | 0110011 |
| SLT | Set Less Than | 0000000 | rs2 | rs1 | 010 | rd | 0110011 |
| SLTU | Set Less Than Unsigned | 0000000 | rs2 | rs1 | 011 | rd | 0110011 |
| XOR | XOR | 0000000 | rs2 | rs1 | 100 | rd | 0110011 |
| SRL | Shift Right Logical | 0000000 | rs2 | rs1 | 101 | rd | 0110011 |
| SRA | Shift Right Arithmetic | 0100000 | rs2 | rs1 | 101 | rd | 0110011 |
| OR | OR | 0000000 | rs2 | rs1 | 110 | rd | 0110011 |
| AND | AND | 0000000 | rs2 | rs1 | 111 | rd | 0110011 |

## System Instructions
| Instruction | Description | imm[11:0] | rs1 | funct3 | rd | Opcode |
|---|---|---|---|---|---|---|
| ECALL | Environment Call | 0 | 0 | 000 | 0 | 1110011 |
| EBREAK | Environment Breakpoint | 1 | 0 | 000 | 0 | 1110011 |

## Fence Instructions
| Instruction | Description | fm | pred | succ | rs1 | funct3 | rd | Opcode |
|---|---|---|---|---|---|---|---|---|
| FENCE | Synchronize Threads | fm | pred | succ | 0 | 000 | 0 | 0001111 |
| FENCE.TSO | Total Store Order | 1000 | 1111 | 1111 | 0 | 000 | 0 | 0001111 |

## Zicsr Extension Instructions (Control and Status Register)
| Instruction | Description | csr | rs1/uimm | funct3 | rd | Opcode |
|---|---|---|---|---|---|---|
| CSRRW | CSR Read and Write | csr[11:0] | rs1 | 001 | rd | 1110011 |
| CSRRS | CSR Read and Set Bits | csr[11:0] | rs1 | 010 | rd | 1110011 |
| CSRRC | CSR Read and Clear Bits | csr[11:0] | rs1 | 011 | rd | 1110011 |
| CSRRWI | CSR Read and Write Immediate | csr[11:0] | uimm | 101 | rd | 1110011 |
| CSRRSI | CSR Read and Set Bits Immediate | csr[11:0] | uimm | 110 | rd | 1110011 |
| CSRRCI | CSR Read and Clear Bits Immediate | csr[11:0] | uimm | 111 | rd | 1110011 |


### Bit Field Legend
- **imm**: Immediate value (various bit ranges)
- **uimm**: Unsigned immediate value (5 bits)
- **rd**: Destination register
- **rs1**: Source register 1
- **rs2**: Source register 2
- **csr**: Control and Status Register address (12 bits)
- **funct3**: 3-bit function code (differentiates instructions within same opcode)
- **funct7**: 7-bit function code (used in R-type instructions)
- **shamt**: Shift amount (5 bits)
- **fm**: Fence predecessor/successor (used in FENCE)
- **pred/succ**: Predecessor/Successor bits (used in FENCE)
- **Opcode**: 7-bit operation code
