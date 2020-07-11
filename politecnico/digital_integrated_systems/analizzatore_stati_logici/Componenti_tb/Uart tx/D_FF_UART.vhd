-- registro da 1 bit

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY D_FF_UART IS
	PORT (sh,input, clock, enable, rst_sy_n: IN STD_LOGIC;
			Q: OUT STD_LOGIC);
END D_FF_UART;

ARCHITECTURE behavior OF D_FF_UART IS

BEGIN
	PROCESS (clock,rst_sy_n)
	BEGIN	
	IF rst_sy_n = '0' THEN
				Q <= '1';
		ELSIF clock'EVENT AND clock ='1' THEN
			IF enable = '1' THEN
			   if sh='1'then
				Q <= input;
				end if;
			END IF;
		END IF;
	END PROCESS;
END behavior;