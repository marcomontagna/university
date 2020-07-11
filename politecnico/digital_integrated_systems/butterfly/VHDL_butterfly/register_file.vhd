-- register file
-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity register_file is 
	port (
			clk, reset: in std_logic;
			en1, en2, en3, en4: in std_logic;
			sel_muxB, sel_muxA: in std_logic;
			input_B_A, input_W: in signed (23 downto 0); -- che cosa sono i due ingressi? Che formato?
			outputB, outputA, outputW: out signed (23 downto 0)); -- di nuovo devo capire il formato
end register_file;

architecture behavior of register_file is

component DATA_REGISTER
	GENERIC (N:INTEGER);
	PORT(
		EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
		DATA_REG_IN	:	IN SIGNED((N-1) DOWNTO 0);	--dato in ingresso
		DATA_REG_OUT	:	OUT SIGNED((N-1) DOWNTO 0)); --dato in uscita
end component;

component MUX_NBIT
			GENERIC (N:INTEGER);
			PORT(
				SEL	: IN STD_LOGIC;	--segnale di enable, reset e clock
				DATA_1, DATA_2	:	IN SIGNED((N-1) DOWNTO 0);	--dato in ingresso
				DATA_OUT	:	OUT SIGNED((N-1) DOWNTO 0)); --dato in uscita
end component;

signal Br, Bi_Ai, Ar: signed (23 downto 0);

begin

	reg_Br: DATA_REGISTER
			GENERIC MAP (N=>24)
			PORT MAP (en1, clk, reset, input_B_A, Br);
			
	reg_Bi_Ai: DATA_REGISTER
			GENERIC MAP (N=>24)
			PORT MAP (en2, clk, reset, input_B_A, Bi_Ai);
			
	reg_Ar: DATA_REGISTER
			GENERIC MAP (N=>24)
			PORT MAP (en3, clk, reset, input_B_A, Ar);
		
	reg_Wr_Wi: DATA_REGISTER
			GENERIC MAP (N=>24)
			PORT MAP (en4, clk, reset, input_W, outputW);
			
	mux_B: MUX_NBIT
		GENERIC MAP (N=>24)
		PORT MAP (sel_muxB, Br, Bi_Ai, outputB);
	
	mux_A: MUX_NBIT
		GENERIC MAP (N=>24)
		PORT MAP (sel_muxA, Ar, Bi_Ai, outputA);
	
end behavior;