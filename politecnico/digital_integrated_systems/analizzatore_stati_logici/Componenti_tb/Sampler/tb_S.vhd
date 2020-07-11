LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity testbench_sampler is
	
end testbench_sampler;



architecture beh of testbench_sampler is 
component sampler IS
	PORT (input, clk, sample, rst_as_n : IN STD_LOGIC;
			D: BUFFER STD_LOGIC;
			P: OUT STD_LOGIC);
END component;


	signal data,clk,enable,rst: std_logic;
	signal G,Q: std_logic;

begin	
	uut: sampler PORT MAP (data,clk,enable,rst,Q,G);
	
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
wait for 30 ns; --gestione reset
rst<='1';

--caso P4
data<='1';
enable<='1';
wait for 20 ns;
data<='0';
enable<='0';
wait for 100 ns;
data<='0';
enable<='1';
wait for 20 ns;
data<='0';
enable<='0';
wait for 50 ns;
data<='1';  
enable<='0';
wait for 22 ns;
data<='0';--glitch
enable<='0';
wait for 18 ns;
data<='1';
enable<='1';
wait for 20 ns;
data<='1';
enable<='0';
wait for 100 ns;
data<='0';
enable<='1';
wait for 20 ns;
data<='0';
enable<='0';
wait for 100 ns;

--caso p1

data<='0';
enable<='1';
wait for 20 ns;

data<='0';
enable<='0';
wait for 80 ns;

data<='1';  --glitch
enable<='0';
wait for 10 ns;

data<='0';
enable<='0';
wait for 10 ns;

data<='0';
enable<='1';
wait for 20 ns;

data<='0';
enable<='0';
wait for 100 ns;

--caso p2

data<='0';
enable<='1';
wait for 20 ns;

data<='0';
enable<='0';
wait for 30 ns;

data<='1';
enable<='0';
wait for 70 ns;

data<='1';
enable<='1';
wait for 20 ns;

data<='1';
enable<='0';
wait for 100 ns;

data<='1';
enable<='1';
wait for 20 ns;

data<='1';
enable<='0';
wait for 25 ns;

data<='0'; 
enable<='0';
wait for 10 ns;

data<='1';  --glitch
enable<='0';
wait for 25 ns;

data<='0'; 
enable<='0';
wait for 40 ns;

data<='0';
enable<='1';
wait for 20 ns;

data<='0';
enable<='0';
wait for 20 ns;


data<='1';
enable<='0';
wait for 80 ns;

--caso p3

data<='1';
enable<='1';
wait for 20 ns;

data<='1';
enable<='0';
wait for 60 ns;

data<='0';  --glitch
enable<='0';
wait for 5 ns;

data<='1';
enable<='0';
wait for 35 ns;

data<='1';
enable<='1';
wait for 20 ns;

data<='1';
enable<='0';
wait for 100 ns;


















 wait;
end process;
  end beh;

