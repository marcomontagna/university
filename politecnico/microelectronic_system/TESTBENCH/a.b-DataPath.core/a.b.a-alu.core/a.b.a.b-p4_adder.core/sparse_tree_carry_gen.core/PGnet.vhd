library ieee;
use ieee.std_logic_1164.all;

entity PGnet is
port( A, B, C: in std_logic;
		P, G: out std_logic);
end entity;

architecture beh of PGnet is
begin
P<=A xor B;
G<= A and B;
end beh;
