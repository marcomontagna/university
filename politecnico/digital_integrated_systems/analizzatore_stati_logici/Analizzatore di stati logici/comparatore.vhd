-- comparatore

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY comparatore IS
	PORT
	(
		command: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		matchF, matchT, matchS, matchR, err, n_09, n_AF, num: BUFFER STD_LOGIC);
END comparatore;

ARCHITECTURE behavior OF comparatore IS
BEGIN
	matchF <= '1' WHEN command = "01000110" ELSE '0';
	matchT <= '1' WHEN command = "01010100" ELSE '0';
	matchS <= '1' WHEN command = "01010011" ELSE '0';
	matchR <= '1' WHEN command = "01010010" ELSE '0';
	
	--n_09 <= '1' WHEN ((command(0) AND (NOT(command(2)))) OR (NOT(command(2)) AND command(1)) OR 
	--(NOT(command(0)) AND command(2)) OR ((command(2)) AND NOT(command(1)))) = '1' ELSE '0';
	
	--y = A'B'CDE' + A'B'CDF'G', A è 7 G è 0
	n_09 <= '1' WHEN ( ( NOT command(7) and not command(6) and command(5) and command(4) and not command(3) ) OR
	( NOT command(7) and not command(6) and command(5) and command(4) and not command(2) and not command(1) ) ) ='1' ELSE '0';
	
	--y = A'BC'D'E'F'H + A'BC'D'E'GH' + A'BC'D'E'FG'
	--n_AF <= '1' WHEN (command(3) OR (NOT(command(1)) AND NOT(command(2)) AND command(3))) = '1' ELSE '0';
	n_AF <= '1' WHEN ( (not command(7) and command(6) and not command(5) and not command(4) and not command(3) and not command(2)
								and command(0)) OR (not command(7) and command(6) and not command(5) and not command(4) and not command(3)
								and command(1)and not command(0)) OR (not command(7) and command(6) and not command(5) and not command(4) 
								and not command(3) and command(2) and not command(1)) ) = '1' ELSE '0';

	err <= not(matchF OR matchR OR matchS OR matchT OR n_09 OR n_AF );
	num <= (n_09 OR n_AF);
	
END behavior;