LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY Memory_Interface IS
PORT(
START,RD_REQ,WR_REQ,READ_READY,CLOCK_50,RESET	: IN STD_LOGIC;	--segnali ingresso memory_Interface
DATA_INPUT	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in ingresso dal sampler
DATA_OUTPUT	:	OUT STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in uscita dalla memory_Interface e in ingresso alla pc interface
--SRAM_ADDR	:	OUT STD_LOGIC_VECTOR(17 DOWNTO 0);	--indirizzo in uscita verso la SRAM
SRAM_ADDR	:	OUT STD_LOGIC_VECTOR(4 DOWNTO 0);	--indirizzo in uscita verso la SRAM  testbench testbench
SRAM_DQ	:	INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in uscita verso la SRAM
OUTPUT_VALID,START_ACK,RD_ACK,WR_ACK,MEM_WRITTEN,LAST_ADDRESS_FLAG,MEM_READ :OUT STD_LOGIC;	--segnale da mandare alla pc interface oppure alla maim FSM per indicare che c'Ã¨ un dato in uscita dalla mem
SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N: BUFFER  STD_LOGIC	);	--segnali controllo verso la SRAM 
END ENTITY Memory_Interface;

ARCHITECTURE structural OF Memory_Interface IS

--COMPONENTI
COMPONENT DATA_REGISTER
GENERIC (N:INTEGER);
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato in ingresso
DATA_REG_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0) --dato in uscita
);
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

COMPONENT TRI_STATE IS
GENERIC (N:INTEGER);
PORT(
ENABLE_OUTPUT	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_IN	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato in ingresso
DATA_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0) --dato in uscita
);
END COMPONENT;

COMPONENT FLIP_FLOP_D IS
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN STD_LOGIC;	--dato in ingresso
DATA_REG_OUT	:	OUT STD_LOGIC --dato in uscita
);
END COMPONENT;

--SEGNALI
TYPE STATE_TYPE IS (RESET_STATE, IDLE, WRITE_MEM, PRE_WRITE, POST_WRITE, POST_WRITE_LATCH_ADD, PRE_READ_CE,PRE_READ_OE,
READ_MEM,POST_READ, END_READ, INIZIALIZE_READ, READ_COMPLETE, CHECK_WRITE_STATUS, WRITE_COMPLETE);
SIGNAL PRESENT_STATE,NEXT_STATE,RESTORE_STATE: STATE_TYPE;
--SIGNAL SAR_IN,SAR_OUT,COUNT18_OUT,COUNT18_LOAD,LAST_ADDRESS:STD_LOGIC_VECTOR(17 DOWNTO 0);
SIGNAL SAR_IN,SAR_OUT,COUNT18_OUT,COUNT18_LOAD,LAST_ADDRESS:STD_LOGIC_VECTOR(4 DOWNTO 0);-- testbench testbench testbench
SIGNAL INTERFACE_INPUT_DATA,INTERFACE_INPUT_DATA2, INTERFACE_OUTPUT_DATA,DATA_IN,DATA_OUT:STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL EN_COUNT18, LOAD_COUNT18, EN_SAR, EN_DIR, EN_DOR, ENABLE_INPUT_DATA,TC_18,END_TRIGGER,EN_RFR,READ_FLAG_IN: STD_LOGIC;
SIGNAL READ_FLAG_OUT,ENABLE_TRI_STATE,RESET_SYNC  :STD_LOGIC;

BEGIN
--CONTROL UNIT A 2 PROCESSI CON LOGICA DI TRANSIZIONE E UPDATE SEPARATE
CU_NEXT_STATE_GENERATION: PROCESS (PRESENT_STATE,RESET,START,RD_REQ,WR_REQ,END_TRIGGER,READ_FLAG_OUT,READ_READY )
BEGIN
CASE PRESENT_STATE IS

WHEN RESET_STATE =>
IF RESET='1' THEN
NEXT_STATE<=IDLE;
ELSE NEXT_STATE<=RESET_STATE;
END IF;

WHEN IDLE =>
IF RD_REQ='0' THEN
IF (WR_REQ='1') THEN NEXT_STATE<=PRE_WRITE;
ELSE NEXT_STATE<=IDLE;
END IF;
ELSIF (RD_REQ='1') THEN NEXT_STATE<=INIZIALIZE_READ;
ELSE NEXT_STATE<=IDLE;
END IF;

WHEN PRE_WRITE =>--PREPARO LA MEMORIA , AL COLPO DI CLOCK SUCCESSIVO AVRA' IL DATO VALIDO IN INGRESSO
NEXT_STATE<=WRITE_MEM;

WHEN WRITE_MEM=>--HO IL DATO VALIDO IN INGRESSO, ASPETTO UN PO' PER RISPETTARE IL TIMING DELLA SRAM
IF START ='1' THEN 
NEXT_STATE<=POST_WRITE_LATCH_ADD;
ELSE
NEXT_STATE<=POST_WRITE;
END IF;

WHEN POST_WRITE=>--CAMPIONO IL DATO IN INGRESSO SUL FRONTE DI SALITA CHE ARRIVA PER PRIMO TRA I 5 SEGNALI DI CONTROLLO DELLA SRAM
NEXT_STATE<=CHECK_WRITE_STATUS;

WHEN POST_WRITE_LATCH_ADD=>
NEXT_STATE<=CHECK_WRITE_STATUS;

WHEN CHECK_WRITE_STATUS=>
IF (END_TRIGGER='1' AND READ_FLAG_OUT='1' ) THEN
NEXT_STATE<=WRITE_COMPLETE;
ELSE
NEXT_STATE<=IDLE;
END IF;

WHEN WRITE_COMPLETE=>
NEXT_STATE<=IDLE;

WHEN PRE_READ_CE=>
NEXT_STATE<=PRE_READ_OE;

WHEN PRE_READ_OE=>
NEXT_STATE<=READ_MEM;

WHEN READ_MEM=>
NEXT_STATE<=END_READ;

WHEN END_READ=>
NEXT_STATE<=POST_READ;

WHEN POST_READ=>
IF (END_TRIGGER='1') THEN 
NEXT_STATE<=READ_COMPLETE;
ELSIF (END_TRIGGER='0' AND READ_READY='1') THEN
NEXT_STATE<=PRE_READ_CE;
ELSE
NEXT_STATE<=POST_READ;
END IF;

WHEN INIZIALIZE_READ=>
NEXT_STATE<=PRE_READ_CE;

WHEN READ_COMPLETE=>
NEXT_STATE<=IDLE;

WHEN OTHERS =>
NEXT_STATE<=IDLE;
END CASE;
END PROCESS;

CU_STATE_UPDATE: PROCESS (CLOCK_50)
BEGIN
IF (CLOCK_50='1' AND CLOCK_50'EVENT) THEN 
IF (RESET='0') THEN PRESENT_STATE<=RESET_STATE;
ELSE PRESENT_STATE<=NEXT_STATE;
END IF; 
END IF;
END PROCESS;

CU_OUTPUT_GENERATION: PROCESS(PRESENT_STATE)
BEGIN
RESET_SYNC<='1';
SRAM_WE_N<='1'; SRAM_OE_N<='1'; SRAM_UB_N<='1'; SRAM_LB_N<='1'; SRAM_CE_N<='1'; OUTPUT_VALID<='0';
EN_SAR<='0';  EN_DIR<='0';EN_DOR<='0';	EN_RFR<='0'; READ_FLAG_IN<='0';
ENABLE_INPUT_DATA<='0'; EN_COUNT18<='0';LOAD_COUNT18<='0'; WR_ACK<='0'; RD_ACK<='0';
MEM_WRITTEN<='0'; MEM_READ<='0'; START_ACK<='0';

CASE PRESENT_STATE IS

WHEN RESET_STATE=>
RESET_SYNC<='0';
SRAM_WE_N<='1'; SRAM_OE_N<='1'; SRAM_UB_N<='1'; SRAM_LB_N<='1'; SRAM_CE_N<='1'; OUTPUT_VALID<='0';
EN_SAR<='0';  EN_DIR<='0';EN_DOR<='0';	EN_RFR<='0'; READ_FLAG_IN<='0';
ENABLE_INPUT_DATA<='0'; EN_COUNT18<='0';LOAD_COUNT18<='0'; WR_ACK<='0'; RD_ACK<='0';
MEM_WRITTEN<='0'; MEM_READ<='0'; START_ACK<='0';

WHEN IDLE =>
RESET_SYNC<='1';
SRAM_WE_N<='1'; SRAM_OE_N<='1'; SRAM_UB_N<='1'; SRAM_LB_N<='1'; SRAM_CE_N<='1'; OUTPUT_VALID<='0';
EN_SAR<='0';  EN_DIR<='0';EN_DOR<='0';	EN_RFR<='0'; READ_FLAG_IN<='0';
ENABLE_INPUT_DATA<='0'; EN_COUNT18<='0';LOAD_COUNT18<='0'; WR_ACK<='0';	RD_ACK<='0';
MEM_WRITTEN<='0'; MEM_READ<='0';	 START_ACK<='0';

WHEN PRE_WRITE =>--PREPARO LA MEMORIA , AL COLPO DI CLOCK SUCCESSIVO AVRÃ² IL DATO VALIDO IN INGRESSO
EN_DIR<='1'; ENABLE_INPUT_DATA<='1';

WHEN WRITE_MEM=>--HO IL DATO VALIDO IN INGRESSO, ASPETTO UN PO' PER RISPETTARE IL TIMING DELLA SRAM
SRAM_CE_N<='0';  SRAM_WE_N<='0'; SRAM_LB_N<='0';SRAM_UB_N<='0';ENABLE_INPUT_DATA<='1'; 

WHEN POST_WRITE=>
ENABLE_INPUT_DATA<='1';   WR_ACK<='1'; SRAM_CE_N<='0';  SRAM_WE_N<='0'; SRAM_LB_N<='0';SRAM_UB_N<='0';

WHEN POST_WRITE_LATCH_ADD=>
WR_ACK<='1'; SRAM_CE_N<='0';  SRAM_WE_N<='0'; SRAM_LB_N<='0';SRAM_UB_N<='0';ENABLE_INPUT_DATA<='1'; 
EN_SAR<='1';	EN_RFR<='1'; READ_FLAG_IN<='1'; START_ACK<='1';

WHEN CHECK_WRITE_STATUS=>
EN_COUNT18<='1'; ENABLE_INPUT_DATA<='1';

WHEN WRITE_COMPLETE=>
MEM_WRITTEN<='1';

WHEN PRE_READ_CE=>
SRAM_CE_N<='0'; SRAM_LB_N<='0';SRAM_UB_N<='0';

WHEN PRE_READ_OE=>
SRAM_CE_N<='0';SRAM_OE_N<='0';SRAM_LB_N<='0';SRAM_UB_N<='0'; 

WHEN READ_MEM=>
SRAM_CE_N<='0';SRAM_OE_N<='0'; SRAM_LB_N<='0';SRAM_UB_N<='0'; EN_DOR<='1'; 

WHEN END_READ=> 
EN_COUNT18<='1'; 

WHEN POST_READ=>
OUTPUT_VALID<='1'; 

WHEN INIZIALIZE_READ=>
EN_RFR<='1'; READ_FLAG_IN<='1'; RD_ACK<='1';

WHEN READ_COMPLETE=>
MEM_READ<='1'; EN_RFR<='1'; READ_FLAG_IN<='0';

WHEN OTHERS =>

END CASE;
END PROCESS;

--DATAPATH
DATA_IN(15 DOWNTO 0)<=DATA_INPUT(15 DOWNTO 0);

DATA_OUT_REG: DATA_REGISTER
GENERIC MAP (N=>16)
PORT MAP (EN_DOR,CLOCK_50,RESET_SYNC,SRAM_DQ(15 DOWNTO 0),DATA_OUT(15 DOWNTO 0));

DATA_IN_REG: DATA_REGISTER
GENERIC MAP (N=>16)
PORT MAP (EN_DIR,CLOCK_50,RESET_SYNC,DATA_IN(15 DOWNTO 0),INTERFACE_INPUT_DATA(15 DOWNTO 0));

ENABLE_TRI_STATE<= ENABLE_INPUT_DATA AND SRAM_OE_N;

TREE_STATE:TRI_STATE
GENERIC MAP(N=>16)
PORT MAP (ENABLE_TRI_STATE,INTERFACE_INPUT_DATA(15 DOWNTO 0), INTERFACE_INPUT_DATA2(15 DOWNTO 0));

SRAM_DQ(15 DOWNTO 0)<=INTERFACE_INPUT_DATA2(15 DOWNTO 0);


COUNTER_18BIT: COUNTER_NBIT
--GENERIC MAP(N=>18)
--PORT MAP(EN_COUNT18,LOAD_COUNT18,CLOCK_50,RESET_SYNC, COUNT18_LOAD(17 DOWNTO 0),COUNT18_OUT(17 DOWNTO 0),TC_18);
GENERIC MAP(N=>5)       --TESTBENCH TESTBENCH TESTBENCH
PORT MAP(EN_COUNT18,LOAD_COUNT18,CLOCK_50,RESET_SYNC, COUNT18_LOAD(4 DOWNTO 0),COUNT18_OUT(4 DOWNTO 0),TC_18);    --TESTBENCH TESTBENCH TESTBENCH


--SRAM_ADDR(17 DOWNTO 0)<=COUNT18_OUT(17 DOWNTO 0);
--SAR_IN(17 DOWNTO 0)<=COUNT18_OUT(17 DOWNTO 0);

SRAM_ADDR(4 DOWNTO 0)<=COUNT18_OUT(4 DOWNTO 0);--TESTBENCH TESTBENCH TESTBENCH
SAR_IN(4 DOWNTO 0)<=COUNT18_OUT(4 DOWNTO 0);--TESTBENCH TESTBENCH TESTBENCH


START_ADD_REG:DATA_REGISTER
--GENERIC MAP (N=>18)
--PORT MAP (EN_SAR,CLOCK_50,RESET_SYNC,SAR_IN(17 DOWNTO 0),SAR_OUT(17 DOWNTO 0));
GENERIC MAP (N=>5)        --TESTBENCH TESTBENCH TESTBENCH
PORT MAP (EN_SAR,CLOCK_50,RESET_SYNC,SAR_IN(4 DOWNTO 0),SAR_OUT(4 DOWNTO 0));     --TESTBENCH TESTBENCH TESTBENCH



--LAST_ADDRESS(17)<=SAR_OUT(17) XOR '1';
--LAST_ADDRESS(16 DOWNTO 0)<=SAR_OUT(16 DOWNTO 0);
--COUNT18_LOAD(17 DOWNTO 0)<=LAST_ADDRESS(17 DOWNTO 0);

LAST_ADDRESS(4)<=SAR_OUT(4) XOR '1';  --TESTBENCH TESTBENCH TESTBENCH
LAST_ADDRESS(3 DOWNTO 0)<=SAR_OUT(3 DOWNTO 0);--TESTBENCH TESTBENCH TESTBENCH
COUNT18_LOAD(3 DOWNTO 0)<=LAST_ADDRESS(3 DOWNTO 0);--TESTBENCH TESTBENCH TESTBENCH

--END_TRIGGER<=(COUNT18_OUT(17) XNOR LAST_ADDRESS(17))AND(COUNT18_OUT(16) XNOR LAST_ADDRESS(16))AND(COUNT18_OUT(15) XNOR LAST_ADDRESS(15))
--AND(COUNT18_OUT(14) XNOR LAST_ADDRESS(14))AND(COUNT18_OUT(13) XNOR LAST_ADDRESS(13))AND(COUNT18_OUT(12) XNOR LAST_ADDRESS(12))
--AND(COUNT18_OUT(11) XNOR LAST_ADDRESS(11))AND(COUNT18_OUT(10) XNOR LAST_ADDRESS(10))AND(COUNT18_OUT(9) XNOR LAST_ADDRESS(9))
--AND(COUNT18_OUT(8) XNOR LAST_ADDRESS(8))AND(COUNT18_OUT(7) XNOR LAST_ADDRESS(7))AND(COUNT18_OUT(6) XNOR LAST_ADDRESS(6))
--AND(COUNT18_OUT(5) XNOR LAST_ADDRESS(5))AND(COUNT18_OUT(4) XNOR LAST_ADDRESS(4))AND(COUNT18_OUT(3) XNOR LAST_ADDRESS(3))
--AND(COUNT18_OUT(2) XNOR LAST_ADDRESS(2))AND(COUNT18_OUT(1) XNOR LAST_ADDRESS(1))AND(COUNT18_OUT(0) XNOR LAST_ADDRESS(0));


END_TRIGGER<=(COUNT18_OUT(4) XNOR LAST_ADDRESS(4))AND(COUNT18_OUT(3) XNOR LAST_ADDRESS(3))--TESTBENCH TESTBENCH TESTBENCH
AND(COUNT18_OUT(2) XNOR LAST_ADDRESS(2))AND(COUNT18_OUT(1) XNOR LAST_ADDRESS(1))AND(COUNT18_OUT(0) XNOR LAST_ADDRESS(0));--TESTBENCH TESTBENCH TESTBENCH

REGISTER_READ:FLIP_FLOP_D
PORT MAP (EN_RFR,CLOCK_50,RESET_SYNC,READ_FLAG_IN,READ_FLAG_OUT);
LAST_ADDRESS_FLAG<= END_TRIGGER AND READ_FLAG_OUT;
DATA_OUTPUT(15 DOWNTO 0)<=DATA_OUT(15 DOWNTO 0);
END ARCHITECTURE structural;