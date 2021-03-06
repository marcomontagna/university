library ieee;
use ieee.std_logic_1164.all;


entity sparse_tree_carry_gen_4bits is
port ( A :  std_logic_vector(3 downto 0);
		 B : std_logic_vector( 3 downto 0);
		 c_in:in std_logic;
		 P, G: out std_logic);
end sparse_tree_carry_gen_4bits;

architecture beh of sparse_tree_carry_gen_4bits is
 component PG
    port (
      A   : in  std_logic;
      B : in  std_logic;
      C : in std_logic;
		D : in std_logic;
      P : out std_logic;
      G : out std_logic);
  end component;
  
  component PGnet is 
	port( A, B, C: in std_logic;
		P, G: out std_logic);
  end component;

	 
	 signal P0, G0 : std_logic_vector(3 downto 0);
	 signal P1, G1 : std_logic_vector(1 downto 0);
         signal p00, g00: std_logic;
	 
begin
	
	
	P0(0)<=A(0) xor B(0);
	g00<= A(0) and B(0);
	
	G0(0)<= g00 or (P0(0) and c_in);

	step0: for i in 1 to 3 generate
	pg1: PGnet port map(A(i), B(i), '0', P0(i), G0(i));
	end generate;
	
	step1: for i in 0 to 1 generate
	pg2: PG port map(P0(i*2+1), P0(i*2), G0(i*2+1), G0(i*2), P1(i), G1(i));
	end generate;
	
	pgg: PG port map (P1(1), P1(0), G1(1), G1(0), P, G);
	
	
end beh;
	
	

