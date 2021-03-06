LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity testbench_TX is
	
end testbench_TX;

architecture beh of testbench_TX is 
	component uart_tx is
	
   PORT( start_macchina :In std_logic;
	Reset :In std_logic;
         Data_In: In std_logic_vector(7 downto 0);
         CLOCK_50 :IN std_logic;
			Q: OUT std_logic;
			Done: OUT std_Logic);
end component;

	signal risfinale,s : std_logic;
	signal data: std_logic_vector(7 downto 0);
	signal reg: std_logic_vector(9 downto 0);
	signal clk, done,rst: std_logic;

begin	
	uut: uart_tx PORT MAP (s,rst,data, clk, risfinale, done);
	
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
wait for 60 ns;
s<='1';

  data<='0'&'1'&'0'&'1'&'0'&'1'&'0'&'1';
  reg(0)<=risfinale;
  --wait for 8820 ns;
  wait for 8680 ns;
s<='0';  
  reg(1)<=risfinale;
 -- wait for 8820 ns;
  wait for 8680 ns;
  
  reg(2)<=risfinale;
 -- wait for 8820 ns;
 wait for 8680 ns;
 
  reg(3)<=risfinale;
---  wait for 8820 ns;
wait for 8680 ns;

  reg(4)<=risfinale;
--  wait for 8820 ns;
wait for 8680 ns;

  reg(5)<=risfinale;
--  wait for 8820 ns;
wait for 8680 ns;

  reg(6)<=risfinale;
--  wait for 8820 ns;
wait for 8680 ns;

  reg(7)<=risfinale;
 -- wait for 8820 ns;
 wait for 8680 ns;
 
  reg(8)<=risfinale;
 -- wait for 8820 ns;
 wait for 8680 ns;
 
  reg(9)<=risfinale;
--  wait for 8820 ns;
wait for 8680 ns;

wait for 200 ns;
s<='1';

  data<='0'&'0'&'1'&'1'&'0'&'0'&'1'&'1';
  reg(0)<=risfinale;
  --wait for 8820 ns;
  wait for 8680 ns;
s<='0';  
  reg(1)<=risfinale;
 -- wait for 8820 ns;
  wait for 8680 ns;
  
  reg(2)<=risfinale;
 -- wait for 8820 ns;
 wait for 8680 ns;
 
  reg(3)<=risfinale;
---  wait for 8820 ns;
wait for 8680 ns;

  reg(4)<=risfinale;
--  wait for 8820 ns;
wait for 8680 ns;

  reg(5)<=risfinale;
--  wait for 8820 ns;
wait for 8680 ns;

  reg(6)<=risfinale;
--  wait for 8820 ns;
wait for 8680 ns;

  reg(7)<=risfinale;
 -- wait for 8820 ns;
 wait for 8680 ns;
 
  reg(8)<=risfinale;
 -- wait for 8820 ns;
 wait for 8680 ns;
 
  reg(9)<=risfinale;
--  wait for 8820 ns;
wait for 8680 ns;

  wait;
end process;
  end beh;