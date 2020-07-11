library ieee;
use ieee.std_logic_1164.all;
use work.log2_function.all;
use work.globals.all;
use ieee.std_logic_unsigned.all;

entity DLX is
  generic (
    IR_SIZE      : integer := 32;       -- Instruction Register Size
    PC_SIZE      : integer := 32       -- Program Counter Size
    );       
  port (
    Clk : in std_logic;
    Rst : in std_logic; -- active low
    dram_RD  : out  std_logic; -- segnale scrittura dram, da cu
    dram_WR  : out  std_logic; -- segnale lettura dram, da cu
    dram_ADD : out  std_logic_vector(32- 1 downto 0); -- indirizzo dram, da dp
    dram_DIN : out std_logic_vector(numbit - 1 downto 0); -- dato in ingresso a dram, da dp
    dram_DOUT : in std_logic_vector(numbit - 1 downto 0); -- dato in uscita da dram, verso dp
-- segnali memoria iram
    iram_Addr : out  std_logic_vector(PC_SIZE - 1 downto 0); -- segnale in ingresso a iram, sarebbe quello che esce da reg pc mi sembra
    iram_Dout : in std_logic_vector(IR_SIZE - 1 downto 0) -- segnal in uscita da iram
);                
end DLX;


architecture dlx_rtl of DLX is

 --------------------------------------------------------------------
 -- Components Declaration
 --------------------------------------------------------------------
 
 	component mux21 is
	generic (N: integer:=32);
  	port (
    		A   : in std_logic_vector(N-1 downto 0);
    		B   : in std_logic_vector(N-1 downto 0);
    		SEL : in std_logic;
    		Y: out std_logic_vector(N-1 downto 0));
	end component;



	component datapath is 
	generic (reg_size : integer := 32); -- dimensione registri nel datapath
	port (
		-- comandi generali datapath
		clk: in std_logic; -- clock per tutto il datapath
		rst: in std_logic; -- reset attivo basso
		-- pipe stage 1 commands
		flush : in std_logic;
		RF1: in std_logic; -- register file porta 1 lettura
		RF2: in std_logic; -- register file porta 2 lettura
		WF1: in std_logic; -- scrittura rf
		EN_regA: in std_logic; -- abilito registri del primo stage di pipe
		EN_regB: in std_logic; -- abilito registri del primo stage di pipe
		EN_regIMM: in std_logic; -- abilito registri del primo stage di pipe
		EN_regALUOP: in std_logic;
		EN_regRD1: in std_logic;
		EN_regNPC2: in std_logic;
		-- pipe stage 2 commands
		S1: in std_logic; -- comando mux prima porta rf
		S2: in std_logic; -- sel mux seconda porta rf

		EN_regRET: in std_logic; -- abilito registri secondo stage di pipe
		EN_regOUTALU: in std_logic;
		EN_regB2: in std_logic;
		EN_regRD2: in std_logic;
		-- pipe stage 3 commands
		EN_regALU2: in std_logic; -- abilito registri 3o stadio di pipe
		EN_regLMD: in std_logic;
		EN_regRD3: in std_logic;
		Sel_ret_alu: in std_logic; -- mux uscita memoria
		Sel_alu_lmd: in std_logic; -- mux uscita memoria
		sel_31_rd: in std_logic;
		-- input datapath
		NPC: in std_logic_vector (numbit -1 downto 0);
		IR_dp: in std_logic_vector (numbit -1 downto 0);
		-- output datapath
		OUT_DP: out std_logic_vector (numbit -1 downto 0); -- uscita dal datapath
		comp_branch_i: out std_logic;
		immediate_branch : out std_logic_vector(31 downto 0);
		-- segnali dram
		ADD_mem : out  std_logic_vector(32 - 1 downto 0);
	   	DIN_mem : out std_logic_vector(numbit - 1 downto 0);
		DOUT_mem : in std_logic_vector(numbit - 1 downto 0)
		
	);
	end component;
	
	
  
component CU_HDW is
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

    IR_in: in std_logic_vector(31 downto 0);
    flush: in std_logic;
    
    -- IF Control Signal
    IR_LATCH_EN        : out std_logic;  -- Instruction Register Latch Enable
    NPC1_LATCH_EN       : out std_logic;
                                        -- NextProgramCounter Register Latch Enable
    -- ID Control Signals
    NPC2_LATCH_EN       : out std_logic; 
    RegA_LATCH_EN      : out std_logic;  -- Register A Latch Enable
    RegB_LATCH_EN      : out std_logic;  -- Register B Latch Enable
    RegAluOpCodeGen_EN : out std_logic;  -- Register to evaluate the correct Opcode
    RegIMM_LATCH_EN    : out std_logic;  -- Immediate Register Latch Enable
    Reg_RD1_EN         : out std_logic;
    RD1, RD2           : out std_logic;	--read signals of the two read port

    -- EX Control Signals
    B2_LATCH_EN       : out std_logic;
    MUXA_SEL           : out std_logic;  -- MUX-A Sel
    MUXB_SEL           : out std_logic;  -- MUX-B Sel
    ALU_OUTREG_EN      : out std_logic;  -- ALU Output Register Enable
    RETURN_REG_EN      : out std_logic;
    Reg_RD2_EN 	       : out std_logic;
    
    -- MEM Control Signals
    DRAM_WE            : out std_logic;  -- Data RAM Write Enable
    ALU_OUT2_SEL       : out std_logic;
    LMD_LATCH_EN       : out std_logic;  -- LMD Register Latch Enable
    Alu_outreg2_en     : out std_logic;
    JUMP_en            : out std_logic;  -- JUMP Enable Signal for PC input MUX
    PC_LATCH_EN        : out std_logic;  -- Program Counte Latch Enable
    Reg_RD3_EN 	       : out std_logic;
    write_stop_if_branch : out std_logic;

    -- WB Control signals
    WB_MUX_SEL         : out std_logic;  -- Write Back MUX Sel
    RF_WE              : out std_logic; -- Register File Write Enable
    WB_MUX_ADD_SEL     : out std_logic; -- selettore mux alu e return registers
    WR: out std_logic);

  end component;

  component IRAM is
  generic (
    RAM_DEPTH : integer := 48;
    I_SIZE : integer := 32);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
    Dout : out std_logic_vector(I_SIZE - 1 downto 0)
    );

end component;
  
  ----------------------------------------------------------------
  -- Signals Declaration
  ----------------------------------------------------------------
  -- constant dp_nbit: integer := 32;
  -- Instruction Register (IR) and Program Counter (PC) declaration
  signal IR : std_logic_vector(IR_SIZE - 1 downto 0);
  --signal opcode_cu : std_logic_vector(5 downto 0);
  --signal func_cu : std_logic_vector(10 downto 0);
  signal PC : std_logic_vector(PC_SIZE - 1 downto 0);
  -- segnali legati alla fase di fetch e decode
  signal in_NPC, out_NPC, npc2 : std_logic_vector(numbit-1 downto 0);
  signal sel_bus_pc, jump_verified: std_logic;
  -- segnali che arrivano dal dp
  
  signal comp_branch_dp: std_logic; -- esce dal dp e serve per pilotare il mux del pc
  signal out_alu_dp: std_logic_vector(numbit-1 downto 0); 


  -- Datapath Bus signals
  signal PC_BUS : std_logic_vector(PC_SIZE -1 downto 0);

  -- Control Unit Bus signals
  signal IR_LATCH_EN_i : std_logic;
  signal NPC1_LATCH_EN_i : std_logic;
  signal NPC2_LATCH_EN_i : std_logic;
  signal RegA_LATCH_EN_i : std_logic;
  signal RegB_LATCH_EN_i : std_logic;
  signal RegIMM_LATCH_EN_i : std_logic;
  signal RegAluOpCodeGen_EN_i: std_logic;
  signal en_RD1_i, en_RD2_i: std_logic;
  signal rd1_i, rd2_i, wr_i, wr_cu: std_logic;
  signal EQ_COND_i : std_logic;
  signal JUMP_EN_i : std_logic;
  signal stop_write, write_stop_if_branch_i : std_logic;
  signal MUXA_SEL_i : std_logic;
  signal MUXB_SEL_i : std_logic;
  signal ALU_OUTREG_EN_i : std_logic;
  signal RETURN_REG_EN_i : std_logic;
  signal B2_EN_i: std_logic;
  signal DRAM_WE_i : std_logic;
  signal LMD_LATCH_EN_i : std_logic;
  signal PC_LATCH_EN_i : std_logic;
  signal WB_MUX_SEL_i, wb_mux_add_sel_i : std_logic;
  signal RF_WE_i : std_logic;
  signal en_RD3_i: std_logic;
signal Alu_outreg2_en_i: std_logic;
signal sel_alu_ret_i: std_logic;
signal immediate, pc_jump : std_logic_vector(31 downto 0);

  -- Data Ram Bus signals


  begin  -- DLX

	DP_I: datapath
	generic map (numbit)
	port map(
		clk => clk,
		rst => rst,
    flush =>jump_verified,
		rf1 => rd1_i,
		rf2 => rd2_i,
		wf1=> wr_i,

		EN_regA => RegA_LATCH_EN_i,
		EN_regB => RegB_LATCH_EN_i,
		EN_regIMM => RegIMM_LATCH_EN_i,
		EN_regALUOP => RegAluOpCodeGen_EN_i,
		EN_regRD1 => en_RD1_i,
		EN_regNPC2 => NPC2_LATCH_EN_i,
		S1 => MUXA_SEL_i,
		S2 => MUXB_SEL_i,
		EN_regRET => RETURN_REG_EN_i,
		EN_regOUTALU => ALU_OUTREG_EN_i,
		EN_regB2 => B2_EN_i,
		EN_regRD2 => en_RD2_i,
		EN_regALU2 => Alu_outreg2_en_i,
		EN_regLMD => LMD_LATCH_EN_i,
		EN_regRD3 => en_RD3_i,
		Sel_ret_alu => sel_alu_ret_i,
		Sel_alu_lmd => WB_MUX_SEL_i,
		sel_31_rd => WB_MUX_ADD_SEL_i,
		-- input datapath
		NPC => out_NPC,
		IR_dp => IR,
		-- output datapath
		OUT_DP => out_alu_dp,
		comp_branch_i => comp_branch_dp,
		immediate_branch => immediate,
		ADD_mem => dram_ADD,
	   	DIN_mem => dram_DIN,
		DOUT_mem => dram_DOUT);
		
		
		dram_RD  <= '1'; --this should be an output of the CU, but we actually do not use the memory
    dram_WR  <= DRAM_WE_i; -- segnale lettura dram, da cu


    -- purpose: Instruction Register Process
    -- type   : sequential
    -- inputs : Clk, Rst, IRam_DOut, IR_LATCH_EN_i
    -- outputs: IR_IN_i
    IR_P: process (Clk, Rst, sel_bus_pc)
    begin  -- process IR_P
      if Rst = '0' then                 -- asynchronous reset (active low)
        IR <= (others => '0');
      elsif jump_verified = '1' then
        IR<=(others=> '0');
    elsif Clk'event and Clk = '1' then  -- rising clock edge
        if (ir_LATCH_EN_i = '1') then
          IR <= IRam_DOut;
        end if;
      end if;
    end process IR_P;


    -- purpose: Program Counter Process
    -- type   : sequential
    -- inputs : Clk, Rst, PC_BUS
    -- outputs: IRam_Addr
    PC_P: process (Clk, Rst)
    begin  -- process PC_P
      if Rst = '0' then                 -- asynchronous reset (active low)
        PC <= (others => '0');
      elsif Clk'event and Clk = '1' then  -- rising clock edge
        if (ir_LATCH_EN_i = '1') then
          PC <= PC_BUS;
        end if;
      end if;
    end process PC_P;
    
    iram_addr<=pc;

-- l'uscita del pc oltre ad andare nell'iram entra anche in un sommatore +4
    adder4: process (pc, clk, ir_latch_en_i)
    begin 
      if (ir_LATCH_EN_i = '1') then
	in_NPC <= pc + "00000000000000000000000000000100"; -- qui sto sommando 4
  end if;
    end process;
    

    NPC1: process (Clk, Rst)
    begin  -- process PC_P
      if Rst = '0' then                 -- asynchronous reset (active low)
        out_NPC <= (others => '0');
      elsif Clk'event and Clk = '1' then  -- rising clock edge
        if (NPC1_LATCH_EN_i = '1') then 
          out_NPC <= in_NPC;
        end if;
      end if;
    end process NPC1;


    jump_verified <= jump_en_i or comp_branch_dp; -- selettore mux del pc e sarà anche il reset per gli stadi di pipe fatti sbagliati
    sel_bus_pc<=jump_verified;
    
    


  NPC2_proc: process (Clk, Rst)
    begin  -- process PC_P
      if Rst = '0' then                 -- asynchronous reset (active low)
        npc2 <= (others => '0');
      elsif Clk'event and Clk = '1' then  -- rising clock edge
        if (NPC2_LATCH_EN_i = '1') then -- non so se il segnale si chiami davvero co
          npc2 <= out_npc;
        end if;
      end if;
    end process NPC2_proc;



    adderimm: process (pc, clk, immediate)
    begin 
	   pc_jump <= npc2 + immediate; -- qui sto sommando 
    end process;
    

	mux_pc: mux21
	generic map (Numbit) -- dimensione bit in out mux
	port map (in_NPC, pc_jump, sel_bus_pc, pc_bus);
	
	
		
		wr_i<= wr_cu and not(write_stop_if_branch_i);
		--wr_i<= wr_cu;

    -- Control Unit Instantiation
    CU_I: CU_HDW
      port map (
          Clk             => Clk,
          Rst             => Rst,
          IR_IN           => IRam_dout,
          flush => jump_verified,
          IR_LATCH_EN     => IR_LATCH_EN_i,
          NPC1_LATCH_EN    => NPC1_LATCH_EN_i,
-- primo stadio
	  NPC2_LATCH_EN   => NPC2_LATCH_EN_i,
          RegA_LATCH_EN   => RegA_LATCH_EN_i,
          RegB_LATCH_EN   => RegB_LATCH_EN_i,
          RegIMM_LATCH_EN => RegIMM_LATCH_EN_i,
	  RegAluOpCodeGen_EN => RegAluOpCodeGen_EN_i,
          Reg_RD1_EN => en_RD1_i,
	  rd1 => rd1_i,
  	  rd2 => rd2_i,
-- secondo stadio
	  B2_LATCH_EN => B2_EN_i,
          MUXA_SEL        => MUXA_SEL_i,
          MUXB_SEL        => MUXB_SEL_i,
          ALU_OUTREG_EN   => ALU_OUTREG_EN_i,
	  RETURN_REG_EN => RETURN_REG_EN_i,
	  Reg_RD2_EN => en_RD2_i,
-- terzo stadio
          DRAM_WE         => DRAM_WE_i,
	  ALU_OUT2_SEL => sel_alu_ret_i,
          LMD_LATCH_EN    => LMD_LATCH_EN_i,
 	  Alu_outreg2_en => Alu_outreg2_en_i,
          JUMP_EN         => JUMP_EN_i,
          PC_LATCH_EN     => PC_LATCH_EN_i,
	  Reg_RD3_EN => en_RD3_i,
	  write_stop_if_branch => write_stop_if_branch_i,
-- quarto stadio
          WB_MUX_SEL      => WB_MUX_SEL_i,
          RF_WE           => RF_WE_i,
	  WB_MUX_ADD_SEL => WB_MUX_ADD_SEL_i,
	  WR=> WR_cu);
	
end dlx_rtl;
