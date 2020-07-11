-- sommatore
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY adder_4bit IS
	PORT
		( 
		NUM1: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		NUM2: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		SUM: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- volontariamente non considero il caso dell'overflow perchè non ha senso
END adder_4bit;

ARCHITECTURE behavior OF adder_4bit IS
BEGIN
	SUM <= NUM1 + NUM2;
END behavior;
		
		