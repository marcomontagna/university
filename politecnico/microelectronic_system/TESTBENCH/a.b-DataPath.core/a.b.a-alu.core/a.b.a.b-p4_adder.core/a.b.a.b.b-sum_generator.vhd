library ieee;
use ieee.std_logic_1164.all;
--use WORK.constants.all;

entity sum_generator is
  
  generic (
    N : integer := 32;
	 N_carry : integer := 4);

  port (
    A   : in  std_logic_vector(N-1 downto 0);
    B   : in  std_logic_vector(N-1 downto 0);
    Ci  : in  std_logic_vector(N/N_carry downto 0);
                                        -- but I will use only the carry multiple of 4 plus c(0)
    Sum : out std_logic_vector(N-1 downto 0));

end sum_generator;


architecture behaviour of sum_generator is
component carry_select
  generic (
    N : integer);                       -- for the pentium 4 I use N = 4
  port (
    A   : in  std_logic_vector(N-1 downto 0);
    B   : in  std_logic_vector(N-1 downto 0);
    Cin : in  std_logic;
    S   : out std_logic_vector(N-1 downto 0));
end component;

begin  -- behaviour

  blockgen: for u in 0 to  (N/N_carry)-1  generate --N_carri=4
    CBLOCk : carry_select generic map (N => N_carry)
      port map (A=>A(u*N_carry+N_carry-1 downto u*N_carry), B=>B(u*N_carry+N_carry-1 downto u*N_carry),Cin => Ci(u), S => Sum(u*N_carry+N_carry-1 downto u*N_carry));
  end generate blockgen;

  

end behaviour;
