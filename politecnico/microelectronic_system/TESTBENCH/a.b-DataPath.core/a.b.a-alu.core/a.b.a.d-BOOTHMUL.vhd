library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity BOOTHMUL is
  
  generic (
    NBIT : integer := 32);
  port (
    A   : in std_logic_vector(NBIT-1 downto 0);
    B   : in std_logic_vector(NBIT-1 downto 0);
    P : out std_logic_vector(2*NBIT-1 downto 0));

end BOOTHMUL;

architecture behaviour of BOOTHMUL is

component mux51_booth
  generic (
    NUMBIT : integer := 32);
  port (
    A   : in std_logic_vector(2*NBIT-1 downto 0);
    B   : in std_logic_vector(2*NBIT-1 downto 0);
    C   : in std_logic_vector(2*NBIT-1 downto 0);
    D   : in std_logic_vector(2*NBIT-1 downto 0);
    E   : in std_logic_vector(2*NBIT-1 downto 0);
    SEL : in std_logic_vector(2 downto 0);
    Y: out std_logic_vector(2*NBIT-1 downto 0));

end component;

-- component sommatore 
component rca_gen
        generic (
          NUMBIT  : integer);
        port (
          A : in std_logic_vector(2*nbit -1 downto 0);
          B : in std_logic_vector(2*nbit -1 downto 0);
          Ci : in std_logic;
          S : buffer std_logic_vector(2*nbit -1 downto 0);
          Co : out std_logic);
                                        
      end component;


constant NUMBIT : integer:= 8; -- numero di bit parallelismo
type array_mux is array (0 to NUMBIT/2-1) of std_logic_vector(2*NUMBIT-1 downto 0);
-- type array_sum is array (0 to NUMBIT/2 -1) of std_logic_vector(2*NUMBIT-1 downto 0);
type array_sel is array (0 to NUMBIT/2-1) of std_logic_vector (2 downto 0);
signal B_c : std_logic_vector (NBIT downto 0):= (others=>'0'); -- valore di B concatenato allo 0 come convenzione
signal A_mux, B_mux, C_mux, D_mux, E_mux, Y_mux : array_mux; -- ingresso multiplexer 
--signal A_neg : std_logic_vector(NBIT-1 downto 0); -- ingresso A negato
signal sum : array_mux;
constant zeroC : std_logic_vector(NUMBIT-1 downto 0):= (others=>'0'); --concatenazione 0
signal sel_mux: array_sel;
signal Cout: std_logic; -- solo per rca serve√
signal temp: std_logic_vector (2*NUMBIT-1 downto 0);

begin
	-- concateno lo 0 all'inizio di B
	B_c <= B & '0';
	-- A_mux rimane sempre tutti 0
	A_mux(0) <= (others => '0');
	-- imposto uscite del primo mux dell'algoritmo
	B_mux(0) <= zeroC & A; -- A
	temp <= not(B_mux(0));
	C_mux(0) <= std_logic_vector(unsigned(temp+1)); -- -A
	D_mux(0) <= B_mux(0)(2*NUMBIT-2 downto 0) & '0'; -- +2A
	E_mux(0) <= C_mux(0)(2*NUMBIT-2 downto 0) & '0'; -- -2A
	sel_mux(0) <= B_c(2 downto 0);
	-- primo mux
	mux_primo: mux51_booth 
		generic map (NUMBIT)
		port map (A_mux(0), B_mux(0), C_mux(0), D_mux(0), E_mux(0), sel_mux(0), Y_mux(0));
	-- cosi' e' ingresso del primo sommatore
	sum(0) <= Y_mux(0);
	-- generate per algoritmo di booth
	gen_mul:
	for i in 1 to (NUMBIT/2-1) generate
		-- aggiorno tutti gli ingressi del mux ogni volta
		A_mux(i) <= (others => '0');
		B_mux(i) <= B_mux(i-1)(2*NUMBIT-3 downto 0) & "00"; -- A*4
		C_mux(i) <= C_mux(i-1)(2*NUMBIT-3 downto 0) & "00"; -- -A*4
		D_mux(i) <= D_mux(i-1)(2*NUMBIT-3 downto 0) & "00"; -- 2A*4
		E_mux(i) <= E_mux(i-1)(2*NUMBIT-3 downto 0) & "00"; -- -2A*4
		sel_mux(i) <= B_c(2*i+2 downto 2*i);
		
		mux_algoritmo: mux51_booth 
				generic map (NUMBIT)
				port map (A_mux(i),B_mux(i),C_mux(i), D_mux(i),E_mux(i),sel_mux(i),Y_mux(i));
		
		rca_acc: rca_gen
        		generic map (NUMBIT)
        		port map (sum(i-1), Y_mux(i), '0', sum(i), Cout);

	end generate gen_mul;
	P <= sum(NUMBIT/2 -1); -- salvo risultato finale
end behaviour;
  
