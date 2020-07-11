LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity testbench is
	
end testbench;

architecture beh of testbench is 
	component UART_RX is 
   PORT(
	Start_RX:OUT std_logic;
	Reset :In std_logic;
Data_In: In std_logic;
         CLOCK_50 :IN std_logic;
			Q: OUT std_logic_vector(7 downto 0);
			Done: OUT std_Logic);
end  component;

	signal risfinale : std_logic_vector(7 downto 0);
	signal data: std_logic;
	signal clk, done,rst,s: std_logic;

begin	
	uut: uart_rx PORT MAP (s,rst,data, clk, risfinale, done);
	
	process 
	begin
		clk <='1';
		wait for 10 ns;
		clk <='0';
		wait for 10 ns;
	end process;

  process 
  begin 
  rst<='0';
wait for 60 ns;
rst<='1';
  data<='0';
  wait for 8680 ns;
  data<='0';
  wait for 8680 ns;
  data<='0';
  wait for 8680 ns;
  data<='0';
  wait for 8680 ns;
  data<='0';
  wait for 8680 ns;
  data<='1';
  wait for 8680 ns;
  data<='1';
  wait for 8680 ns;
  data<='1';
  wait for 8680 ns;
  data<='1';
  wait for 8680 ns;
  data<='1';
  wait for 8680 ns;
  wait;
end process;
  end beh;