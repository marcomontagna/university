library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity MUX_31 is 
	generic (n: integer:=32);
	Port (	-- volendo possiamo aggiungere altri ingressi, non so da quanto serva
		A:	In	std_logic_vector(n-1 downto 0); 
		B:	In	std_logic_vector(n-1 downto 0);
		C:	In	std_logic_vector(n-1 downto 0);
		S:	In	std_logic_vector(1 downto 0);
		Y:	Out	std_logic_vector(n-1 downto 0));
end MUX_31 ;

architecture BEH of MUX_31  is
	SIGNAL UNDEFINED: STD_LOGIC_VECTOR (N-1 DOWNTO 0):=(OTHERS => 'X');
begin
	
	Y <= A when S="00" else 
	     B WHEN S="10" ELSE
	     C WHEN S="01" ELSE
-- volendo possiamo aggingere altri segnali
	     UNDEFINED;

end BEH;
