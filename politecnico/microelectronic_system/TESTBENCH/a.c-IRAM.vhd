library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity IRAM is
  generic (
    RAM_DEPTH : integer := 256;
    I_SIZE : integer := 8);
  port (
    Rst  : in  std_logic;
    Addr : in  std_logic_vector(32 - 1 downto 0);
    Dout : out std_logic_vector(31 downto 0)
    );

end IRAM;

architecture IRam_Bhe of IRAM is

  type RAMtype is array (0 to RAM_DEPTH-1) of  std_logic_vector(8- 1 downto 0);

  signal IRAM_mem : RAMtype;
  
  signal add1, add2, add3 : std_logic_vector(31 downto 0);

begin  -- IRam_Bhe
  
  add1<=addr+"00000000000000000000000000000001";
  add2<=addr+2;
  add3<=addr+3;
  

  Dout(31 downto 24) <= IRAM_mem(to_integer(unsigned(Addr)));
 Dout(23 downto 16) <= IRAM_mem(to_integer(unsigned(Add1)));
 Dout(15 downto 8) <= IRAM_mem(to_integer(unsigned(Add2)));
 Dout(7 downto 0 ) <= IRAM_mem(to_integer(unsigned(Add3)));

  -- purpose: This process is in charge of filling the Instruction RAM with the firmware
  -- type   : combinational
  -- inputs : Rst
  -- outputs: IRAM_mem
  FILL_MEM_P: process (Rst)
    file mem_fp: text;
    variable file_line : line;
    variable index : integer := 0;
    variable tmp_data_u : std_logic_vector(32-1 downto 0);
  begin  -- process FILL_MEM_P
    if (Rst = '0') then
      file_open(mem_fp,"testjump.asm.mem",READ_MODE);
      while (not endfile(mem_fp)) loop
        readline(mem_fp,file_line);
        hread(file_line,tmp_data_u);
      for i in 0 to 3 loop
        IRAM_mem(index+i) <= tmp_data_u(31-(i*8) downto 31-7-(i*8));       
      end loop;
     index := index + 4;
      end loop;
    end if;
  end process FILL_MEM_P;

end IRam_Bhe;
