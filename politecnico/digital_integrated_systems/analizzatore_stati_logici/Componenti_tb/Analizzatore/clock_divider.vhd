--circuito di divisione del clock
--frequenze di campionamento possibili: 10MHz/2^prescaler
--10MHz, 5MHz, 2.5MHz, 1.25MHz, 625kHz, 312.5kHz, 156.25kHz, 78.125kHz, 39.063kHz, 19.531kHz
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY clock_divider IS
PORT 
(
RESET, CLOCK, ENABLE,LOAD_COUNT, DISABLE: IN STD_LOGIC;
PRESCALER_IN:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
TERMINAL_COUNT:BUFFER STD_LOGIC
);
END ENTITY;
ARCHITECTURE BEHAVIOR OF clock_divider IS

--componenti
COMPONENT COUNTER_NBIT IS
GENERIC (N:INTEGER);
PORT(
EN_COUNT, LOAD_COUNT,CLK,RESET	: IN STD_LOGIC;	--abilita conta, carica dato da cui iniziare a contare
COUNT_IN	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato da caricare in parallelo
COUNT_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0);
TC	:	OUT STD_LOGIC	--terminal count
);
END COMPONENT;

COMPONENT MUX_10_to_1 IS
PORT(
SEL	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);	--segnale di enable, reset e clock
DATA_0, DATA_1, DATA_2,DATA_3,DATA_4,DATA_5	:	IN STD_LOGIC;	--dato in ingresso
DATA_6, DATA_7, DATA_8, DATA_9 :	IN STD_LOGIC;	--dato in ingresso
DATA_OUT	:	OUT STD_LOGIC --dato in uscita
);
END COMPONENT;

COMPONENT FLIP_FLOP_D IS
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN STD_LOGIC;	--dato in ingresso
DATA_REG_OUT	:	OUT STD_LOGIC --dato in uscita
);
END COMPONENT;

COMPONENT DATA_REGISTER IS
GENERIC (N:INTEGER);
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato in ingresso
DATA_REG_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0) --dato in uscita
);
END COMPONENT;

SIGNAL DISABLE_DFF:STD_LOGIC; --segnale reset flip flop
SIGNAL LOAD_COUNT_10, DATA_OUT:STD_LOGIC;	
SIGNAL MASTER_ENABLE:STD_LOGIC; --segnale abilitazione contatore
SIGNAL CNT3_OUT:STD_LOGIC_VECTOR(11 DOWNTO 0); --uscita derivatore clock 10 MHz
SIGNAL CNT_PRESCALER_OUT:STD_LOGIC_VECTOR(9 DOWNTO 0);	-- uscita contatore prescaler
SIGNAL PRESCALER:STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN 

DISABLE_DFF<= (NOT DISABLE) AND RESET;

prescaler_register:  DATA_REGISTER --registro in cui si salva il prescaler
generic map(N=>4)	--il prescaler arriva dalla pc interface e viene sentito quando lo
port map(LOAD_COUNT,CLOCK,RESET,PRESCALER_IN,PRESCALER);	--ordina la main fsm. 
--l'uscita di questo registro controlla il mux con cui si seleziona il terminal count desiderato

master_flip_flop: FLIP_FLOP_D	--questo flip flop è in grado di abilitare o disabilitare 
PORT MAP (ENABLE,CLOCK,DISABLE_DFF,'1',MASTER_ENABLE);

LOAD_COUNT_10<= DISABLE OR TERMINAL_COUNT OR LOAD_COUNT;

contatore_terminal_count_variabile: COUNTER_NBIT	--contatore da 12 bit per poter dividere 
GENERIC MAP (N=>12)	--correttamente il clock da 50MHz fino a 19kHz
PORT MAP (MASTER_ENABLE,LOAD_COUNT_10,CLOCK,RESET,"000000000000",CNT3_OUT(11 DOWNTO 0));

CNT_PRESCALER_OUT(0)<=MASTER_ENABLE AND CNT3_OUT(2); --10 MHZ

CNT_PRESCALER_OUT(1)<=MASTER_ENABLE AND CNT3_OUT(3) AND CNT3_OUT(0); --5MHZ

CNT_PRESCALER_OUT(2)<=MASTER_ENABLE AND CNT3_OUT(4) AND CNT3_OUT(1) AND CNT3_OUT(0); --2.5MHZ

CNT_PRESCALER_OUT(3)<=MASTER_ENABLE AND CNT3_OUT(5) AND CNT3_OUT(2) AND CNT3_OUT(1) AND CNT3_OUT(0); --1.25MHZ

CNT_PRESCALER_OUT(4)<=MASTER_ENABLE AND CNT3_OUT(6) AND CNT3_OUT(3)
							 AND CNT3_OUT(2) AND CNT3_OUT(1) AND CNT3_OUT(0); --625KHZ
										
CNT_PRESCALER_OUT(5)<=MASTER_ENABLE AND CNT3_OUT(7) AND CNT3_OUT(4) AND CNT3_OUT(3) 
							AND CNT3_OUT(2) AND CNT3_OUT(1) AND CNT3_OUT(0); --312.5KHZ

CNT_PRESCALER_OUT(6)<=MASTER_ENABLE AND CNT3_OUT(8) AND CNT3_OUT(5) AND CNT3_OUT(4)
							 AND CNT3_OUT(3) AND CNT3_OUT(2) AND CNT3_OUT(1) AND CNT3_OUT(0); --156.25KHZ

CNT_PRESCALER_OUT(7)<=MASTER_ENABLE AND CNT3_OUT(9) AND CNT3_OUT(6)AND CNT3_OUT(5)AND CNT3_OUT(4)
							 AND CNT3_OUT(3) AND CNT3_OUT(2) AND CNT3_OUT(1) AND CNT3_OUT(0);  --78.125KHZ

CNT_PRESCALER_OUT(8)<=MASTER_ENABLE AND CNT3_OUT(10) AND CNT3_OUT(7)AND CNT3_OUT(6)AND CNT3_OUT(5)
							 AND CNT3_OUT(4) AND CNT3_OUT(3) AND CNT3_OUT(2) AND CNT3_OUT(1) AND CNT3_OUT(0); --39.063KHZ

CNT_PRESCALER_OUT(9)<=MASTER_ENABLE AND CNT3_OUT(11) AND CNT3_OUT(8)AND CNT3_OUT(7)AND CNT3_OUT(6)AND CNT3_OUT(5)
						    AND CNT3_OUT(4) AND CNT3_OUT(3) AND CNT3_OUT(2) AND CNT3_OUT(1) AND CNT3_OUT(0); --19.531KHZ

clock_select: MUX_10_to_1
PORT MAP (PRESCALER, CNT_PRESCALER_OUT(0), CNT_PRESCALER_OUT(1), CNT_PRESCALER_OUT(2), CNT_PRESCALER_OUT(3),
			 CNT_PRESCALER_OUT(4), CNT_PRESCALER_OUT(5), CNT_PRESCALER_OUT(6), CNT_PRESCALER_OUT(7),
			 CNT_PRESCALER_OUT(8), CNT_PRESCALER_OUT(9), TERMINAL_COUNT);
	 
END BEHAVIOR;