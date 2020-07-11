-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele
-- control unit

library ieee;
use ieee.std_logic_1164.all;

entity control_unit is 
	port (
			clk, reset, start: in std_logic;
			verso_sommatore, done, reset_datapath, sum_sub_n, mux1, mux2, reg_molt1, reg_molt2, reg_sum, en1, en2, en3, en4, en5, en6, en_reg_approx, mux_RF_sum, mux_RF_molt: out std_logic);
end control_unit;

architecture behavior of control_unit is

component command_generator 
	port (
			clk, reset: in std_logic;
			input_microAR: in std_logic_vector (4 downto 0);
			output_microIR: out std_logic_vector(17 downto 0));
end component;

component conditional_sequential_pla
	port (
			clk, reset, start: in std_logic;
			output_microAR: out std_logic_vector( 4 downto 0));
end component;

signal microAR: std_logic_vector( 4 downto 0);
signal microIR: std_logic_vector( 17 downto 0);

begin
	conditional_pla: conditional_sequential_pla PORT MAP (clk, reset, start, microAR);
	generatore_comandi: command_generator PORT MAP(clk, reset, microAR, microIR);
	verso_sommatore <= microIR(17);
	done <= microIR(16);
	reset_datapath <= microIR(15);
	sum_sub_n <= microIR(14);
	mux1 <= microIR(13);
	mux2 <= microIR(12);
	reg_molt1 <= microIR(11);
	reg_molt2 <= microIR(10);
	reg_sum <= microIR(9);
	en1 <= microIR(8);
	en2 <= microIR(7);
	en3 <= microIR(6);
	en4 <= microIR(5);
	en5 <= microIR(4);
	en6 <= microIR(3);
	en_reg_approx <= microIR(2);
	mux_RF_sum <= microIR(1);
	mux_RF_molt <= microIR(0);
	
end behavior;
	
	