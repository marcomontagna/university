-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele
-- ROM istruzioni

library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity ROM_istruzioni is
	port (
			ADDR : in std_logic_vector (4 downto 0); -- address input
			DOUT : out std_logic_vector (17 downto 0)); -- data output
end ROM_istruzioni;

architecture BEHAVIOR of ROM_istruzioni is

type ROMTABLE is array (0 to 17) of std_logic_vector (17 downto 0);
-- internal table
	constant romdata : romtable := (
	-- istruzioni per ogni stato
	-- verso_sommatore, done, reset, sum/sub, mux1, mux2, reg_molt1, reg_molt2, reg_sum
	-- en1, en2, en3, en4, en5, en6, en_reg_approx, mux_RF_sum, mux_RF_molt
		
		"000000000000000000", -- reset
		"001000000000000000", -- idle
		"001000000100100000", -- step 1, abilito reg br e wr
		"001000100010000000", -- step 2
		"001000110001100001", -- step 3
		"001000110010010001", -- step 4
		"001001111000010000", -- step 5, corretto
		"001001011000011010", -- step 6
		"001111001000011000", -- step 7. corretto, qui dovrebbe fare la somma se è tutto giusto, il quarto bit e' a 1 quindi
		"001011001000001000", -- step 8, corretto, dove lo metto il done? così è un colpo di clock prima del dato
		"101010001000001100", -- step 9 corretto
		"111010001000001110", -- step 10 corretto
		"001000000000001100", -- step 11
		"001000000000000100", -- step 12
		"101010001100101100", -- step 9.1 ok
		"111010101010001110", -- step 10.1
		"001000110001101101", -- step 11.1
		"001000110010010101"); -- step 12.1

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
	

