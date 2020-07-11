-- questo componente fa le operazioni logiche richieste dalla alu cioè or e xor e and
library ieee; 
use ieee.std_logic_1164.all; 
use work.GLOBALS.all;

entity operatore_logic is 
    generic (REG_SIZE: INTEGER :=32);
	Port(	
			A:	In	std_logic_vector(REG_SIZE-1 downto 0);
			B:	In	std_logic_vector(REG_SIZE-1 downto 0);
			OUT_LOGIC_AND:	Out	std_logic_vector(REG_SIZE-1 downto 0);
			OUT_LOGIC_OR:	Out	std_logic_vector(REG_SIZE-1 downto 0);
			OUT_LOGIC_XOR:	Out	std_logic_vector(REG_SIZE-1 downto 0)
		   );
end operatore_logic;

architecture behaviour of operatore_logic is

BEGIN

OUT_LOGIC_AND <= A AND B;
OUT_LOGIC_XOR <=A XOR B;	 
OUT_LOGIC_OR <= A OR B ;			 
end behaviour;
