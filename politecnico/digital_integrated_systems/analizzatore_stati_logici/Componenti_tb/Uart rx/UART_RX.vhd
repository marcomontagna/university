library ieee;
use ieee.std_logic_1164.all;

entity UART_RX is 
   PORT(
			Start_RX:OUT std_logic;
			Reset :In std_logic;
			Data_In: In std_logic;
         CLOCK_50 :IN std_logic;
			Q: OUT std_logic_vector(7 downto 0);
			Done: OUT std_Logic);
end entity UART_RX;

Architecture link of UART_RX is
component Uart_rx_datapath is
Port(
     
	  CLOCK_50 :IN std_logic;
	  D:IN std_logic;
	  Rst1,Rst2,Rst3,Reset_start,Reset_data,Rst_reg:IN std_logic;
	  Shift_start,Shift_data :IN std_logic;
	   En_start,En_data,en_reg_q: IN std_logic;
		Inc1,Inc2,Inc3: In std_logic;
		TC1,TC2,TC3 :OUT std_logic;
		Start:OUT std_logic;
		Q: OUT std_logic_vector(7 downto 0);
		stop_bit:OUT std_logic
		
		);
end component;
component Uart_rx_CU is
Port( stop_bit : IN std_logic;
	  Reset_macchina :IN std_logic;
	  CLOCK_50 :IN std_logic;
	  Rst1,Rst2,Rst3,Reset_start,Reset_data,Rst_reg:OUT std_logic;
	  Shift_start,Shift_data :OUT std_logic;
	   En_start,En_data,en_reg_q: OUT std_logic;
		Inc1,Inc2,Inc3,Done: OUT std_logic;
		TC1,TC2,TC3 :IN std_logic;
		Start:IN std_logic;
		Start_RX:OUT std_logic
		
		);
end component;
signal Rst1s,Rst2s,Rst3s,Reset_starts,Reset_datas,Rst_regs,Shift_starts,Shift_datas,En_starts,En_datas: std_logic;
signal Inc1s,Inc2s,Inc3s,TC1s,TC2s,TC3s,Starts,stops, en_reg_qs: std_logic;

begin
datapath : Uart_rx_datapath port map(CLOCK_50,Data_in,Rst1s,Rst2s,Rst3s,Reset_starts,Reset_datas,Rst_regs,Shift_starts,Shift_datas,En_starts,En_datas,
                                   en_reg_qs,Inc1s,Inc2s,Inc3s,TC1s,TC2s,TC3s,Starts,Q,stops);											  
CU :Uart_rx_CU port map(stops,reset,CLOCK_50,Rst1s,Rst2s,Rst3s,Reset_starts,Reset_datas,Rst_regs,Shift_starts,Shift_datas,En_starts,En_datas,
                                   en_reg_qs,Inc1s,Inc2s,Inc3s,Done,TC1s,TC2s,TC3s,Starts,Start_RX);
											  
end architecture;											  