library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use work.globals.all;

entity CU_HDW is
  generic (
    MICROCODE_MEM_SIZE :     integer := 10;  -- Microcode Memory Size
    FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
    IR_SIZE            :     integer := 32;  -- Instruction Register Size    
    CW_SIZE            :     integer := 21);  -- Control Word Size
	 
  port (
    Clk                : in  std_logic;  -- Clock
    Rst                : in  std_logic;  -- Reset:Active-Low
    -- Instruction Register
    IR_IN              : in  std_logic_vector(IR_SIZE - 1 downto 0);
    flush : in std_logic; --
    
    -- IF Control Signal
    IR_LATCH_EN        : out std_logic;  -- Instruction Register Latch Enable
    NPC1_LATCH_EN       : out std_logic;
                                        -- NextProgramCounter Register Latch Enable
    -- ID Control Signals
    NPC2_LATCH_EN       : out std_logic; --da aggiungere, fatto
    RegA_LATCH_EN      : out std_logic;  -- Register A Latch Enable
    RegB_LATCH_EN      : out std_logic;  -- Register B Latch Enable
    RegAluOpCodeGen_EN : out std_logic;  -- Register to evaluate the correct Opcode
    RegIMM_LATCH_EN    : out std_logic;  -- Immediate Register Latch Enable
    Reg_RD1_EN         : out std_logic;
    RD1, RD2           : out std_logic;	--read signals of the two read port

    -- EX Control Signals
    B2_LATCH_EN       : out std_logic; -- da aggiungere, fatto
    MUXA_SEL           : out std_logic;  -- MUX-A Sel
    MUXB_SEL           : out std_logic;  -- MUX-B Sel
    ALU_OUTREG_EN      : out std_logic;  -- ALU Output Register Enable
    RETURN_REG_EN      : out std_logic;
    Reg_RD2_EN 	       : out std_logic; -- da aggiungere, fatto
    
    -- MEM Control Signals
    DRAM_WE            : out std_logic;  -- Data RAM Write Enable
    ALU_OUT2_SEL       : out std_logic;
    LMD_LATCH_EN       : out std_logic;  -- LMD Register Latch Enable
    Alu_outreg2_en     : out std_logic; 
    JUMP_en            : out std_logic;  -- JUMP Enable Signal for PC input MUX
    PC_LATCH_EN        : out std_logic;  -- Program Counte Latch Enable
    Reg_RD3_EN 	       : out std_logic; -- da aggiungere
    write_stop_if_branch : out std_logic;

    -- WB Control signals
    WB_MUX_SEL         : out std_logic;  -- Write Back MUX Sel
    RF_WE              : out std_logic; -- Register File Write Enable
    WB_MUX_ADD_SEL     : out std_logic;
    WR: Out std_logic); -- selettore mux alu e return registers da aggiungere

end CU_HDW;

architecture beh of CU_HDW is
                                
  signal IR_opcode : std_logic_vector(OP_code_SIZE -1 downto 0):=(others=>'0');  -- OpCode part of IR
  signal IR_func : std_logic_vector(func_size-1 downto 0):=(others=>'0');   -- Func part of IR when Rtype
  signal cw   : std_logic_vector(CW_SIZE - 1 downto 0); -- full control word read from cw_mem
  
  signal cw1 : std_logic_vector(CW_SIZE -1 downto 0); -- first stage of pipe
  signal cw2 : std_logic_vector(CW_SIZE -1 -1 downto 0); -- second stage of pipe
  signal cw3 : std_logic_vector(CW_SIZE - 1 - 5 downto 0); -- third stage
  signal cw4 : std_logic_vector(CW_SIZE - 1 - 10 downto 0); -- fourth stage
  signal cw5 : std_logic_vector(CW_SIZE -1 - 17 downto 0); -- fifth stage --modifica


begin

--DECODER OF THE WORLD SIGNAL

CW <=   "111010011000011100101" when (IR_opcode = RTYPE and IR_func = R_ADD) else  --en A, en B, select reg A and B
	"111010011000011100101" when (IR_opcode = RTYPE and IR_func = R_SUB) else --en A, en B, select reg A and B
	"111010011000011100101" when (IR_opcode = RTYPE and IR_func = R_AND) else --en A, en B, select reg A and B
	"111010011000011100101" when (IR_opcode = RTYPE and IR_func = R_OR ) else --en A, en B, select reg A and B
	"111010011000011100101" when (IR_opcode = RTYPE and IR_func = R_XOR) else --en A, en B, select reg A and B
	"111010011000011100101" when (IR_opcode = RTYPE and IR_func = R_SGE) else --en A, en B, select reg A and B
	"111010011000011100101" when (IR_opcode = RTYPE and IR_func = R_SLL) else --en A, en B, select reg A and B
	"111010011000011100101" when (IR_opcode = RTYPE and IR_func = R_SRL) else --en A, en B, select reg A and B
	"111010011000011100101" when (IR_opcode = RTYPE and IR_func = R_SNE) else --en A, en B, select reg A and B
	"100101110100011010000" when IR_opcode = J		           else --en IMM, sel PC and IMM
	"100101110101011010111" when IR_opcode = J_JAL                       else --en IMM, sel PC and IMM
	"110100000000001010000" when IR_opcode = J_BEQZ                      else --en IMM, sel PC and IMM
	"110100000000001010000" when IR_opcode = J_BNEZ                      else --en IMM, sel PC and IMM
	"100000000000001000000" when IR_opcode = NOP                         else
	"110110111000011100101" when IR_opcode = I_ADDI                      else --en A and IMM, select reg A and IMM
	"110110111000011100101" when IR_opcode = I_SUBI                      else --en A and IMM, select reg A and IMM
	"110110111000011100101" when IR_opcode = I_ANDI                      else --en A and IMM, select reg A and IMM
	"110110111000011100101" when IR_opcode = I_ORI                       else --en A and IMM, select reg A and IMM
	"110110111000011100101" when IR_opcode = I_XOR                       else --en A and IMM, select reg A and IMM
	"110110111000011100101" when IR_opcode = I_SLLI                      else --en A and IMM, select reg A and IMM
	"110110111000011100101" when IR_opcode = I_SRLI                      else --en A and IMM, select reg A and IMM
	"110110111000011100101" when IR_opcode = I_SNEI                      else --en A and IMM, select reg A and IMM
	"110110111000011100101" when IR_opcode = I_SGEI                      else --en A and IMM, select reg A and IMM
	"110110111010111101101" when IR_opcode = I_LW                      else --en A and IMM, select reg A and IMM
   "000000000000000000000";


  IR_opcode <= IR_IN(opcode_up downto opcode_down);
 IR_func  <= IR_IN(func_size-1 downto 0);

--  -- stage one control signals
 IR_LATCH_EN  <= cw1(CW_SIZE - 1); --enable 1 stage of pipe
 NPC1_LATCH_EN <= cw1(CW_SIZE - 1);
--  
--  -- stage two control signals
 NPC2_LATCH_EN   <= cw2(CW_SIZE -5) OR cw2(CW_SIZE-4); 
 RegA_LATCH_EN   <= cw2(CW_SIZE - 2);
 RegB_LATCH_EN   <= cw2(CW_SIZE - 3);
 RegIMM_LATCH_EN <= cw2(CW_SIZE - 4);
 RegAluOpCodeGen_EN <= cw2(CW_SIZE-5) or cw2(CW_SIZE-4);
 Reg_RD1_EN <= cw2(CW_SIZE-5);
 RD1<= cw2(CW_SIZE -2);
 RD2<= cw2(CW_SIZE -3);
--  
--  -- stage three control signals
  B2_LATCH_EN <= cw3(CW_SIZE - 8);
  MUXA_SEL      <= cw3(CW_SIZE - 6);
  MUXB_SEL      <= cw3(CW_SIZE - 7);
  ALU_OUTREG_EN <= cw3(CW_SIZE - 8);
  RETURN_REG_EN <= cw3 (CW_SIZE-8);
  Reg_RD2_EN <=cw3(CW_SIZE -9);
  JUMP_EN   <= cw3(CW_SIZE - 10); --questo deve andare allo stage 3
  
  
  
--  -- stage four control signals
       
  DRAM_WE      <= cw4(CW_SIZE - 11);
  ALU_OUT2_SEL <= cw4(CW_SIZE -12);
 LMD_LATCH_EN <= cw4(CW_SIZE - 13);
 Alu_outreg2_en <= cw4(CW_SIZE-14);
 PC_LATCH_EN  <= cw4(CW_SIZE - 15);
 Reg_RD3_EN <= cw4(CW_SIZE-16);
 write_stop_if_branch<=cw4(CW_SIZE-17); --4
 
--  -- stage five control signals
 WB_MUX_SEL <= cw5(CW_SIZE - 18); --18
 RF_WE      <= cw5(CW_SIZE - 19); --19
 wb_mux_add_sel <= cw5(CW_SIZE-20); --20
 wr<= cw5(CW_SIZE-21); --21
 

  -- process to pipeline control words
  CW_PIPE: process (Clk, Rst)
  begin
    if Rst = '0' then 
      --cw1(CW_SIZE -1)<='1';
      --cw1(CW_SIZE -2 downto 0) <= (others => '0');
      cw1 <= (others => '0');
      cw2 <= (others => '0');
      cw3 <= (others => '0');
      cw4 <= (others => '0');
      cw5 <= (others => '0');

    elsif Clk'event and Clk = '0' then  -- rising clock edge
      cw1 <= cw;
      cw2 <= cw1(CW_SIZE - 1 - 1 downto 0);
      cw3 <= cw2(CW_SIZE - 1 - 5 downto 0);
      cw4 <= cw3(CW_SIZE - 1 - 10 downto 0);
      cw5 <= cw4(CW_SIZE -1 - 17 downto 0); --
      
     elsif Clk'event and clk='1' and flush='1' then
      cw1 <= (others => '0');
      cw2 <= (others => '0');
      --cw3 <=(others => '0');

    end if;
  end process CW_PIPE;

	

end beh;
