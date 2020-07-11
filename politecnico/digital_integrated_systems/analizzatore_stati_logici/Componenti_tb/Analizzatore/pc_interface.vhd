-- pc interface
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY pc_interface IS
	PORT 
		(clock, rst_as: IN STD_LOGIC;
		input_codifica: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		load_codifica: IN STD_LOGIC;
		block_sent: BUFFER STD_LOGIC;	--quando è 1 significa che la codifica e invio dei dati è stata completata
		UART_RXD: IN STD_LOGIC;
		UART_TXD: OUT STD_LOGIC;
		start_ack,read_ack: IN STD_LOGIC;
		F, T, S, R: OUT STD_LOGIC;
		frequenza: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		pattern: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END pc_interface;

ARCHITECTURE behavior OF pc_interface IS

	COMPONENT codifica_ascii 
		PORT (clk, load_dati,load_comando, rst_as_n, done_tx: IN STD_LOGIC;
				input_blocco: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				main_sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
				dati_uart: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				TC: BUFFER STD_LOGIC;				
				done_codifica: buffer STD_LOGIC;
				en_cnt: in std_logic;
				d_g: OUT STD_LOGIC_VECTOR (1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT decodifica_ascii
	PORT (clk, load_decodifica,done_rx, rst_as_n: IN STD_LOGIC;
			input_decodifica: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			start_ack,read_ack: IN STD_LOGIC;
			fail: BUFFER STD_LOGIC;
			F, T, S, R, done_decodifica: OUT STD_LOGIC;
			freq: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			pat: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
	END COMPONENT;	
	
	COMPONENT UART_TX
   PORT( 
			start_macchina:IN std_logic;
			Reset:IN std_logic;
			Data_In: In std_logic_vector(7 downto 0);
         CLOCK_50 :IN std_logic;
			Q: OUT std_logic;
			Done: OUT std_Logic);
		END COMPONENT;
		
	COMPONENT UART_RX 
		PORT (		
			Start_RX:OUT std_logic;
			Reset :In std_logic;
			Data_In: In std_logic;
         CLOCK_50 :IN std_logic;
			Q: OUT std_logic_vector(7 downto 0);
			Done: OUT std_Logic);
	END COMPONENT;
	
	COMPONENT FLIP_FLOP_D IS
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN STD_LOGIC;	--dato in ingresso
DATA_REG_OUT	:	OUT STD_LOGIC --dato in uscita
);
END COMPONENT;
	
	TYPE state_type IS (S0_RESET, S1_IDLE, S2_CODIFICA,
							S3_DATO0, S4_DATO1, S5_DATOX, 
							S6_FL, S6bis_CR, S6_FL_BIS, S6bis_CR_BIS,
							S7_INVIAO, S8_INVIAK,S7_INVIAO_BIS,S8_INVIAK_BIS,
							S9_DONE_CODIFICA, S10_UART_TX_DATO, -- inizio elaborazione uart
							S11_DONE_CODIFICA_FL,S11_DONE_CODIFICA_CR,
							S12_UART_TX_FL,S12_UART_TX_CR,S12bis_DATA_SENT,
							S13_ELABORA_UART_RX, S14_START_DECODIFICA, S15_DECODIFICA,
							S16_DONE_CODIFICA_O_K,S16_UART_TX_O_K);
	
	SIGNAL stato: state_type;
	SIGNAL rst: STD_LOGIC;
	
	-- segnali codifica
	SIGNAL sel_codifica: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL out_codifica: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL TC_codifica: STD_LOGIC;
	SIGNAL dato_glitch: STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL done_codifica: STD_LOGIC;
	SIGNAL load_comando: STD_LOGIC;
	
	-- segnali uart tx
	SIGNAL start_TX: STD_LOGIC;
	SIGNAL done_tx:std_LOGIC;
	
	-- segnali uart rx
	SIGNAL start_rx: STD_LOGIC;
	SIGNAL done_rx: STD_LOGIC;
	SIGNAL out_RX: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	-- segnali decodifica_ascii
	SIGNAL load_decodifica: STD_LOGIC;
	SIGNAL done_decodifica: STD_LOGIC;
	SIGNAL fail: STD_LOGIC;
	
	-- SIGNAL SEMAFORO
    SIGNAL EN_TC_SEM,TC_ACK,RESET_SEM,TC_SEM:STD_LOGIC;
	
	SIGNAL EN_CNT:STD_LOGIC;

	BEGIN
	-- control unit
	state_update: PROCESS (clock)
	BEGIN
		IF (clock'EVENT AND clock = '1') THEN
		
		IF (rst_as = '0') THEN
			stato <= S0_RESET;
		
		ELSE
		
				CASE stato IS
				
					WHEN S0_RESET =>
						stato <= S1_IDLE;
						
					WHEN S1_IDLE =>
						IF (load_codifica ='1') THEN
							stato <= S2_CODIFICA;
						ELSIF (start_RX = '1') THEN	
							stato <= S13_ELABORA_UART_RX;
						END IF;
					
					WHEN S2_CODIFICA =>	--gestione codifica ascii
						IF (TC_SEM = '1') THEN
							stato <= S6_FL;
						ELSIF (TC_SEM = '0' AND dato_glitch = "00") THEN
							stato <= S3_DATO0;
						ELSIF (TC_SEM = '0' AND dato_glitch = "10") THEN
							stato <= S4_DATO1;
						ELSIF (TC_SEM = '0' AND dato_glitch = "01") THEN
							stato <= S5_DATOX;
						ELSIF (TC_SEM = '0' AND dato_glitch = "11") THEN
							stato <= S5_DATOX;
						ELSE 
							stato <= S1_IDLE;
						END IF;
						
					WHEN S3_DATO0 =>
						stato <= S9_DONE_CODIFICA;
						
					WHEN S4_DATO1 =>
						stato <= S9_DONE_CODIFICA;
					
					WHEN S5_DATOX =>
						stato <= S9_DONE_CODIFICA;
						
					WHEN S6_FL =>--invia slash \n al registro uarT_TX
						stato<=S6_FL_BIS;
						
					WHEN S6_FL_BIS=>	
						stato <= S11_DONE_CODIFICA_FL;
					
					WHEN S6bis_CR =>----invio \r al registro uarT_TX
						stato<=S6bis_CR_BIS;
						
					WHEN S6bis_CR_BIS=>	
						stato <= S11_DONE_CODIFICA_CR;
						
					WHEN S7_INVIAO =>
						stato<=	S7_INVIAO_BIS;
						
					WHEN S7_INVIAO_BIS=>
						stato <= S16_DONE_CODIFICA_O_K;
						
					WHEN S8_INVIAK =>
						stato<=	S8_INVIAK_BIS;
				
					WHEN S8_INVIAK_BIS=>	
						stato <= S16_DONE_CODIFICA_O_K;
						
					WHEN S9_DONE_CODIFICA =>
						stato <= S10_UART_TX_DATO;
						
					WHEN S10_UART_TX_DATO =>--in questo stato si inviano 1, 0, x
						if (done_tx = '1') then
							stato <= S2_CODIFICA;
						else 
							stato <= S10_UART_TX_DATO;
						end if;
						
					WHEN S11_DONE_CODIFICA_FL =>	--ho finito la codifica del \n
						stato <= S12_UART_TX_FL;
					
					WHEN S11_DONE_CODIFICA_CR=> --ho finito la codifica del \r
						stato<=S12_UART_TX_CR;
						
					WHEN S12_UART_TX_FL =>	--invio carattere \n 
						if (done_tx = '1') then
							stato <= S6bis_CR; --vado nello stato in cui codifico il CR
						else 
							stato <= S12_UART_TX_FL;
						end if;
					
					WHEN S12_UART_TX_CR =>	--invio carattere e \r
						if (done_tx = '1') then
							stato <= S12bis_DATA_SENT; --vado nello stato in cui codifico il CR
						else 
							stato <= S12_UART_TX_CR;
						end if;	
			
					WHEN S12bis_DATA_SENT=>
						stato<=S1_IDLE;
			
					WHEN S13_ELABORA_UART_RX =>
						if (done_rx = '1') then
							stato <= S14_START_DECODIFICA;
						else 
							stato <= S13_ELABORA_UART_RX;
						end if;
						
					WHEN S14_START_DECODIFICA =>
						stato <= S15_DECODIFICA;
						
					WHEN S15_DECODIFICA =>
						IF (fail = '0' AND done_decodifica = '1') THEN
							stato <= S7_INVIAO;
						ELSIF (fail = '1' AND done_decodifica = '1') THEN
							stato <= S8_INVIAK;
						ELSE 
							stato <= S15_DECODIFICA;
						END IF;
						
					WHEN S16_DONE_CODIFICA_O_K => --ho codificato
						stato <= S16_UART_TX_O_K;
					
					WHEN S16_UART_TX_O_K=>
					if (done_tx = '1') then
						stato <= S6_FL; --vado nello stato in cui codifico il \N 
					else 
						stato <= S16_UART_TX_O_K;
					end if;				
					
					WHEN OTHERS =>
						stato <= S1_IDLE;
						
					END CASE;
				END IF;
			END IF;
		END PROCESS;
	
	output_process: PROCESS (stato)
	BEGIN
	
		rst <= '1';
		sel_codifica <= "000";
		start_TX <= '0';
		load_decodifica <= '0';
		block_sent<='0';
		TC_ACK<='0';
		load_comando<='0';
		en_cnt <= '0';
		
		CASE stato IS
			WHEN S0_RESET =>
				rst <= '0';					 
							
			WHEN S1_IDLE =>
				rst <= '1'; 
				
			WHEN S2_CODIFICA => -- e' arrivato il load e aspetta che codifichi
				rst <= '1';
				
			WHEN S3_DATO0 => -- codificato 0, mette selettore per inviare 0, gli stati sotto sono uguali
				sel_codifica <= "000";
				en_cnt <= '1';
								load_comando <='1';

				
			WHEN S4_DATO1 => -- codificato 1
				sel_codifica <= "001";
				en_cnt <= '1';
								load_comando <='1';

			WHEN S5_DATOX =>
				sel_codifica <= "010";
				en_cnt <= '1';
								load_comando <='1';

				
			WHEN S6_FL => --invia slash \n al registro uarT_TX
				sel_codifica <= "011";
				load_comando <='1';
				TC_ACK<='1';
				
			WHEN S6_FL_BIS => --invia slash \n al registro uarT_TX
				sel_codifica <= "011";	
				
			WHEN S6bis_CR	=>--invio \r
				sel_codifica <= "110";
				load_comando <='1';
	
			WHEN S6bis_CR_BIS	=>--invio \r
				sel_codifica <= "110";				
				
			WHEN S7_INVIAO =>
				load_comando<='1';
				sel_codifica <= "100";
				
			WHEN S7_INVIAO_BIS=>	
				sel_codifica <= "100";
				
			WHEN S8_INVIAK =>
				load_comando<='1';
				sel_codifica <= "101";
		
			WHEN S8_INVIAK_BIS=>	
				sel_codifica <= "101";
				
			WHEN S9_DONE_CODIFICA =>
				start_TX <= '1';
								
			-- in questo stato dovrebbe attivarsi il done-codifica
			WHEN S10_UART_TX_DATO => --in questo stato si inviano 1, 0, x
				rst <= '1';
				
			WHEN S11_DONE_CODIFICA_FL =>	--ho finito la codifica del \n
				start_TX <= '1';
				
			WHEN S11_DONE_CODIFICA_CR=>	--ho finito la codifica del \r
				start_TX <= '1';
				
			WHEN S12_UART_TX_FL =>
				rst <= '1';
				
			WHEN S12_UART_TX_CR =>
				rst <= '1';
				
			WHEN S12bis_DATA_SENT=>	--abbiamo finito di inviare gli 8 dati piu' \n\r
					block_sent<='1';
					
			WHEN S13_ELABORA_UART_RX =>
				rst <= '1';
				
			WHEN S14_START_DECODIFICA =>
				load_decodifica <= '1';
				
			WHEN S15_DECODIFICA =>
				rst <= '1';
				
			WHEN S16_DONE_CODIFICA_O_K =>
				start_TX <= '1';
				
			WHEN	S16_UART_TX_O_K =>
				rst <= '1';
	
			END CASE;
		END PROCESS;
		
	-- datapath
	
	ascii_codifica: codifica_ascii 
		PORT MAP (clock, load_codifica,load_comando, rst, done_tx, input_codifica, sel_codifica,
		out_codifica, TC_codifica, done_codifica,en_cnt, dato_glitch);
		
	trasmissione_uart: UART_TX 
		PORT MAP (start_TX, rst, out_codifica, clock, UART_TXD, done_tx);
		
	ricezione_uart: UART_RX
		PORT MAP (start_RX, rst, UART_RXD, clock, out_RX, done_rx);
		
	ascii_decodifica: decodifica_ascii
		PORT MAP (clock, load_decodifica, done_rx, rst, out_RX, start_ack, read_ack, fail,
		F, T, S, R, done_decodifica, frequenza, pattern);
		
--aggiungere semafori
EN_TC_SEM<=TC_codifica;	--TC CODIFICA manda a uno l'uscita del semaforo
RESET_SEM<=rst AND NOT TC_ACK;
REGISTER_READ_TC:FLIP_FLOP_D
PORT MAP (EN_TC_SEM,clock,RESET_SEM,'1',TC_SEM);
		
END behavior;