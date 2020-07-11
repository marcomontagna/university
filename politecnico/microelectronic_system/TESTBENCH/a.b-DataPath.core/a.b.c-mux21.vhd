library IEEE;
use IEEE.std_logic_1164.all;

entity mux21 is
	generic (N: integer:=32);
  port (
    A   : in std_logic_vector(N-1 downto 0);
    B   : in std_logic_vector(N-1 downto 0);
    SEL : in std_logic;
    Y: out std_logic_vector(N-1 downto 0));
end mux21;


architecture behavioural of mux21 is
  
  begin  -- behaviour
      
 GEN1: for i in 0 to N-1 generate
  Y(i) <= (A(i) and not(SEL)) or (B(i) and SEL );
  end generate GEN1;

 end behavioural;
