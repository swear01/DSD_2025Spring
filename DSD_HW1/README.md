# DSD HW1 README

## Execution Command

source /usr/cad/synopsys/CIC/vcs.cshrc
source /usr/cad/synopsys/CIC/verdi.cshrc

//Run in 1-ALU

vcs ./1_assign/alu_assign_tb.v ./1_assign/alu_assign.v -full64 -R -debug_access+all +v2k

vcs ./2_always/alu_always_tb.v ./2_always/alu_always.v -full64 -R -debug_access+all +v2k 

//Run in 2-RegisterFile

vcs register_file_tb.v register_file.v -full64 -R -debug_access+all +v2k

//Run in 3-SimpleCalculator

vcs simple_calculator_tb.v simple_calculator.v ../1-ALU/1_assign/alu_assign.v ../2-RegisterFile/register_file.v -full64 -R -debug_access+all +v2k 

vcs simple_calculator_tb.v simple_calculator.v ../1-ALU/1_assign/alu_assign.v ../2-RegisterFile/register_lo.v -full64 -R -debug_access+all +v2k 