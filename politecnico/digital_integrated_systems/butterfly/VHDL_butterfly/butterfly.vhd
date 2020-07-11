-- butterfly
-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity butterfly is 
	port (
			START, CLOCK, RESET: in std_logic;
			input_btf_1, input_btf_2: in signed (23 downto 0); -- che cosa sono i due ingressi? Che formato?
			DONE: out std_logic;
			output_btf: out signed (23 downto 0)); -- di nuovo devo capire il formato
end butterfly;

architecture behavior of butterfly is

component control_unit 
	port (
			clk, reset, start: in std_logic;
			verso_sommatore, done, reset_datapath, sum_sub_n, mux1, mux2, reg_molt1, reg_molt2, reg_sum, en1, en2, en3, en4, en5, en6, en_reg_approx, mux_RF_sum, mux_RF_molt: out std_logic);
end component;

component datapath_butterfly
	port (
			clk, verso_sommatore, done, reset_datapath, sum_sub_n, mux1, mux2: in std_logic;
			reg_molt1, reg_molt2, reg_sum: in std_logic;
			en1, en2, en3, en4, en5, en6: in std_logic;
			en_reg_approx, mux_RF_sum, mux_RF_molt : in std_logic;
			B_A, W: in signed (23 downto 0);
			uscita: out  signed (23 downto 0));
end component;

signal verso_sommatore_btf, done_datapath_btf, reset_datapath_btf, sum_sub_n_btf, mux1_btf, mux2_btf, reg_molt1_btf, reg_molt2_btf, reg_sum_btf, en1_btf, en2_btf, en3_btf, en4_btf, en5_btf, en6_btf, en_reg_approx_btf, mux_RF_sum_btf, mux_RF_molt_btf: std_logic;
signal uscita_btf: signed (23 downto 0);
begin 

CU: control_unit 
	PORT MAP 
		(CLOCK, RESET, START, 
		verso_sommatore_btf, done_datapath_btf, reset_datapath_btf, 
		sum_sub_n_btf, mux1_btf, mux2_btf, 
		reg_molt1_btf, reg_molt2_btf, reg_sum_btf, 
		en1_btf, en2_btf, en3_btf, en4_btf, en5_btf, en6_btf, 
		en_reg_approx_btf, mux_RF_sum_btf, mux_RF_molt_btf);
		
DONE <= done_datapath_btf;

DP: datapath_butterfly
	PORT MAP
		(CLOCK, 
		verso_sommatore_btf, done_datapath_btf, reset_datapath_btf, 
		sum_sub_n_btf, mux1_btf, mux2_btf, 
		reg_molt1_btf, reg_molt2_btf, reg_sum_btf, 
		en1_btf, en2_btf, en3_btf, en4_btf, en5_btf, en6_btf, 
		en_reg_approx_btf, mux_RF_sum_btf, mux_RF_molt_btf,
		input_btf_1, input_btf_2, uscita_btf);
		
output_btf <= uscita_btf;
end behavior;