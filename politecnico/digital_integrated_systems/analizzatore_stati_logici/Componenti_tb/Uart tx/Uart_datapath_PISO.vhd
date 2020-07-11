library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Uart_datapath_PISO is
Port(
     
	  CLOCK :IN std_logic;
	  D:IN std_logic_vector(7 downto 0);
	  Rst1,Rst2,Reset_data:IN std_logic;
	  Shift_data :IN std_logic;
	   En_data: IN std_logic;
		Inc1,Inc2: In std_logic;
		TC1,TC2:OUT std_logic;
		Q: OUT std_logic
		
		);
end Uart_datapath_PISO;

Architecture path of Uart_datapath_PISO is

component counter is
GENERIC ( N : integer :=9 );  
port (CLOCK_50 : in std_logic;
reset:in std_logic;
enable : in std_logic;
valore : in std_logic_vector (N-1 downto 0);
uscita : out std_logic_vector (N-1 downto 0);
TC : out std_logic
);
end  component;

component Shift_reg_PISO IS  
GENERIC ( N : integer :=4 );  
	PORT (
			D  : IN std_logic_vector(N-1 DOWNTO 0); 
		   Clock_50, Reset,Sh,En : IN  STD_LOGIC;   
		   Q             : OUT std_logic); 			
END  component;

signal uscita1 : std_logic_vector (8 downto 0);
signal uscita2 : std_logic_vector (3 downto 0);

begin

counter_434 : counter generic map(N=>9) port map ( CLOCK, Rst1, Inc1,"110110001",uscita1,TC1);

counter_10 : counter generic map(N=>4) port map ( CLOCK, Rst2, Inc2,"1010",uscita2,TC2);

REG_DATA : Shift_reg_PISO generic map(N=>8) port map ( D,CLOCK ,Reset_data,Shift_data,En_data,Q);

end path;