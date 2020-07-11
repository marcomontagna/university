library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Uart_CU_TX is
Port( start:IN std_logic;
     Reset_macchina:IN std_logic;
	  CLOCK_50 :IN std_logic;
	  Rst1,Rst2,Reset_data:OUT std_logic;
	  Shift_data :OUT std_logic;
	   En_data: OUT std_logic;
		Inc1,Inc2,Done: OUT std_logic;
		TC1,TC2:IN std_logic	
		);
end Uart_CU_TX;

architecture Master_Behave of Uart_CU_TX is
Type State_Type is (Reset_state,Before_Data_state,Data_state,Shift_Data_state,End_state,After_shift_state);
signal Present_state, Next_state: State_type;
begin
process(Present_state,TC1,TC2,start)

begin
case Present_state is

      when Reset_state=>
		if(start='1') then
		Next_state<=Before_Data_state;
		ELSE Next_state<=Reset_state;
 	   end if;		
		
      when Before_Data_state =>--
		Next_State<=Data_State;
		
		when Data_State=> if(TC1='1') then
		Next_state<=Shift_Data_state;		     
		else Next_state<=Data_State;
		end if;
		
	   When Shift_Data_state=>
		Next_state<=After_shift_state;																		  
																		  
		when After_shift_state => 
		if(TC2='1') then 
		Next_state<=End_State;		     
		else Next_state<=Data_State;
		end if;			
		
		when End_state=>  Next_state<=Reset_state;
	   
		when others => next_state<=reset_state;
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
Rst1<='1';Rst2<='1';Reset_data<='1';Shift_data<='0';
En_data<='0';Inc1<='0';Inc2<='0'; Done<='0';
case Present_state is

      when Reset_state=> 
		Rst1<='0';Rst2<='0';Reset_data<='0';
		
		when Before_Data_state => --carico nello shift register il dato da inviare fuori
		En_data<='1';	--facendo così carico anche uno zero nell'lsb dello shifter, invierò quindi
		--uno zero che durerà un colpo di clock in più del necessario. commetto un errore sistematico
		--dello 0.23% su tutti i bit successivi che saranno traslati di un colpo di clock.
		--è ignorabile.
				
		when Data_State=>--abilito contatore che conta fino a 434
		Inc1<='1';	
		
		When Shift_Data_state=> 
		Shift_Data<='1';Inc2<='1';		
				
		when After_shift_state=> 
		Inc2<='0';Shift_Data<='0';
		
		when End_state=>
		Done<='1';		
		
end case;
end process;
end Architecture;