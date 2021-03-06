library IEEE;
use IEEE.std_logic_1164.all;
--use WORK.constants.all;


entity mux21_generic is
  
  generic (
    NBIT : integer := 16);
   -- DELAY_MUX : Time := 3 ns);
  port (
    A   : in std_logic_vector(NBIT-1 downto 0);
    B   : in std_logic_vector(NBIT-1 downto 0);
    SEL : in std_logic;
    Y: out std_logic_vector(NBIT-1 downto 0));
end mux21_generic;


architecture behavioural of mux21_generic is
  
  begin  -- behaviour
      
 GEN1: for i in 0 to NBIT-1 generate
  Y(i) <= (A(i) and SEL) or (B(i)  and not(SEL) );
  end generate GEN1;

 end behavioural;
  
--  
--
--architecture structural of mux21_generic is 
--    component mux21
--      port (
--        A : in std_logic;
--        B : in std_logic;                 
--        S : in std_logic;
--        Y : out std_logic);
--    end component;
--    
--   begin  -- structural
--     
--    GEN: for i in 0 to NBIT-1 generate
--      mux_structural: mux21 port map (A(i), B(i), SEL, Y(i));  
--    end generate GEN;
--   
--   end structural;
   
--   
--   
--   configuration CFG_MUX21_GEN_BEHAVIORAL of mux21_generic is
--   
--     for behavioural
--     end for;
--       
--   end CFG_MUX21_GEN_BEHAVIORAL;
--   
--   
--   configuration CFG_MUX21_GEN_STRUCTURAL of mux21_generic is
--   
--     for structural
--       for all : mux21
--       use configuration WORK.CFG_MUX21_STRUCTURAL;
--       end for;
--     end for;
--   
--   end configuration;
