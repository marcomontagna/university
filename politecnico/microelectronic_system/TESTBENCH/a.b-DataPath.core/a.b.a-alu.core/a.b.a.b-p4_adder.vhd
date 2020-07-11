package pack is
   function lg2(A: integer) return integer;
 end;

package body pack is
 function lg2(A: integer) return integer is
  begin
    for I in 1 to 30 loop  -- Works for up to 32 bit integers
      if(2**I > A) then return(I-1);
      end if;
    end loop;
    return(30);
  end function;
 end package body;


library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
--use WORK.constants.all;
use WORK.pack.all;
	
entity p4_adder is
  generic (
    N : integer := 32;
	 N_carry : integer :=4 );
	 
	 port( A: in std_logic_vector( N-1 downto 0);
		B :in std_logic_vector( N-1 downto 0);
		Cin : in std_logic;
		SUM : out std_logic_vector(N-1 downto 0));
end p4_adder;

architecture beh of p4_adder is

component sparse_tree_carry_gen
  
  generic (
    N : integer := lg2(N));

  port (
    A    : in  std_logic_vector(2**N -1 downto 0);
    B    : in  std_logic_vector(2**N -1 downto 0);
    C0   : in  std_logic;
    Cout : out std_logic_vector(2**(N)/N_carry-1 downto 0));

end component;

component sum_generator 
  
  generic (
    N : integer := N;
	 N_carry : integer := N_carry);

  port (
    A   : in  std_logic_vector(N-1 downto 0);
    B   : in  std_logic_vector(N-1 downto 0);
    Ci  : in  std_logic_vector(N/N_carry downto 0);
                                        -- but I will use only the carry multiple of 4 plus c(0)
    Sum : out std_logic_vector(N-1 downto 0));

end component;

signal carry: std_logic_vector(N/N_carry-1 downto 0);
signal carryin: std_logic_vector(N/N_carry downto 0);
signal notb, cin_ext: std_logic_vector(31 downto 0);

begin
   sparsetree:  sparse_tree_carry_gen generic map (lg2(N))
	port map(A, notb, cin, carry);

	carryin<=carry&Cin;
	cin_ext<=(others=>cin);
	
	notb<= B xor cin_ext;
	sumgen: sum_generator generic map (N)
	port map( A, notb, carryin, Sum);

end beh;
