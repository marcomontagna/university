-- sommatore per aggiornare pc
-- montagna marco, pistilli francesca

library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
USE IEEE.STD_LOGIC_SIGNED.ALL; -- libreria WORK user-defined

entity ADDER is
generic (n : integer:=32);
Port (	  A:	In	std_logic_vector(n-1 downto 0) ; 
			B:	In	std_logic_vector(n-1 downto 0);
			OUTPUT:	Out	std_logic_vector(n-1 downto 0));
end ADDER;

-- semplice adder behaviourale, volendo posso anche usare il generic rca

architecture BEHAVIORAL of ADDER is

BEGIN
    
   OUTPUT <= A + B;

end BEHAVIORAL;
