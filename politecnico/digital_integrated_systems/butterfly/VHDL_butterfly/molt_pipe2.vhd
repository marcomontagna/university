-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity molt_pipe2 is
GENERIC ( N : integer :=24 ); 
port 
   (  en1_molt,en2_molt,rst,clock: in std_logic;
      a : in signed (N-1 downto 0);
      b : in signed  (N-1 downto 0);
      result : out signed  (2*N-2 downto 0)
   );

end molt_pipe2;

architecture rtl of molt_pipe2 is
component DATA_REGISTER IS
GENERIC (N:INTEGER);
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN signed((N-1) DOWNTO 0);	--dato in ingresso
DATA_REG_OUT	:	OUT signed((N-1) DOWNTO 0)
); --dato in uscita
END component;
signal rs :signed(2*N-1 downto 0);
signal t,p :signed(2*N-2 downto 0);
begin
   
   rs <= a * b;
	t<=rs(2*N-2 downto 0);
	
pipe1 : DATA_REGISTER generic map(N=>47) port map(en1_molt,clock,rst,t,p);
pipe2 : DATA_REGISTER generic map(N=>47) port map(en2_molt,clock,rst,p,result);
end rtl;