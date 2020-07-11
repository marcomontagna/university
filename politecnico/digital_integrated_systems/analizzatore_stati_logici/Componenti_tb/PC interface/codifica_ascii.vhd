 -- codifica ascii

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY codifica_ascii IS
	PORT (clk, load_dati,load_comando, rst_as_n, done_tx: IN STD_LOGIC;
			input_blocco: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			main_sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			dati_uart: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			TC: BUFFER STD_LOGIC;
			done_codifica: buffer STD_LOGIC;
			en_cnt: in std_logic;

			d_g: OUT STD_LOGIC_VECTOR (1 DOWNTO 0));
END codifica_ascii;

ARCHITECTURE behavior OF codifica_ascii IS

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

COMPONENT FLIP_FLOP_D
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN STD_LOGIC;	--dato in ingresso
DATA_REG_OUT	:	OUT STD_LOGIC --dato in uscita
);
END COMPONENT;

COMPONENT MUX_NBIT
	GENERIC (N:INTEGER);
	PORT(
		SEL	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);	--segnale di enable, reset e clock
		DATA_1, DATA_2, DATA_3, DATA_4, DATA_5, DATA_6, DATA_7, DATA_8	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato in ingresso
		DATA_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0) --dato in uscita
	);
END COMPONENT;

SIGNAL rst_sync : STD_LOGIC;
SIGNAL out_reg_channel: STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL out_cnt: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL in_reg_uart:STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

-- datapath
rst_sync<=rst_as_n;
	cnt_modulo8:COUNTER_NBIT GENERIC MAP (N=>3)
PORT MAP(en_cnt,'0',clk,rst_sync,"000",out_cnt,TC);

	reg_d_g: DATA_REGISTER GENERIC MAP(N=>16)
	PORT MAP(load_dati,clk,rst_sync,input_blocco,out_reg_channel);
		
	mux_channel: MUX_NBIT GENERIC MAP (N=>2)
		PORT MAP (out_cnt, out_reg_channel(15 DOWNTO 14), out_reg_channel(13 DOWNTO 12), out_reg_channel(11 DOWNTO 10), 
			out_reg_channel(9 DOWNTO 8), out_reg_channel(7 DOWNTO 6), out_reg_channel(5 DOWNTO 4), 
			out_reg_channel(3 DOWNTO 2), out_reg_channel(1 DOWNTO 0), d_g);
			
	mux_ascii: MUX_NBIT GENERIC MAP (N=>8)
	PORT MAP (main_sel, "00110000", "00110001", "01111000", "00001010", "01001111", "01001011",
	"00001101", "00000000", in_reg_uart); --0, 1, x, \n line feed, O, K, \r, null
	
	reg_uart: DATA_REGISTER GENERIC MAP(N=>8)
	PORT MAP(load_comando,clk,rst_sync,in_reg_uart,dati_uart);--in_reg_uart
	
	END behavior;