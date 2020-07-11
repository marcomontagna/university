-- questa sarebbe la versione testata nel tb, complete di tutto dove mettiamo insieme dlx e memorie 
-- facciamo questa cosa perchè le memorie non sono sintetizzabili

library ieee;
use ieee.std_logic_1164.all;
use work.globals.all;
use work.log2_function.all;

entity complete_DLX is
  port (
    Clk : in std_logic;
    Rst : in std_logic -- active low
);                
end complete_DLX;

architecture beh_complete_dlx of complete_DLX is


	component DLX is
  	generic (
    		IR_SIZE      : integer := 32;       -- Instruction Register Size
    		PC_SIZE      : integer := 32       -- Program Counter Size
    		);       -- ALU_OPC_SIZE if explicit ALU Op Code Word Size
  	port (
    		Clk : in std_logic;
    		Rst : in std_logic; -- active low
   		dram_RD  : out  std_logic; -- segnale scrittura dram, da cu
    		dram_WR  : out  std_logic; -- segnale lettura dram, da cu
    		dram_ADD : out  std_logic_vector(32 - 1 downto 0); -- indirizzo dram, da dp
    		dram_DIN : out std_logic_vector(numbit - 1 downto 0); -- dato in ingresso a dram, da dp
    		dram_DOUT : in std_logic_vector(numbit - 1 downto 0); -- dato in uscita da dram, verso dp
		-- segnali memoria iram
    		iram_Addr : out  std_logic_vector(PC_SIZE - 1 downto 0); -- segnale in ingresso a iram, sarebbe quello che 			esce da reg pc mi sembra
    		iram_Dout : in std_logic_vector(IR_SIZE - 1 downto 0) -- segnal in uscita da iram
		);                
	end component;

	component DATARAM is
  	generic (
    		nbit : integer := 32; -- dimensione input output
    		row_mem : integer := 512); -- numero di righe nella memoria
  	port (
  	  
		RESET : in  std_logic;
		RD  : in  std_logic;
		WR  : in  std_logic;
    		ADD : in  std_logic_vector(32 - 1 downto 0); --log2(row)
   		DIN : in std_logic_vector(nbit - 1 downto 0);
		DOUT : out std_logic_vector(nbit - 1 downto 0)
    		);

	end component;

	component IRAM is
  	generic (
    		RAM_DEPTH : integer := 48;
    		I_SIZE : integer := 8);
  	port (
   		Rst  : in  std_logic;
    		Addr : in  std_logic_vector(32 - 1 downto 0);
    		Dout : out std_logic_vector(32 - 1 downto 0)
    		);

	end component;

	--signals
	signal dram_RD_i : std_logic; -- segnale scrittura dram, da cu
    	signal dram_WR_i : std_logic; -- segnale lettura dram, da cu
    	signal dram_ADD_i : std_logic_vector(32 - 1 downto 0); -- indirizzo dram, da dp
    	signal dram_DIN_i : std_logic_vector(numbit - 1 downto 0); -- dato in ingresso a dram, da dp
    	signal dram_DOUT_i : std_logic_vector(numbit - 1 downto 0); -- dato in uscita da dram, verso dp
	-- segnali memoria iram
    	signal iram_Addr_i : std_logic_vector(PC_SIZE - 1 downto 0); -- segnale in ingresso a iram, sarebbe quello che 			esce da reg pc mi sembra
    	signal iram_Dout_i : std_logic_vector(IR_SIZE - 1 downto 0); -- segnal in uscita da iram

	begin -- beh_ complete_dlx
	
	dlx_component: dlx 
	generic map (numbit, numbit)
	port map (Clk => clk,
    		  Rst => rst,
		  -- segnali memoria dram
   		  dram_RD  => dram_RD_i,
    		  dram_WR => dram_WR_i,
    		  dram_ADD => dram_add_i,
    		  dram_DIN => dram_din_i,
    		  dram_DOUT => dram_dout_i,
		  -- segnali memoria iram
    		  iram_Addr => iram_addr_i,
    		  iram_Dout  => iram_dout_i);

	memoria_dati : dataram
	generic map (numbit, row_mem)
	port map(RESET => rst,
		 RD => dram_RD_i,
		 WR => dram_wr_i,
    		 ADD => dram_add_i,
   		 DIN => dram_din_i,
		 DOUT => dram_dout_i );

	memoria_istruzioni : iram
	generic map (ram_depth, 8)
	port map (rst => rst,
	          addr => iram_addr_i,
		  dout => iram_dout_i);
	
end beh_complete_dlx;
