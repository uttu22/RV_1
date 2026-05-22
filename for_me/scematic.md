```mermaid
graph LR
    subgraph IF [Fetch]
        PC-->IMEM[Instruction Memory]
    end
    IMEM -->|Instr| IF_ID_Reg((IF/ID))
    
    subgraph ID [Decode]
        IF_ID_Reg --> RegFile[Register File]
        IF_ID_Reg --> Control[Control Unit]
    end
    RegFile --> ID_EX_Reg((ID/EX))
    Control --> ID_EX_Reg
    
    subgraph EX [Execute]
        ID_EX_Reg --> ALU
    end
    ALU --> EX_MEM_Reg((EX/MEM))
    
    subgraph MEM [Memory]
        EX_MEM_Reg --> DMEM[Data Memory]
    end
    DMEM --> MEM_WB_Reg((MEM/WB))
    
    subgraph WB [Writeback]
        MEM_WB_Reg -->|Result| RegFile
    end
    
    %% Forwarding Paths
    EX_MEM_Reg -.->|Forward A/B| ALU