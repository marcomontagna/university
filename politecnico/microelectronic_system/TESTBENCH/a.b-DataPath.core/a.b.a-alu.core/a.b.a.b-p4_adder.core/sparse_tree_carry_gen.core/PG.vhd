library ieee;
use ieee.std_logic_1164.all;
  
  
  
  entity PG is
    port (
      A   : in  std_logic; --pik
      B : in  std_logic; --pk-1j
      C : in std_logic; --gik
		D : in std_logic; --gi-1j
      P : out std_logic; --pij
      G : out std_logic);
  end entity;
  
  
  architecture beh of PG is
  
  begin
  P <= A and B;
  G <= C or (A and D);
  
  end architecture;
  
