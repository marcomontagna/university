-- progetto butterfly 2017/2018
-- corso sistemi digitali integrati, prof. Zamboni
-- Montagna Marco, Malacrino Andrea, Valpreda Emanuele
-- conditional sequential pla

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity conditional_sequential_pla is 
	port (
			clk, reset, start: in std_logic;
			output_microAR: out std_logic_vector( 4 downto 0));
end conditional_sequential_pla;

architecture behavior of conditional_sequential_pla is

component vector_register
GENERIC (N:INTEGER);
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN std_logic_vector((N-1) DOWNTO 0);	--dato in ingresso
DATA_REG_OUT	:	OUT std_logic_vector((N-1) DOWNTO 0) --dato in uscita
);
END component;

component vector_mux
GENERIC (N:INTEGER);
PORT(
SEL	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_1, DATA_2	:	IN std_logic_vector((N-1) DOWNTO 0);	--dato in ingresso
DATA_OUT	:	OUT std_logic_vector((N-1) DOWNTO 0)); --dato in uscita

END component;


component ROM_JUMP
	port (
			ADDR : in std_logic_vector (4 downto 0); -- address input
			DOUT : out std_logic_vector (5 downto 0)); -- data output
end component;

signal address: std_logic_vector (4 downto 0);
signal CC_validation: std_logic;
signal cc_next_address, cc_next_address_out: std_logic_vector (5 downto 0);
signal jmp_address, seq_address, mux_address: std_logic_vector (4 downto 0);
signal sel_status_pla: std_logic;
signal temp: std_logic;

begin

ROM_salti: ROM_JUMP PORT MAP (address, cc_next_address);
reg_cc_jmp: vector_register
	GENERIC MAP (N=>6)
	PORT MAP ('1', clk, reset, cc_next_address, cc_next_address_out);
microAR: vector_register
	GENERIC MAP (N=>5)
	PORT MAP ('1', clk, reset, mux_address, address);
cc_validation <= cc_next_address_out(5);
jmp_address <= cc_next_address_out(4 downto 0);
mux_seq_jmp: vector_mux
	GENERIC MAP (N=>5)
	PORT MAP (sel_status_pla, seq_address, jmp_address, mux_address);
output_microAR <= address; 

seq_address <= "00001" + address; -- somma 1 per indirizzo successivo
-- status pla è un segnale che si abilita in certe condizioni

status_pla: process(cc_validation, address, start)
	begin
		if (cc_validation = '1') then
			case address is
				when "00001" =>
					if (start = '0') then 
						temp <= '1'; -- se sono in idle e non ho ricevuto lo start allora salto di nuovo in idle
					else
						temp <= '0'; -- se no vado in sequenziale e comincio elaborazione
					end if;
				when "01001" =>
					if (start = '1') then 
						temp <= '1';
					else 
						temp <= '0';
					end if;
				when "01101" =>
					temp <= '1';
				when "10001" =>
					temp <= '1';
				when others =>
					temp <= '0';
			end case;
		else
			temp <= '0';
		end if;
	end process;
	
	sel_status_pla <= temp;
	end behavior;