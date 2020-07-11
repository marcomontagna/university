-- mux 2 to 1
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux_2to1 IS
	PORT
	(
		in1: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		in2: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		SEL_MUX: IN STD_LOGIC;
		out_mux: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END mux_2to1;

ARCHITECTURE behavior OF mux_2to1 IS
BEGIN
	WITH SEL_MUX SELECT out_mux <= 
		in1 WHEN '0',
		in2 WHEN '1',
		in1 WHEN OTHERS;
END behavior;
		