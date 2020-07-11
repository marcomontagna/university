package pack2 is
   function log2_function(A: integer) return integer;
 end;

package body pack2 is
 function log2_function (A: integer) return integer is
  begin
    for I in 1 to 30 loop  -- Works for up to 32 bit integers
      if(2**I > A) then return(I-1);
      end if;
    end loop;
    return(30);
  end function;
 end package body;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
--use WORK.all;
use work.pack2.all;

entity register_file is
generic (NBIT: integer := 32;
	row: integer:= 32);
 port ( CLK: 		IN std_logic;
         RESET: 	IN std_logic;
	 ENABLE: 	IN std_logic;
	 RD1: 		IN std_logic;
	 RD2: 		IN std_logic;
	 WR: 		IN std_logic;
	 ADD_WR: 	IN std_logic_vector(log2_function(row)-1 downto 0); -- devo ancora scegliere la dimensione del rf
	 ADD_RD1: 	IN std_logic_vector(log2_function(row)-1 downto 0);
      	 ADD_RD2: 	IN std_logic_vector(log2_function(row)-1 downto 0);
	 DATAIN: 	IN std_logic_vector(NBIT-1 downto 0);
    	 OUT1: 		OUT std_logic_vector(NBIT-1 downto 0);
	 OUT2: 		OUT std_logic_vector(Nbit-1 downto 0));
end register_file;

architecture A of register_file is
	
	--constant bits: integer := 32; -- numero sia di bit che di righe nel rf
        -- suggested structures
        subtype REG_ADDR is natural range 0 to row-1; -- using natural type, devo scegliere la dimensione
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(NBIT-1 downto 0);
        
	signal REGISTERS : REG_ARRAY; 

	
begin 
-- write your RF code
  rf_proc: process (reset, enable, wr, rd1, rd2, add_rd2, add_rd1, add_wr, datain)
  begin  -- process rf_proc
    
  -- if CLK'event and CLK = '1' then  -- rising clock edge
     if RESET ='0' then                --we choose a reset active low
     OUT1<=(others=>'0');
     OUT2<=(others=>'0');
       for i in 0 to 31 loop -- devo scegliere la dimensione qui
         REGISTERS(i)<= (others=>'0');
       end loop;
     elsif ENABLE='1' then              --we use if scorrelated to have
                                        --simultaneous op
       
       if WR='1' then
         REGISTERS(to_integer(unsigned(ADD_WR)))<=DATAIN;
       end if;
       
      if RD1='1' then
         OUT1<=REGISTERS(to_integer(unsigned(ADD_RD1)));
       end if;
      if RD2='1' then
         OUT2<=REGISTERS(to_integer(unsigned(ADD_RD2)));
       end if;
             
        else
          OUT1<=(others=>'0');
          OUT2<=(others=>'0');
     -- end if;
    end if;
  end process rf_proc;

end A;

----


configuration CFG_RF_BEH of register_file is
  for A
  end for;
end configuration;
