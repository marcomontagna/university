-- ROM jump
-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM_JUMP is
	port (
			ADDR : in std_logic_vector (4 downto 0); -- address input
			DOUT : out std_logic_vector (5 downto 0)); -- data output
end ROM_JUMP;

architecture BEHAVIOR of ROM_JUMP is

type ROMTABLE is array (0 to 17) of std_logic_vector (5 downto 0);
-- internal table
	constant romdata : romtable := (
		
		"100001", -- data for address 0, reset
		"100001", -- data for address 1, salto in idle se non arriva start, idle
		"000000", --step 1
		"000000",
		"000000",
		"000000",
		"000000",
		"000000",
		"101110", --step 7
		"000000", -- salto nello stato 9.1, step 8
		"000000", -- step 9
		"000000",
		"100001",
		"100001", -- step 12, salto nell'idle perchè ero in one shot e ho finito
		"000000", -- step 9.1, sono in modalità continua e sono saltato qui
		"000000",
		"100110",
		"000000"); -- ho finito giro in modalità continua, salto allo step 5 e riprendo elaborazione da lì





begin -- BEHAVIOR
-- purpose: Main process
-- type : combinational
-- inputs : ADDR
-- outputs: DOUT
process (ADDR)
begin -- process
		DOUT <= romdata(to_integer(unsigned(ADDR)));
	end process;
end BEHAVIOR;
	

