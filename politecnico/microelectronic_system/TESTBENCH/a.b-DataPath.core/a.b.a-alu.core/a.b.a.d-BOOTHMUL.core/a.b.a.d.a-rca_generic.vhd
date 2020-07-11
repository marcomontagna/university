library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity RCA_GEN is
  
  generic (
    NUMBIT  : INTEGER := 32);

  port (
    A  : in     std_logic_vector(2*NUMBIT-1 downto 0);
    B  : in     std_logic_vector(2*NUMBIT -1 downto 0);
    Ci : in     std_logic;
    S  : buffer std_logic_vector(2*NUMBIT-1 downto 0);
    Co : out    std_logic);

end RCA_GEN;

architecture structural of RCA_GEN is
  component FA
    port (
      A  : in  std_logic;
      B  : in  std_logic;
      Ci : in  std_logic;
      S  : out std_logic;
      Co : out std_logic);
  end component;

  signal CTMP : std_logic_vector(2*NUMBIT downto 0);
  signal STMP : std_logic_vector(2*NUMBIT-1 downto 0);
  

begin  -- structural
  
  CTMP(0)<= Ci;
  S<=STMP;
  Co<=CTMP(NUMBIT);

  gen_fa: for i in 1 to 2*NUMBIT generate
    fai : FA
      port map (
        A  => A(i-1),
        B  => B(i-1),
        Ci => CTMP(i-1),
        S => STMP (i-1),
        Co => CTMP(i));
  end generate gen_fa;
  

end structural;


configuration CFG_RCA_GEN_STRUCTURAL of RCA_GEN is
  for STRUCTURAL 
      for all : FA
        use configuration WORK.CFG_FA_BEHAVIORAL;
      end for;
  end for;
end CFG_RCA_GEN_STRUCTURAL;
