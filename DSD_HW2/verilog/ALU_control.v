// Single Cycle RISC-V CPU ALU Control Unit  

module ALU_control (
    op,
    funct3,
    funct7,
    alu_ctrl
);
    // region: I/O

    input   [4:3] op_43; //only need 2 bits
    input   [2:0] funct3;
    input   [5:5] funct7_5; //only need 5th bit
    output  [3:0] alu_ctrl;

    // region: spec

    //    ALUCtrl[0] = OP[4] & funct3[2] & funct3[1] & (!funct3[0])
    //    ALUCtrl[1] = !(OP[4] & (!OP[3]) & funct3[1])
    //    ALUCtrl[2] = ((!OP[4]) & (!funct3[1])) | (funct7[5] & OP[4])
    //    ALUCtrl[3] = OP[4] & (!funct3[2]) & funct3[1]

    // Code Functions   Instructions
    // 0000 AND         AND
    // 0001 OR          OR
    // 0010 ADD         SW, LW
    // 0110 SUBSTRACT   SUB, Branch
    // 1000 SLT         SL

    // region: param

    // region: func

    // region: variable

    // region: modules

    // region: assign
    assign alu_ctrl[0] = op_43[4] & funct3[2] & funct3[1] & (!funct3[0]);
    assign alu_ctrl[1] = !(op_43[4] & (!op_43[3]) & funct3[1]);
    assign alu_ctrl[2] = ((!op_43[4]) & (!funct3[1])) | (funct7_5 & op_43[4]);
    assign alu_ctrl[3] = op_43[4] & (!funct3[2]) & funct3[1];

    // region: comb

    // region: sequential

    
endmodule