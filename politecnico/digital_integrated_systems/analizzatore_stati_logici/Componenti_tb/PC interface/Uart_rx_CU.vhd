library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Uart_rx_CU is
Port( 
		stop_bit : IN std_logic;
		Reset_macchina:IN std_logic;
		CLOCK_50 :IN std_logic;
		Rst1,Rst2,Rst3,Reset_start,Reset_data,Rst_reg:OUT std_logic;
		Shift_start,Shift_data :OUT std_logic;
	   En_start,En_data,en_reg_q: OUT std_logic;
		Inc1,Inc2,Inc3,Done: OUT std_logic;
		TC1,TC2,TC3 :IN std_logic;
		Start:IN std_logic;
		Start_RX:OUT std_logic	
		
		);
end Uart_rx_CU;

architecture Master_Behave of Uart_rx_CU is
Type State_Type is (Reset_state,Start_state,Shift_Start_state,Data_state,Shift_Data_state,End_state,Enable_Start_state,INC3_state, Stop_bit_state);
signal Present_state, Next_state: State_type;
begin
process(Present_state,TC1,TC3,TC2,Start,stop_bit)

begin
case Present_state is
      when Reset_state=> Next_state<=Start_state;	                                                 
		                                  
		when Start_State=> 
		if(TC1='1') then 
		Next_state<=Shift_Start_state;
		else Next_state<=Start_State;
		end if;
		
	   When Shift_Start_state=> 
		Next_state<=Enable_Start_state;
																		  																		  
		when Enable_Start_state =>
		if(start='1') then 
		Next_state<=Data_state;
		else Next_state<=Start_State;
		end if;														  
		
		when Data_state=> 
		if( TC2='1') then 
		Next_state<=INC3_state;
		else Next_state<=Data_state;
		end if;	
		                                                    															  
		when INC3_state=> 	
		Next_state<=Shift_Data_state;
		
		when Shift_Data_state=>
		if(TC3='1')then 
		Next_state<=Stop_bit_state;
		else Next_state<=Data_state;
		end if; 
		
		when Stop_bit_state=>
		if(stop_bit='1')then 
		Next_state<=End_state;
		else Next_state<=Reset_state;
		end if; 																  
																		  
		when End_state=>  
		Next_state<=Reset_state;
	   
		when others => 
		next_state<=reset_state;
		
end case;
end process;

Process(Clock_50,Reset_macchina)
begin
     if(Reset_macchina='0') then
	  Present_state<=reset_state;
     elsif(clock_50'event and clock_50='1') then
     Present_state<=Next_state;
	  end if;
end process;

Process(Present_state)
begin
Rst1<='1';Rst2<='1';Rst3<='1';Reset_start<='1';Reset_data<='1'; Shift_start<='0';Shift_data<='0';
En_start<='0';En_data<='0';Inc1<='0';Inc2<='0';Inc3<='0'; Done<='0';Start_RX<='0'; en_reg_q<='0';
Rst_reg<='1';
case Present_state is

      when Reset_state=>
		Rst1<='0';Rst2<='0';Rst3<='0';Reset_start<='0';Reset_data<='0';
				
		when Start_State=>
		En_start<='1';Inc1<='1';	
		
		When Shift_Start_state=>
		Shift_start<='1';En_start<='1';
		
		when Enable_Start_state=>
		En_start<='1';
		
		when Data_state=>
		En_data<='1';Inc2<='1';	start_RX<='1';
		
		when INC3_state=>
		Inc3<='1';Shift_data<='1';En_data <='1';
		
		when Shift_Data_state=> 
		En_data <='1';
		
		when Stop_bit_state=> 
		En_data <='1'; Rst_reg<='0';
			
		when End_state=> 
		Done<='1'; en_reg_q<='1';	
		
end case;
end process;
end Architecture;
