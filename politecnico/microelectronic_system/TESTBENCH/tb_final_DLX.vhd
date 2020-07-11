library ieee;
use ieee.std_logic_1164.all;
use work.globals.all;

entity tb_final_DLX is
end tb_final_DLX;

architecture beh of tb_final_DLX is

component complete_DLX is
  port (
    Clk : in std_logic;
    Rst : in std_logic -- active low
);                
end component;
 signal CLK                : std_logic := '0';   -- Clock
  signal RST                : std_logic;    -- Reset : Active-Low

begin

 Clk <= not Clk after 1 ns;
  Rst <= '0', '1' after 0.5 ns;
  
  dlx_instance: complete_DLX port map(clk, rst);
    
end beh;