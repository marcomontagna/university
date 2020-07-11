library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use WORK.log2_function.all; -- funzione per implementare il logaritmo in base 2

-- memoria all'interno del datapath, fuori dalla cartella datapath.core perché non è sintetizzabile
entity DATARAM is
  generic (
    nbit : integer := 32; -- dimensione input output
    row_mem : integer := 512); -- numero di righe nella memoria
  port (
    	--CLK  : in  std_logic;
	RESET : in  std_logic;
	RD  : in  std_logic;
	WR  : in  std_logic;
    	ADD : in  std_logic_vector(32 - 1 downto 0); --log2(row)
   	DIN : in std_logic_vector(nbit - 1 downto 0);
	DOUT : out std_logic_vector(nbit - 1 downto 0)
    );

end DATARAM;

architecture behaviour of DATARAM is

  type RAMtype is array (0 to row_mem - 1) of std_logic_vector (nbit-1 downto 0);
  signal DRAM_mem : RAMtype;

begin  -- DRam_beh
	process (reset, wr, rd, dram_mem, add)
	begin
		if ( ReSeT = '0') then -- reset active low
			DRAM_mem <= (others =>(others => '0')); -- resetto tutto a 0
		--elsif ( clk'event and clk = '1') then
			elsif wr = '1' then
				dram_mem(conv_integer(add)) <= din; -- salvo in memoria all'indirizzo add
			elsif rd = '1' then
				dout <= dram_mem(conv_integer(add)); -- scrivo in uscita contenuto cella add
			end if;
	--	end if;
	end process;
end behaviour;
