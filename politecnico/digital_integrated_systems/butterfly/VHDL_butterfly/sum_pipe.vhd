-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity sum_pipe is
GENERIC ( N : integer :=49 ); 
port 
   (
      a : in signed (N-1 downto 0);
      b : in signed  (N-1 downto 0);
		w,en,rst,clock, verso_sommatore: in std_logic;
      result : out signed  (N-1 downto 0)
   );

end sum_pipe;

architecture rtl of sum_pipe is
component DATA_REGISTER IS
GENERIC (N:INTEGER);
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN signed((N-1) DOWNTO 0);	--dato in ingresso
DATA_REG_OUT	:	OUT signed((N-1) DOWNTO 0)
); --dato in uscita
END component;
signal p :signed (N-1 downto 0);
begin
	process(a,b,w, verso_sommatore)
	begin
	if(w='1') then
   p <= a + b;
	else
		if (verso_sommatore = '0') then
			p<= a-b;
		elsif (verso_sommatore = '1') then
			p <= b-a;
		end if;
	end if;
	end process; 
pipe : DATA_REGISTER generic map(N=>49) port map(en,clock,rst,p,result);

end rtl;