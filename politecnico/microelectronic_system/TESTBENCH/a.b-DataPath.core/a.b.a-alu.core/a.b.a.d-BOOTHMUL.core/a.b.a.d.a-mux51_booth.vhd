library IEEE;
use IEEE.std_logic_1164.all;

entity mux51_booth is
  
  generic (
    NUMBIT : integer := 32);
  port (
    A   : in std_logic_vector(2*NUMBIT-1 downto 0);
    B   : in std_logic_vector(2*NUMBIT-1 downto 0);
    C   : in std_logic_vector(2*NUMBIT-1 downto 0);
    D   : in std_logic_vector(2*NUMBIT-1 downto 0);
    E   : in std_logic_vector(2*NUMBIT-1 downto 0);
    SEL : in std_logic_vector(2 downto 0);
    Y: out std_logic_vector(2*NUMBIT-1 downto 0));

end mux51_booth;


architecture behaviour of mux51_booth is
    begin
	process(A, B, C, D, E, SEL)
	begin
	   --case SEL is
	     --  when "000" => Y <= A; --0
  	     --  when "001" => Y <= B; --A
	     --  when "010" => Y <= B; --A
	     --  when "011" => Y <= D; -- 2A
	     --  when "100" => Y <= E; -- -2A
	     --  when "101" => Y <= C; -- -A
             --  when "110" => Y <= C; -- -A
	     --  when "111" => Y <= A; --0
              -- when others => Y <= A;
     	--end case;

		if SEL = "000" then Y <= A;
		elsif SEL = "001" then Y <= B;
		elsif SEL = "010" then Y <= B;
		elsif SEL = "011" then Y <= D;
		elsif SEL = "100" then Y <= E;
		elsif SEL = "101" then Y <= C;
		elsif SEL = "110" then Y <= C;
		elsif SEL = "111" then Y <= A;
		else Y <= A;
		end if;
	end process;

end behaviour;
  
