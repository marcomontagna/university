LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_NBIT IS
	GENERIC (N:INTEGER);
	PORT(
		SEL	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);	
		DATA_1, DATA_2, DATA_3, DATA_4, DATA_5, DATA_6, DATA_7, DATA_8	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato in ingresso
		DATA_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0) --dato in uscita
	);
END MUX_NBIT;

ARCHITECTURE BEHAVIOR OF MUX_NBIT IS

BEGIN
	WITH SEL SELECT DATA_OUT<=
	DATA_1 WHEN "000",
	DATA_2 WHEN "001",
	DATA_3 WHEN "010",
	DATA_4 WHEN "011",
	DATA_5 WHEN "100",
	DATA_6 WHEN "101",
	DATA_7 WHEN "110",
	DATA_8 WHEN "111",
	DATA_7 WHEN OTHERS;
END BEHAVIOR;