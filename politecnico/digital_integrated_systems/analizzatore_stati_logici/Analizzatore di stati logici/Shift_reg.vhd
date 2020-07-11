LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all; 
 
ENTITY Shift_reg IS  
	GENERIC ( N : integer :=4 );  
	PORT (D            : IN std_logic;   
		   Clock_50, Reset,Sh,En : IN  STD_LOGIC;   
		   Q             : OUT std_logic_vector(N-1 DOWNTO 0)); 
END Shift_reg; 
 
ARCHITECTURE Behavior OF Shift_reg IS 
signal t : std_logic_vector (N-1 downto 0);
BEGIN  
	PROCESS (Clock_50, Reset)  
	BEGIN   
		IF (Reset = '0') THEN    
			t<= (OTHERS => '1');
		ELSIF (Clock_50'EVENT AND Clock_50 = '1') THEN
		if(En='1') then
		if(Sh='1') then
		   t(N-2 downto 0)<=t(N-1 downto 1);
			t(N-1) <= D; 
		   	
		end if;	
		END IF;
	end if;

		
	END PROCESS; 
		Q<=t;
	
END Behavior;
