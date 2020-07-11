-- edge triggered D FF

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY D_FF_RST_AS IS
	PORT (input, clock, reset_as_n: IN STD_LOGIC;
			Q: OUT STD_LOGIC);
END D_FF_RST_AS;

ARCHITECTURE behavior OF D_FF_RST_AS IS

BEGIN
	PROCESS (input, clock, reset_as_n)
	BEGIN	
		IF reset_as_n = '0' THEN
			Q <= '0';
			
		ELSIF clock'event and clock ='1' THEN
			Q <= input;
		END IF;
	END PROCESS;
END behavior;