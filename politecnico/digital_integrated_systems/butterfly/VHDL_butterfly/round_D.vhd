-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity round_D is
GENERIC ( N : integer :=49 ); 
port ( 
en,rst,clock: in std_logic;
input: in signed(N-1 downto 0);
output: out signed(23 downto 0));
end round_d;
architecture rtl of round_D is
component DATA_REGISTER IS
GENERIC (N:INTEGER);
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN signed((N-1) DOWNTO 0);	--dato in ingresso
DATA_REG_OUT	:	OUT signed((N-1) DOWNTO 0)
); --dato in uscita
END component;
signal rs :signed(N-1 downto 0);
signal bs: std_logic_vector(N-1 downto 0):= (OTHERS => '0');
signal bs1 :signed(N-1 downto 0);
signal c :signed(23 downto 0);
begin
 bs1<=signed(bs);
 bs(22)<='1';
 rs<=input+bs1;
 c<= rs(48 downto 25);
Registro : DATA_REGISTER generic map(N=>24) port map(en,clock,rst,c,output);
end rtl;