-- algoritmo trovato online per lo svolgimento del logaritmo in base 2
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package log2_function is
	function log2(i : integer) return integer;
end package log2_function;

package body log2_function is
function log2(i : integer) return integer is
	variable temp : integer := i;
	variable final_value : integer := 1; 
begin
	temp := temp/2;
	while temp > 1 loop
		final_value := final_value + 1;
		temp := temp/2;
	end loop;
	return final_value;
end function log2;
end package body log2_function;
