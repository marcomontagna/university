-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele
-- datapath_butterfly

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath_butterfly is 
	port (
			clk, verso_sommatore, done, reset_datapath, sum_sub_n, mux1, mux2: in std_logic;
			reg_molt1, reg_molt2, reg_sum: in std_logic;
			en1, en2, en3, en4, en5, en6: in std_logic;
			en_reg_approx, mux_RF_sum, mux_RF_molt : in std_logic;
			B_A, W: in signed (23 downto 0);
			uscita: out  signed (23 downto 0));
end datapath_butterfly;


architecture behavior of datapath_butterfly is

component register_file is 
	port (
			clk, reset: in std_logic;
			en1, en2, en3, en4: in std_logic;
			sel_muxB, sel_muxA: in std_logic;
			input_B_A, input_W: in signed (23 downto 0); -- che cosa sono i due ingressi? Che formato?
			outputB, outputA, outputW: out signed (23 downto 0)); -- di nuovo devo capire il formato
end component;

component DATA_REGISTER
GENERIC (N:INTEGER);
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN SIGNED((N-1) DOWNTO 0);	--dato in ingresso
DATA_REG_OUT	:	OUT SIGNED((N-1) DOWNTO 0) --dato in uscita
);
end component;

component MUX_NBIT
GENERIC (N:INTEGER);
PORT(
SEL	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_1, DATA_2	:	IN SIGNED((N-1) DOWNTO 0);	--dato in ingresso
DATA_OUT	:	OUT SIGNED((N-1) DOWNTO 0)); --dato in uscita
END component;

component molt_pipe2
GENERIC ( N : integer :=24 ); 
port 
   (  en1_molt,en2_molt,rst,clock: in std_logic;
      a : in signed (N-1 downto 0);
      b : in signed  (N-1 downto 0);
      result : out signed  (2*N-2 downto 0)
   );
end component;

component round_D
GENERIC ( N : integer :=49 ); 
port ( 
en,rst,clock: in std_logic;
input: in signed(N-1 downto 0);
output: out signed(23 downto 0));
end component;

component sum_pipe
GENERIC ( N : integer :=49 ); 
port 
   (
      a : in signed (N-1 downto 0);
      b : in signed  (N-1 downto 0);
		w,en,rst,clock, verso_sommatore: in std_logic;
      result : out signed  (N-1 downto 0)
   );
end component;

signal busB, busA, busW: signed (23 downto 0);
signal bus_molt, moltiplicazione: signed (46 downto 0);
signal A_49bit, out_mux1, out_mux2, Aper2_49bit, molt_49bit: signed (48 downto 0);
signal bus_somma, somma: signed (48 downto 0);
signal t : signed (22 downto 0);

begin

RF: register_file PORT MAP (clk, reset_datapath, en1, en2, en3, en4, mux_RF_molt, mux_RF_sum, B_A, W, busB, busA, busW);
multiplier: molt_pipe2 PORT MAP (reg_molt1, reg_molt2, reset_datapath, clk, busB, busW, moltiplicazione);
reg_moltiplicatore: DATA_REGISTER 
	GENERIC MAP (N=>47)
	PORT MAP (en5, clk, reset_datapath, moltiplicazione, bus_molt);
t <= (OTHERS => '0');
A_49bit <= busA(23)&busA(23)&busA&t;-- come faccio a far diventare A su 49 bit?
multiplexer1: MUX_NBIT
	GENERIC MAP (N=>49)
	PORT MAP (mux1, A_49bit, bus_somma, out_mux1);
	
Aper2_49bit <= busA(23)&busA&t&'0';-- vedere come fare moltipicazione per 2 e shift
molt_49bit <= bus_molt(46)&bus_molt(46)&bus_molt;
multiplexer2: MUX_NBIT
	GENERIC MAP (N=>49)
	PORT MAP (mux2, Aper2_49bit, molt_49bit, out_mux2);
sommatore: sum_pipe PORT MAP (out_mux1, out_mux2, sum_sub_n, reg_sum, reset_datapath, clk, verso_sommatore, somma); 
reg_multiplier: DATA_REGISTER 
	GENERIC MAP (N=>49)
	PORT MAP (en6, clk, reset_datapath, somma, bus_somma);
blocco_approssimazione: round_D
	PORT MAP (en_reg_approx, reset_datapath, clk, bus_somma, uscita); 

end behavior;

