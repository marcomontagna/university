library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity MUX_2to1 is 
	generic (n: integer:=32);
	Port (	
		A:	In	std_logic_vector(n-1 downto 0); 
		B:	In	std_logic_vector(n-1 downto 0);
		S:	In	std_logic;
		Y:	Out	std_logic_vector(n-1 downto 0));
end MUX_2to1 ;

architecture BEH of MUX_2to1  is
	SIGNAL UNDEFINED: STD_LOGIC_VECTOR (N-1 DOWNTO 0):=(OTHERS => 'X');
begin
	
	Y <= A when S= '0' else 
	     B WHEN S='1';


end BEH;
