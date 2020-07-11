LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all; 
 
ENTITY Shift_reg_PISO IS  
	GENERIC ( N : integer :=4 );  
	PORT (D            : IN std_logic_vector(N-1 DOWNTO 0); 
	
		   Clock_50, Reset,Sh,En : IN  STD_LOGIC;   
		   Q             : OUT std_logic); 
END Shift_reg_PISO; 
 
ARCHITECTURE Behavior OF Shift_reg_PISO IS 
signal t : std_logic_vector (N+1 downto 0):=(others=>'0');
BEGIN  
	PROCESS (Clock_50, Reset)  
	BEGIN   
		IF (Reset = '0') THEN 
		t<=(others=>'1');
		
		ELSIF (Clock_50'EVENT AND Clock_50 = '1') THEN
		if(En='1') then
		--t(N+1)<='1'; 
		t(N downto 1)<=D;
		t(0)<='0';
		elsif(Sh='1') then
		 
		 t(N downto 0)<=t(N+1 downto 1);
		 t(N+1)<='1';
			 
		   	
		end if;	
	end if;
	
	 	
	END PROCESS;
Q<=t(0);	
END Behavior;