library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Uart_rx_datapath is
Port(
     
	  CLOCK_50 :IN std_logic;
	  D:IN std_logic;
	  Rst1,Rst2,Rst3,Reset_start,Reset_data,Rst_reg:IN std_logic;
	  Shift_start,Shift_data :IN std_logic;
	   En_start,En_data,en_reg_q: IN std_logic;
		Inc1,Inc2,Inc3: In std_logic;
		TC1,TC2,TC3 :OUT std_logic;
		Start:OUT std_logic;
		Q: OUT std_logic_vector(7 downto 0);
		stop_bit:OUT std_logic
		);
end Uart_rx_datapath;

Architecture path of Uart_rx_datapath is

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

COMPONENT DATA_REGISTER
GENERIC (N:INTEGER);
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato in ingresso
DATA_REG_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0) --dato in uscita
);
END COMPONENT;

component Shift_reg IS  
	GENERIC ( N : integer :=4 );  
	PORT (D            : IN std_logic;   
		   Clock_50, Reset,Sh,En : IN  STD_LOGIC;   
		   Q             : OUT std_logic_vector(N-1 DOWNTO 0)); 
			
END  component;
component D_FF_UART IS
	PORT (sh,input, clock, enable, rst_sy_n: IN STD_LOGIC;
			Q: OUT STD_LOGIC);
END component;
signal s:std_logic;
signal uscita1 : std_logic_vector (5 downto 0);
signal uscita2 : std_logic_vector (8 downto 0);
signal uscita3 : std_logic_vector (3 downto 0);
signal uscita_start,shift_reg_out : std_logic_vector (7 downto 0);
begin
counter_54 : counter generic map(N=>6) port map ( CLOCK_50, Rst1, Inc1,"110110",uscita1,TC1);
counter_8 : counter generic map(N=>9) port map ( CLOCK_50, Rst2, Inc2,"110110010",uscita2,TC2);
counter_9 : counter generic map(N=>4) port map ( CLOCK_50, Rst3, Inc3,"1001",uscita3,TC3); --così conta fino a 9

REG_START : Shift_reg generic map(N=>8) port map ( D,CLOCK_50 ,Reset_start,Shift_start,En_start,uscita_start);

Start<=(not(uscita_start(4)) and not(uscita_start(5)) and not(uscita_start(6)) and not(uscita_start(7)) 
and uscita_start(0)and uscita_start(1) and uscita_start(2) and uscita_start(3));

REG_DATA : Shift_reg generic map(N=>8) port map ( s,CLOCK_50 ,Reset_data,Shift_data,En_data,shift_reg_out);

DATA_OUT : DATA_REGISTER
generic map (N=>8)
port map(en_reg_q,CLOCK_50,Rst_reg,shift_reg_out,Q);

STOP :  D_FF_UART port map (shift_data,D,clock_50,en_data,reset_data,s);
stop_bit<=s;

end path;
