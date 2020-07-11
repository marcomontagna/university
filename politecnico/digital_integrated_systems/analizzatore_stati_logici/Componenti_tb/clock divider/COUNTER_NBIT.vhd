LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_unsigned.all;
ENTITY COUNTER_NBIT IS
GENERIC (N:INTEGER);
PORT(
EN_COUNT, LOAD_COUNT,CLK,RESET	: IN STD_LOGIC;	--abilita conta, carica dato da cui iniziare a contare
COUNT_IN	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato da caricare in parallelo
COUNT_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0);
TC	:	OUT STD_LOGIC	--terminal count
);
END ENTITY COUNTER_NBIT;

ARCHITECTURE BEHAVIOR OF COUNTER_NBIT IS
SIGNAL CNT: STD_LOGIC_VECTOR((N-1) DOWNTO 0) ;
SIGNAL TERM_COUNT:STD_LOGIC;

BEGIN

COUNTER_PROCESS:PROCESS(CLK)
BEGIN

IF (CLK'EVENT AND CLK='1') THEN
IF RESET='0' THEN
CNT<=(OTHERS=>'0'); TERM_COUNT<='0';
ELSIF (EN_COUNT='1' AND CNT=2**N-1)THEN
TERM_COUNT<='1';
CNT<=(OTHERS=>'0');
ELSIF(EN_COUNT='1' AND LOAD_COUNT='0') THEN
CNT <=CNT+'1'; TERM_COUNT<='0';
ELSIF (EN_COUNT='1' AND LOAD_COUNT='1') THEN
CNT((N-1) DOWNTO 0) <=COUNT_IN((N-1) DOWNTO 0); TERM_COUNT<='0';
END IF;
END IF;
END PROCESS;
TC<=TERM_COUNT;
COUNT_OUT((N-1)DOWNTO 0)<=CNT((N-1) DOWNTO 0);
END BEHAVIOR;