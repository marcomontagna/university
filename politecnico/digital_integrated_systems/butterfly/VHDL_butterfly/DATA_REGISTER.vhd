-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY DATA_REGISTER IS
GENERIC (N:INTEGER);
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN SIGNED((N-1) DOWNTO 0);	--dato in ingresso
DATA_REG_OUT	:	OUT SIGNED((N-1) DOWNTO 0) --dato in uscita
);
END ENTITY DATA_REGISTER;
ARCHITECTURE BEHAVIOR OF DATA_REGISTER IS
BEGIN
REG_PROCESS: PROCESS(CLK)
BEGIN
IF (CLK'EVENT AND CLK='1') THEN
IF RESET='0' THEN
DATA_REG_OUT<=(OTHERS=>'0');
ELSIF (EN_REG='1') THEN
DATA_REG_OUT((N-1) DOWNTO 0)<=DATA_REG_IN((N-1) DOWNTO 0);
END IF;
END IF;
END PROCESS;
END BEHAVIOR;