--con le impostazioni attuali del clock_50, cio� 50 MHz eseguire la simulazione per 58ms



LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY Mem_int_tb IS
END ENTITY Mem_int_tb;
ARCHITECTURE TESTBENCH OF Mem_int_tb IS
  --segnali
SIGNAL START,RD_REQ,WR_REQ,READ_READY,CLOCK_50,RESET:STD_LOGIC; 
SIGNAL DATA_INPUT, DATA_OUTPUT,SRAM_DQ :STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL SRAM_ADDR,START_ADD_REG:STD_LOGIC_VECTOR(17 DOWNTO 0);
SIGNAL OUTPUT_VALID,START_ACK,RD_ACK,WR_ACK,MEM_WRITTEN,MEM_READ:STD_LOGIC;
SIGNAL SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N:STD_LOGIC;
SIGNAL ENABLE_GENERATORE,END_TRIGGER,TERMINAL_COUNT:STD_LOGIC;
--COMPONENTI  

COMPONENT Memory_Interface IS
PORT(
START,RD_REQ,WR_REQ,READ_READY,CLOCK_50,RESET	: IN STD_LOGIC;	--segnali ingresso memory_Interface
DATA_INPUT	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in ingresso dal sampler
DATA_OUTPUT	:	OUT STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in uscita dalla memory_Interface e in ingresso alla pc interface
SRAM_ADDR	:	OUT STD_LOGIC_VECTOR(17 DOWNTO 0);	--indirizzo in uscita verso la SRAM
SRAM_DQ	:	INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in uscita verso la SRAM
OUTPUT_VALID,START_ACK,RD_ACK,WR_ACK,MEM_WRITTEN,MEM_READ :OUT STD_LOGIC;	--segnale da mandare alla pc interface oppure alla maim FSM per indicare che c'Ã¨ un dato in uscita dalla mem
SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N: BUFFER  STD_LOGIC	);	--segnali controllo verso la SRAM 
END COMPONENT;

COMPONENT COUNTER_NBIT IS
GENERIC (N:INTEGER);
PORT(
EN_COUNT, LOAD_COUNT,CLK,RESET	: IN STD_LOGIC;	--abilita conta, carica dato da cui iniziare a contare
COUNT_IN	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato da caricare in parallelo
COUNT_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0);
TC	:	OUT STD_LOGIC	--terminal count
);
END COMPONENT;

COMPONENT DUT_handler IS
PORT(
   CLOCK_50:BUFFER STD_LOGIC;
OUTPUT_VALID,RD_ACK,WR_ACK,MEM_WRITTEN,MEM_READ,START_ACK :IN STD_LOGIC;
RESET, RD_REQ,WR_REQ,READ_READY,ENABLE_GENERATORE,START: BUFFER STD_LOGIC
);  
END COMPONENT;

BEGIN
  gestore_dut: DUT_handler
  PORT MAP (CLOCK_50,OUTPUT_VALID,RD_ACK,WR_ACK,MEM_WRITTEN,MEM_READ,START_ACK,RESET,
  RD_REQ,WR_REQ,READ_READY,ENABLE_GENERATORE,START );
    
  contatore_genera_dati: COUNTER_NBIT
  GENERIC MAP(N=>16)
  PORT MAP (WR_ACK,'0',CLOCK_50,RESET,"0000000000000000",DATA_INPUT,TERMINAL_COUNT);
   
 
  circuito:Memory_Interface
  PORT MAP (
START,RD_REQ,WR_REQ,READ_READY,CLOCK_50,RESET,
DATA_INPUT, DATA_OUTPUT,
SRAM_ADDR,
SRAM_DQ,
OUTPUT_VALID,START_ACK,RD_ACK,WR_ACK,MEM_WRITTEN,MEM_READ,
SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N
);
 


END TESTBENCH;