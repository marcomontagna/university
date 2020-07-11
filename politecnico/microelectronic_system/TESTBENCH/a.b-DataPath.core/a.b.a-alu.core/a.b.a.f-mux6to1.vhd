library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic

entity MUX_6to1 is 
	generic (n: integer:=32);
	Port (	
		A:	In	std_logic_vector(n-1 downto 0); 
		B:	In	std_logic_vector(n-1 downto 0);
		C:	In	std_logic_vector(n-1 downto 0);
		D:	In	std_logic_vector(n-1 downto 0); 
		E:	In	std_logic_vector(n-1 downto 0);
		F:	In	std_logic_vector(n-1 downto 0);
		S:	In	std_logic_vector(2 downto 0);
		Y:	Out	std_logic_vector(n-1 downto 0));
end MUX_6to1 ;

architecture BEH of MUX_6to1  is
	SIGNAL UNDEFINED: STD_LOGIC_VECTOR (N-1 DOWNTO 0):=(OTHERS => 'X');
begin
	
	process(A, B, C, D, E,F , S)
	    begin
	if S="000" then
	    Y<=A;
	 elsif S="001" then
	     Y<=B;
	 elsif S="010" THEN
	    Y<=C;
	 elsif S="011" then
	         Y<=D;
	  elsif S="100" THEN
	  	     Y<=E;
	  elsif S="101" THEN
	      Y<=F;
	   ELSE
	    Y<=A;
	 end if;
	 end process;

end BEH;
