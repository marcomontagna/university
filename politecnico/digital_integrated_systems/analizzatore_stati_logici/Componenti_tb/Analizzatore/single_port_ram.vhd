--SSRAM 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_ram is

	generic 
	(
		DATA_WIDTH : integer := 16;
		ADDR_WIDTH : integer := 5 --simuliamo con 32 locazioni 
	);

	port 
	(
		CE_N,OE_N, WE_N: in std_logic;
		addr	: in std_logic_vector((ADDR_WIDTH - 1) downto 0);
		sram_dq	: inout std_logic_vector((DATA_WIDTH-1) downto 0)

	);

end entity;

architecture rtl of single_port_ram is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal.	
	signal ram : memory_t;

	-- Register to hold the address 
	signal addr_reg : std_logic_vector ((ADDR_WIDTH-1) downto 0);
	
	--dato letto collegato con tri state
	signal q, q_out	: std_logic_vector((DATA_WIDTH-1) downto 0);
begin

	process(CE_N,OE_N,WE_N)
	begin
	if(CE_N='0') then
		if(WE_N = '0') then
			ram(to_integer(unsigned(addr))) <= sram_dq;
		elsif (WE_N='1') then
			if (OE_N='0') then
			q <= ram(to_integer(unsigned(addr_reg)));
			else 	q<=(others=>'Z');
			end if;
			else 	q<=(others=>'Z');
			end if;
	else 	q<=(others=>'Z');
	end if;
	
		-- Register the address for reading
		addr_reg <= addr;
	end process;
	
	sram_dq<=q;

end rtl;
