library ieee;
use ieee.std_logic_1164.all;

-- Sync reset register with enable

entity registro is
	generic (N: integer := 32);
	port (data: in std_logic_vector(N-1 downto 0);
			enable, clock, clear: in std_logic;
			Q: out std_logic_vector(N-1 downto 0));
end registro;

architecture behaviour of registro is
begin
	process (clock, clear)
	begin 
			if(clear='0') then
				Q<=(others=>'0');
			elsif(clock'event and clock='1') then
			if(enable='1') then
				Q<=data;
			end if;
		end if;
	end process;
end behaviour;
