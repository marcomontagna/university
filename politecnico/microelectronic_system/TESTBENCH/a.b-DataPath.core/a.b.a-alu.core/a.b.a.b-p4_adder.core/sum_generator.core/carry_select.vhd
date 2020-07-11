library ieee;
use ieee.std_logic_1164.all;
use WORK.globals.all;

entity carry_select is
  
  generic (N : Integer := 16);

  port (
    A  : in std_logic_vector(N-1 downto 0);
    B   : in std_logic_vector(N-1 downto 0);
    Cin : in std_logic;
    S   : out std_logic_vector(N-1 downto 0));

end carry_select;

architecture beh of carry_select is
    
  component RCA_GEN
    generic (
      NBIT  : integer);
   --   DRCAS : time;
     -- DRCAC : time);
    port (
      A  : in     std_logic_vector(NBIT-1 downto 0);
      B  : in     std_logic_vector(NBIT-1 downto 0);
      Ci : in     std_logic;
      S  : buffer std_logic_vector(NBIT-1 downto 0);
      Co : out    std_logic);    
  end component;


component mux21_generic
  generic (
    NBIT : integer);
  port (
    A   : in  std_logic_vector(NBIT-1 downto 0);
    B   : in  std_logic_vector(NBIT-1 downto 0);
    SEL : in  std_logic;
    Y   : out std_logic_vector(NBIT-1 downto 0));
end component;

signal S0,S1 : std_logic_vector(NBIT-1 downto 0);
signal sel : std_logic;
begin  -- beh
	sel <= not (Cin);
  RCA1 : RCA_GEN generic map ( NBIT  => N)--, DRCAS => 0 ns, DRCAC => 0 ns)
    port map ( A  => A, B  => B, Ci => '0', S  => S0);

  RCA2 : RCA_GEN generic map ( NBIT  => N)--, DRCAS => 0 ns, DRCAC => 0 ns)
    port map ( A  => A, B  => B, Ci => '1', S  => S1);

  MUX1 : mux21_generic generic map ( NBIT => N)
    port map ( A => S0, B => S1, SEL => sel,  Y => S);

end beh;
