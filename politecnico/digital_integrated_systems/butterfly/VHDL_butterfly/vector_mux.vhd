-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY vector_mux IS
GENERIC (N:INTEGER);
PORT(
SEL	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_1, DATA_2	:	IN std_logic_vector((N-1) DOWNTO 0);	--dato in ingresso
DATA_OUT	:	OUT std_logic_vector((N-1) DOWNTO 0)); --dato in uscita

END ENTITY vector_mux;
ARCHITECTURE BEHAVIOR OF vector_mux IS
BEGIN
WITH SEL SELECT DATA_OUT<=
DATA_1 WHEN '0',
DATA_2 WHEN '1',
DATA_1 WHEN OTHERS;
END BEHAVIOR;