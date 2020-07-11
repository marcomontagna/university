library IEEE;
use IEEE.std_logic_1164.all; 

entity SIG_EXT is 
	generic (
	         BITS: INTEGER := 32
	         );
	Port (	
	   EXT_UNSIGNED :  In	std_logic;
	   EXT_FOR_J :  In	std_logic;
	   S_IN:	In	std_logic_vector(BITS-1 downto 0); 
	   S_OUT:	Out	std_logic_vector(BITS-1 downto 0)
		);
end SIG_EXT ;


ARCHITECTURE BEHAVIOR OF SIG_EXT IS

        
BEGIN    
  process(S_IN,EXT_UNSIGNED,EXT_FOR_J)
  begin
     IF EXT_FOR_J='1' THEN -- EXT_FOR_J MEANS THAT YOU WANT TO DO A JUMP. THEY HAVE AN OFFSET OF 26 BITS INSTEAD OF 16 BITS 
        -- IF EXT_UNSIGNED=1 THEN YOU HAVE TO EXTEND WITH ALL ZERO, OTHERWISE YOU HAVE TO EXTEND WITH THE RIGHT SIGN
        IF EXT_UNSIGNED ='1' THEN 
           S_OUT(31 downto 26) <= (OTHERS=>'0') ;
        ELSE
           S_OUT(31 downto 26) <= (OTHERS=>S_IN(25)) ;
        END IF;   
        S_OUT (26-1 DOWNTO 0)<= S_IN(26-1 DOWNTO 0);  
     ELSE 
        IF EXT_UNSIGNED ='1' THEN 
           S_OUT(31 downto 16) <= (OTHERS=>'0') ;
        ELSE
           S_OUT(31 downto 16) <= (OTHERS=>S_IN(16-1)) ;
        END IF;  
         S_OUT (16-1 DOWNTO 0)<= S_IN(16-1 DOWNTO 0);      
     END IF;   
  end process;
  
END BEHAVIOR;
