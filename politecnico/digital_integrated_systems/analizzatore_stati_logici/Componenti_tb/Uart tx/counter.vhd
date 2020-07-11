library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
GENERIC ( N : integer :=9 );  
port (CLOCK_50 : in std_logic;
reset:in std_logic;
enable : in std_logic;
valore : in std_logic_vector (N-1 downto 0);
uscita : out std_logic_vector (N-1 downto 0);
TC : out std_logic
);
end counter;
architecture behaviour of counter is
begin
process(CLOCK_50)
 variable  tmp :INTEGER range 0 to 2**N;
 
begin
 IF (CLOCK_50 'EVENT AND CLOCK_50 = '1') THEN
	  if(reset='0') then
	   tmp:=0;
		TC<='0';
		else
		if( enable='1') then 
		
		if (tmp =to_integer(unsigned(valore))-1) then
		
		TC<='1';
		tmp:=0;
		elsif(tmp<to_integer(unsigned(valore))-1) then
		tmp:=tmp+1;
		TC<='0';
		else 
	   tmp :=0;
		TC<='0';
	   
		
		
			  
				 end if;
	  end if;
	  end if;
	  end if;
	  uscita<=std_logic_vector(to_unsigned(tmp,N));
		end process;
		end behaviour;