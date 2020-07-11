library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity AluOpCodeGen is
port (IR_opcode: in std_logic_vector(5 downto 0);
      IR_func: in std_logic_vector(10 downto 0);
      AluOpCode: out std_logic_vector(2 downto 0);
      Add_Subn: out std_logic;
      CompareCode: out std_logic_vector(3 downto 0);
      ShiftOpCode: out std_logic_vector(2 downto 0));
end AluOpCodeGen;

architecture beh of AluOpCodeGen is

begin
AluOpCode <=    "000" when (IR_opcode = RTYPE and IR_func = R_ADD) else  --en A, en B, select reg A and B
		"000" when (IR_opcode = RTYPE and IR_func = R_SUB) else --en A, en B, select reg A and B
		"001" when (IR_opcode = RTYPE and IR_func = R_AND) else --en A, en B, select reg A and B
		"010" when (IR_opcode = RTYPE and IR_func = R_OR ) else --en A, en B, select reg A and B
		"011" when (IR_opcode = RTYPE and IR_func = R_XOR) else --en A, en B, select reg A and B
		"100" when (IR_opcode = RTYPE and IR_func = R_SGE) else --en A, en B, select reg A and B
		"101" when (IR_opcode = RTYPE and IR_func = R_SLL) else --en A, en B, select reg A and B
		"101" when (IR_opcode = RTYPE and IR_func = R_SRL) else --en A, en B, select reg A and B
		"100" when (IR_opcode = RTYPE and IR_func = R_SNE) else --en A, en B, select reg A and B
		"000" when IR_opcode = J		           else --en IMM, sel PC and IMM
		"000" when IR_opcode = J_JAL                       else --en IMM, sel PC and IMM
		"000" when IR_opcode = J_BEQZ                      else --en IMM, sel PC and IMM
		"000" when IR_opcode = J_BNEZ                      else --en IMM, sel PC and IMM
		"000" when IR_opcode = NOP                         else
		"000" when IR_opcode = I_ADDI                      else --en A and IMM, select reg A and IMM
		"000" when IR_opcode = I_SUBI                      else --en A and IMM, select reg A and IMM
		"001" when IR_opcode = I_ANDI                      else --en A and IMM, select reg A and IMM
		"010" when IR_opcode = I_ORI                       else --en A and IMM, select reg A and IMM
		"011" when IR_opcode = I_XOR                       else --en A and IMM, select reg A and IMM
		"101" when IR_opcode = I_SLLI                      else --en A and IMM, select reg A and IMM
		"101" when IR_opcode = I_SRLI                      else --en A and IMM, select reg A and IMM
		"100" when IR_opcode = I_SNEI                      else --en A and IMM, select reg A and IMM
		"100" when IR_opcode = I_SGEI                      else --en A and IMM, select reg A and IMM
		"000" when IR_opcode = I_LW                      else --en A and IMM, select reg A and IMM
	        "000";


Add_Subn <=     '0' when (IR_opcode = RTYPE and IR_func = R_ADD) else  --en A, en B, select reg A and B
		'1' when (IR_opcode = RTYPE and IR_func = R_SUB) else --en A, en B, select reg A and B
		'0' when (IR_opcode = RTYPE and IR_func = R_AND) else --en A, en B, select reg A and B
		'0' when (IR_opcode = RTYPE and IR_func = R_OR ) else --en A, en B, select reg A and B
		'0' when (IR_opcode = RTYPE and IR_func = R_XOR) else --en A, en B, select reg A and B
		'0' when (IR_opcode = RTYPE and IR_func = R_SGE) else --en A, en B, select reg A and B
		'0' when (IR_opcode = RTYPE and IR_func = R_SLL) else --en A, en B, select reg A and B
		'0' when (IR_opcode = RTYPE and IR_func = R_SRL) else --en A, en B, select reg A and B
		'0' when (IR_opcode = RTYPE and IR_func = R_SNE) else --en A, en B, select reg A and B
		'0' when IR_opcode = J		           else --en IMM, sel PC and IMM
		'0' when IR_opcode = J_JAL                       else --en IMM, sel PC and IMM
		'0' when IR_opcode = J_BEQZ                      else --en IMM, sel PC and IMM
		'0' when IR_opcode = J_BNEZ                      else --en IMM, sel PC and IMM
		'0' when IR_opcode = NOP                         else
		'0' when IR_opcode = I_ADDI                      else --en A and IMM, select reg A and IMM
		'1' when IR_opcode = I_SUBI                      else --en A and IMM, select reg A and IMM
		'0' when IR_opcode = I_ANDI                      else --en A and IMM, select reg A and IMM
		'0' when IR_opcode = I_ORI                       else --en A and IMM, select reg A and IMM
		'0' when IR_opcode = I_XOR                       else --en A and IMM, select reg A and IMM
		'0' when IR_opcode = I_SLLI                      else --en A and IMM, select reg A and IMM
		'0' when IR_opcode = I_SRLI                      else --en A and IMM, select reg A and IMM
		'0' when IR_opcode = I_SNEI                      else --en A and IMM, select reg A and IMM
		'0' when IR_opcode = I_SGEI                      else --en A and IMM, select reg A and IMM
		'0' when IR_opcode = I_LW                      else --en A and IMM, select reg A and IMM
	        '0';
CompareCode <=    "0000" when (IR_opcode = RTYPE and IR_func = R_ADD) else  --en A, en B, select reg A and B
		"0000" when (IR_opcode = RTYPE and IR_func = R_SUB) else --en A, en B, select reg A and B
		"0000" when (IR_opcode = RTYPE and IR_func = R_AND) else --en A, en B, select reg A and B
		"0000" when (IR_opcode = RTYPE and IR_func = R_OR ) else --en A, en B, select reg A and B
		"0000" when (IR_opcode = RTYPE and IR_func = R_XOR) else --en A, en B, select reg A and B
		"0010" when (IR_opcode = RTYPE and IR_func = R_SGE) else --en A, en B, select reg A and B
		"0000" when (IR_opcode = RTYPE and IR_func = R_SLL) else --en A, en B, select reg A and B
		"0000" when (IR_opcode = RTYPE and IR_func = R_SRL) else --en A, en B, select reg A and B
		"0001" when (IR_opcode = RTYPE and IR_func = R_SNE) else --en A, en B, select reg A and B
		"0000" when IR_opcode = J		           else --en IMM, sel PC and IMM
		"0000" when IR_opcode = J_JAL                       else --en IMM, sel PC and IMM
		"1000" when IR_opcode = J_BEQZ                      else --en IMM, sel PC and IMM
		"0100" when IR_opcode = J_BNEZ                      else --en IMM, sel PC and IMM
		"0000" when IR_opcode = NOP                         else
		"0000" when IR_opcode = I_ADDI                      else --en A and IMM, select reg A and IMM
		"0000" when IR_opcode = I_SUBI                      else --en A and IMM, select reg A and IMM
		"0000" when IR_opcode = I_ANDI                      else --en A and IMM, select reg A and IMM
		"0000" when IR_opcode = I_ORI                       else --en A and IMM, select reg A and IMM
		"0000" when IR_opcode = I_XOR                       else --en A and IMM, select reg A and IMM
		"0000" when IR_opcode = I_SLLI                      else --en A and IMM, select reg A and IMM
		"0000" when IR_opcode = I_SRLI                      else --en A and IMM, select reg A and IMM
		"0001" when IR_opcode = I_SNEI                      else --en A and IMM, select reg A and IMM
		"0010" when IR_opcode = I_SGEI                      else --en A and IMM, select reg A and IMM
		"0000" when IR_opcode = I_LW                      else --en A and IMM, select reg A and IMM
		"0000";

ShiftOpCode <=  "000" when (IR_opcode = RTYPE and IR_func = R_ADD) else  --en A, en B, select reg A and B
		"000" when (IR_opcode = RTYPE and IR_func = R_SUB) else --en A, en B, select reg A and B
		"000" when (IR_opcode = RTYPE and IR_func = R_AND) else --en A, en B, select reg A and B
		"000" when (IR_opcode = RTYPE and IR_func = R_OR ) else --en A, en B, select reg A and B
		"000" when (IR_opcode = RTYPE and IR_func = R_XOR) else --en A, en B, select reg A and B
		"000" when (IR_opcode = RTYPE and IR_func = R_SGE) else --en A, en B, select reg A and B
		"111" when (IR_opcode = RTYPE and IR_func = R_SLL) else --en A, en B, select reg A and B
		"101" when (IR_opcode = RTYPE and IR_func = R_SRL) else --en A, en B, select reg A and B
		"000" when (IR_opcode = RTYPE and IR_func = R_SNE) else --en A, en B, select reg A and B
		"000" when IR_opcode = J		           else --en IMM, sel PC and IMM
		"000" when IR_opcode = J_JAL                       else --en IMM, sel PC and IMM
		"000" when IR_opcode = J_BEQZ                      else --en IMM, sel PC and IMM
		"000" when IR_opcode = J_BNEZ                      else --en IMM, sel PC and IMM
		"000" when IR_opcode = NOP                         else
		"000" when IR_opcode = I_ADDI                      else --en A and IMM, select reg A and IMM
		"000" when IR_opcode = I_SUBI                      else --en A and IMM, select reg A and IMM
		"000" when IR_opcode = I_ANDI                      else --en A and IMM, select reg A and IMM
		"000" when IR_opcode = I_ORI                       else --en A and IMM, select reg A and IMM
		"000" when IR_opcode = I_XOR                       else --en A and IMM, select reg A and IMM
		"111" when IR_opcode = I_SLLI                      else --en A and IMM, select reg A and IMM
		"101" when IR_opcode = I_SRLI                      else --en A and IMM, select reg A and IMM
		"000" when IR_opcode = I_SNEI                      else --en A and IMM, select reg A and IMM
		"000" when IR_opcode = I_SGEI                      else --en A and IMM, select reg A and IMM
		"000" when IR_opcode = I_LW                      else --en A and IMM, select reg A and IMM
	        "000";

end beh;
