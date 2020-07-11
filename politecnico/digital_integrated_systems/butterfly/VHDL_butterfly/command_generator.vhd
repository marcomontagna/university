-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele
-- command generator

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity command_generator is 
	port (
			clk, reset: in std_logic;
			input_microAR: in std_logic_vector (4 downto 0);
			output_microIR: out std_logic_vector(17 downto 0));
end command_generator;

architecture behavior of command_generator is

component vector_register
	GENERIC (N:INTEGER);
	PORT(
		EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
		DATA_REG_IN	:	IN std_logic_vector((N-1) DOWNTO 0);	--dato in ingresso
		DATA_REG_OUT	:	OUT std_logic_vector((N-1) DOWNTO 0)); --dato in uscita
end component;

component ROM_istruzioni
	port (
			ADDR : in std_logic_vector (4 downto 0); -- address input microAR
			DOUT : out std_logic_vector (17 downto 0)); -- data output istruzioni microIR
end component;

signal istruzione: std_logic_vector (17 downto 0);

begin

	ROM_generatore_comandi: ROM_istruzioni PORT MAP (input_microAR, istruzione);
	reg_microIR: vector_register
	GENERIC MAP (N=>18)
	PORT MAP ('1', clk, reset, istruzione, output_microIR);
	
end behavior;