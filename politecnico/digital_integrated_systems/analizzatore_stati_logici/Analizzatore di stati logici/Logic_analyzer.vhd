-- main analizzatore

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Logic_analyzer IS
	PORT (
			GPIO_1: IN STD_LOGIC_VECTOR(35 DOWNTO 0);
			CLOCK_50: IN STD_LOGIC;
			KEY:STD_LOGIC_VECTOR(3 DOWNTO 0);
			SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N: OUT  STD_LOGIC;	--segnali controllo verso la SRAM 
			SRAM_ADDR	:	OUT STD_LOGIC_VECTOR(17 DOWNTO 0);	--indirizzo in uscita verso la SRAM
			SRAM_DQ	:	INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in uscita verso la SRAM
			UART_RXD: IN STD_LOGIC;
			UART_TXD: OUT STD_LOGIC);
END Logic_analyzer;

ARCHITECTURE behavior OF Logic_analyzer IS

	-- component sample
	COMPONENT sampler
		PORT (input, clk, sample, rst_as_n : IN STD_LOGIC;
				D: BUFFER STD_LOGIC;
				P: OUT STD_LOGIC);
	END COMPONENT;
	
	-- component contatore a TC variabile
	COMPONENT clock_divider
		PORT 
			(
			RESET, CLOCK, ENABLE,LOAD_COUNT, DISABLE: IN STD_LOGIC;
			PRESCALER_IN:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			TERMINAL_COUNT:BUFFER STD_LOGIC
			);
	END COMPONENT;
	
	-- component memory interface
	COMPONENT Memory_Interface
	PORT(
			START,RD_REQ,WR_REQ,READ_READY,CLOCK_50,RESET	: IN STD_LOGIC;	--segnali ingresso memory_Interface
			DATA_INPUT	:	IN STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in ingresso dal sampler
			DATA_OUTPUT	:	OUT STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in uscita dalla memory_Interface e in ingresso alla pc interface
			SRAM_ADDR	:	OUT STD_LOGIC_VECTOR(17 DOWNTO 0);	--indirizzo in uscita verso la SRAM
			SRAM_DQ	:	INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in uscita verso la SRAM
			OUTPUT_VALID,START_ACK,RD_ACK,WR_ACK,MEM_WRITTEN,LAST_ADDRESS_FLAG,MEM_READ :OUT STD_LOGIC;	--segnale da mandare alla pc interface oppure alla maim FSM per indicare che c'ÃƒÂ¨ un dato in uscita dalla mem
			SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N: BUFFER  STD_LOGIC	);	--segnali controllo verso la SRAM 
	END COMPONENT;
	
	-- component pc interface
	COMPONENT	pc_interface
		PORT 
			(clock, rst_as: IN STD_LOGIC;
			input_codifica: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			load_codifica: IN STD_LOGIC;
			block_sent: BUFFER STD_LOGIC;
			UART_RXD: IN STD_LOGIC;
			UART_TXD: OUT STD_LOGIC;
			start_ack,read_ack: IN STD_LOGIC;
			F, T, S, R: OUT STD_LOGIC;
			frequenza: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			pattern: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;
	
	-- component trigger generator
	COMPONENT trigger_generator
		PORT (clock, load_pattern, rst_as_n, trigger_ack: IN STD_LOGIC;
				pattern, input: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
				match_trigger: BUFFER STD_LOGIC);
	END COMPONENT;
	
	-- component D FF
	COMPONENT reg_1bit
		PORT (input, clock, enable, rst_sy_n: IN STD_LOGIC;
				Q: OUT STD_LOGIC);
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
	
COMPONENT MUX_NBIT IS
	GENERIC (N:INTEGER);
	PORT(
		SEL	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);	--segnale di enable, reset e clock
		DATA_1, DATA_2, DATA_3, DATA_4, DATA_5, DATA_6, DATA_7, DATA_8	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato in ingresso
		DATA_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0) --dato in uscita
	);
END COMPONENT;	
	
	TYPE state_type IS ( S0_RESET, 
								S1_IDLE_DEF, S2_SAMPLE, S3_WR_REQ,
								S4bis_SET_FREQ, S4_IDLE_F,
								S5bis_PATTERN, S5_IDLE_T,
								S6_WAIT_MATCH_P,
								S8_IDLE_128K,
								S9_WAIT_R, S9bis_READ_REQ, S9bis_WAIT_READ_CONFIRM,
								S10_WAIT_OUT_VALID, S11_LOAD_CODIFICA, S12_ELABORA_PC_IN, S13_READ_READY);
	SIGNAL stato: state_type;
	
	SIGNAL rst : STD_LOGIC;	--reset sincrono inviato a tutti i componenti
	SIGNAL en_cnt, load_cnt, disable_cnt, TC_variabile: STD_LOGIC; --segnali controllo clock divider, enable, disable e terminal count
	SIGNAL frequenza_m: STD_LOGIC_VECTOR (3 DOWNTO 0); --frequenza in uscita dalla pc interface mandata in ingresso al clock divider
	SIGNAL sample: STD_LOGIC;	--comando di sample
	SIGNAL D1, P1, D2, P2, D3, P3, D4, P4, D5, P5, D6, P6, D7, P7, D8, P8: STD_LOGIC; --dati e glitch
	SIGNAL input_mem_int: STD_LOGIC_VECTOR (15 DOWNTO 0); --dati ingresso memoria
	SIGNAL wr_req, read_req, start_mem_128k, read_ready, output_valid: STD_LOGIC; -- segnali mem interface
	SIGNAL start_ack, rd_ack, wr_ack, mem_written,last_address, mem_read: STD_LOGIC; -- segnali output mem interface
	SIGNAL mem_written10MHz:std_LOGIC;--segnale usato per controllare quando la memoria Ã¨ stata scritta a 10MHz
	SIGNAL out_mem: STD_LOGIC_VECTOR (15 DOWNTO 0); --uscita dati memory interface
	SIGNAL input_trigger: STD_LOGIC_VECTOR (7 DOWNTO 0); --dati in ingresso al trigger
	SIGNAL load_pattern: STD_LOGIC;	--enable trigger generator
	SIGNAL match_trigger: STD_LOGIC;	--uscita trigger generator in and con il comando di start
	SIGNAL pattern_m: STD_LOGIC_VECTOR (7 DOWNTO 0);	--pattern di trigger in ingresso al blocco
	SIGNAL load_pc_interface: STD_LOGIC;	--viene usato per asserire load codifica
	SIGNAL block_sent: STD_LOGIC;				--segnale che indica che gli 8 bit di dato oppure la O o la K  sono stati inviati
	SIGNAL Rm, Fm, Tm, Sm: STD_LOGIC;	--flag in uscita: read, freq set, trigger set, start set
	SIGNAL match_pattern: STD_LOGIC; --segnale di controllo segnale di enable flip flop semaforo_start
	SIGNAL read_complete: std_LOGIC; --segnale di controllo read uscita flip flop semaforo_read
	SIGNAL control_status,status_sel,status_mux_out: STD_LOGIC_VECTOR (2 DOWNTO 0); --segnale per controllare i diversi stati di idle con controllo status mux
	SIGNAL rst_as: STD_LOGIC; --reset asincrono logic analyzer collegato al pulsante 0
	SIGNAL input1, input2, input3, input4, input5, input6, input7, input8: STD_LOGIC;  --canali di input dell'analizzatore
	SIGNAL en_status_reg: STD_LOGIC; --segnale abilitazione registro di stato	
	BEGIN
		
		-- control unit
		state_update: PROCESS (CLOCK_50, rst_as)
		BEGIN
			IF (rst_as = '0') THEN
			stato <= S0_RESET;
			
			ELSE
			
			IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
				CASE stato IS
				
					WHEN S0_RESET =>
						stato <= S1_IDLE_DEF;
						
					WHEN S1_IDLE_DEF =>
						IF (TC_variabile = '1') THEN
							stato <= S2_SAMPLE;
						ELSIF (Fm = '1') THEN
							stato <= S4bis_SET_FREQ;
						ELSE 
							stato <= S1_IDLE_DEF;
						END IF;
						
					WHEN S2_SAMPLE =>
						stato <= S3_WR_REQ;
						
					WHEN S3_WR_REQ =>
					
					CASE control_status is
						WHEN "000" =>
						stato<=S1_IDLE_DEF;
						WHEN "001" =>
						stato<=S4_IDLE_F;					
						WHEN "010" =>
						stato<=S5_IDLE_T;
						WHEN "011" =>
						stato<=S6_WAIT_MATCH_P;	
						WHEN "100" =>
						stato<=S8_IDLE_128K;						
						WHEN OTHERS=>
						stato<=S0_RESET;
						END CASE;
						
					WHEN S4bis_SET_FREQ =>	--come ci arrivo in questo stato
						stato <= S4_IDLE_F;
						
					WHEN S4_IDLE_F =>
						IF (TC_variabile = '1') THEN
							stato <= S2_SAMPLE;
						ELSIF (Tm = '1') THEN
							stato <= S5bis_PATTERN;
						ELSE 
							stato <= S4_IDLE_F;
						END IF;
						
					WHEN S5bis_PATTERN =>
						stato <= S5_IDLE_T;
						
					WHEN S5_IDLE_T =>
						IF (TC_variabile = '1') THEN
							stato <= S2_SAMPLE;
						ELSIF (Sm = '1') THEN
							stato <= S6_WAIT_MATCH_P;
						ELSE 
							stato <= S5_IDLE_T;
						END IF;
						
					WHEN S6_WAIT_MATCH_P =>
						IF (TC_variabile = '1') THEN
							stato <= S2_SAMPLE;
						ELSIF (start_mem_128k = '1') THEN
							stato <= S8_IDLE_128K;	
						ELSE 
							stato <= S6_WAIT_MATCH_P;
						END IF;
						

					WHEN S8_IDLE_128K =>
						IF (mem_written ='1' OR mem_written10MHz='1') THEN
							stato <= S9_WAIT_R;
						ELSIF (TC_variabile = '1') THEN
							stato <= S2_SAMPLE;
						ELSE
							stato <= S8_IDLE_128K;
						END IF;
						
					WHEN S9_WAIT_R =>
						IF (Rm = '1') THEN
							stato <= S9bis_WAIT_READ_CONFIRM;
						ELSE
							stato <= S9_WAIT_R;
						END IF;
					
					WHEN S9bis_WAIT_READ_CONFIRM =>
						IF (block_sent='1') THEN 
						stato<=S9bis_READ_REQ;
						ELSE
						stato<=S9bis_WAIT_READ_CONFIRM;
						END IF;
				
					WHEN S9bis_READ_REQ =>
						stato <= S10_WAIT_OUT_VALID;
						
					WHEN S10_WAIT_OUT_VALID =>
						IF (output_valid = '1') THEN
							stato <= S11_LOAD_CODIFICA;
						ELSE
							stato <= S10_WAIT_OUT_VALID;
						END IF;
						
					WHEN S11_LOAD_CODIFICA =>
						stato <= S12_ELABORA_PC_IN;
						
					WHEN S12_ELABORA_PC_IN =>		--controllo che sia stato inviato correttamente il blocco di 16bit
						IF (block_sent = '1') THEN 	--se ho inviato gli 8 bit dei canali piÃ¹ \n\r posso
							stato <= S13_READ_READY;	--caricare un nuovo dato dalla memoria
						ELSE 
							stato <= S12_ELABORA_PC_IN;	--se non ho finito di inviare i dati resto in attesa
						END IF;	
						
					WHEN 	S13_READ_READY=>
					IF read_complete='1' THEN
					stato<=S0_RESET;
					ELSE
						stato <= S10_WAIT_OUT_VALID;
					END IF;
					
					WHEN OTHERS =>
						stato <= S0_RESET;
						
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	
	output_process: PROCESS (stato)
	BEGIN
	
		rst <= '1';
		en_cnt <= '0';
		disable_cnt <= '0';
		sample <= '0';
		wr_req <= '0';
		read_req <= '0';
		read_ready <= '0';
		load_pattern <= '0';
		load_pc_interface <= '0';
		load_cnt<='0';
		status_sel<="000";
		en_status_reg<='0';
		CASE stato IS
			WHEN S0_RESET =>
				rst <= '0';
				status_sel <= "000";
				
			WHEN S1_IDLE_DEF =>
				status_sel <= "000";
				en_cnt <= '1';
				en_status_reg<='1';

			WHEN S2_SAMPLE =>
				sample <= '1';
				
			WHEN S3_WR_REQ =>
				wr_req <= '1';
				
			WHEN S4bis_SET_FREQ =>
				load_cnt<='1';
			--	en_cnt <= '1'; --abilito contatore e contemporaneamente sal
				
			WHEN S4_IDLE_F =>
				status_sel <= "001";
				en_status_reg<='1';
				--en_cnt <= '1';
				
			WHEN S5bis_PATTERN =>
				load_pattern <= '1';
				
			WHEN S5_IDLE_T	=>
				status_sel <= "010";
				en_status_reg<='1';
				
			WHEN S6_WAIT_MATCH_P =>
				status_sel <= "011";
				en_status_reg<='1';

			WHEN S8_IDLE_128K =>
				status_sel <= "100";
				en_status_reg<='1';
				
			WHEN S9_WAIT_R =>
				rst <= '1';
				disable_cnt<='1';
				
			WHEN S9bis_WAIT_READ_CONFIRM=>
				rst<='1';

			WHEN S9bis_READ_REQ =>
				read_req <= '1'; 
	
			WHEN S10_WAIT_OUT_VALID =>
				rst <= '1';
				
			WHEN S11_LOAD_CODIFICA =>
				load_pc_interface <= '1';
				
			WHEN S12_ELABORA_PC_IN =>
				rst <= '1';
				
			WHEN S13_READ_READY =>
				read_ready <= '1';
				
			END CASE;
		END PROCESS;
	
	-- datapath
	
		rst_as<=KEY(1);
		
		input1<=GPIO_1(0);
		input2<=GPIO_1(1);
		input3<=GPIO_1(2);
		input4<=GPIO_1(3);
		input5<=GPIO_1(4);
		input6<=GPIO_1(5);
		input7<=GPIO_1(6);
		input8<=GPIO_1(7);

	-- potrei fare gli 8 sampler con un generate forse
		sampler1: sampler PORT MAP (input1, CLOCK_50, sample, rst, D1, P1);
		sampler2: sampler PORT MAP (input2, CLOCK_50, sample, rst, D2, P2);
		sampler3: sampler PORT MAP (input3, CLOCK_50, sample, rst, D3, P3);
		sampler4: sampler PORT MAP (input4, CLOCK_50, sample, rst, D4, P4);
		sampler5: sampler PORT MAP (input5, CLOCK_50, sample, rst, D5, P5);
		sampler6: sampler PORT MAP (input6, CLOCK_50, sample, rst, D6, P6);
		sampler7: sampler PORT MAP (input7, CLOCK_50, sample, rst, D7, P7);
		sampler8: sampler PORT MAP (input8, CLOCK_50, sample, rst, D8, P8);
		
		cnt_variable_TC: clock_divider PORT MAP (rst, CLOCK_50, en_cnt,load_cnt, disable_cnt, frequenza_m, TC_variabile);
		
		input_mem_int <= D1&P1&D2&P2&D3&P3&D4&P4&D5&P5&D6&P6&D7&P7&D8&P8; --i canali sono ordinati cosÃ¬
		--il dato piu' a sinistra si riferisce al canale 1, quello piu' a destra al canale 8
		
		interfaccia_memoria: Memory_Interface 
		PORT MAP ( 
		START=>match_pattern, RD_REQ=>read_req, WR_REQ=>wr_req, READ_READY=>read_ready, CLOCK_50=>CLOCK_50, RESET=>rst,
		DATA_INPUT=>input_mem_int, DATA_OUTPUT=>out_mem,
		OUTPUT_VALID=>output_valid, START_ACK=>start_ack, RD_ACK=>rd_ack, WR_ACK=>wr_ack, MEM_WRITTEN=>mem_written,LAST_ADDRESS_FLAG=>last_address, MEM_READ=>mem_read,
		SRAM_WE_N=>SRAM_WE_N, SRAM_OE_N=>SRAM_OE_N, SRAM_UB_N=>SRAM_UB_N, SRAM_LB_N=>SRAM_LB_N, SRAM_CE_N=>SRAM_CE_N,
		SRAM_ADDR=>SRAM_ADDR, SRAM_DQ=>SRAM_DQ
		);
			
		interfaccia_pc: pc_interface PORT MAP
			(CLOCK_50, rst, out_mem, load_pc_interface, 
			block_sent, UART_RXD,UART_TXD,START_ACK, RD_ACK, 
			Fm, Tm, Sm, Rm, 
			frequenza_m, pattern_m);
			
	match_pattern<=match_trigger AND Sm;	
	
		input_trigger <= D1&D2&D3&D4&D5&D6&D7&D8; --modificare canali in base alla notazione scelta
		--i primi 4 sono definiti dal MSB del pattern, gli altri dal LSB del pattern
		
		generatore_trigger: trigger_generator
			PORT MAP (CLOCK_50, load_pattern, rst, start_ack, pattern_m, input_trigger, match_trigger);
			
	mem_written10MHz<=last_address AND (NOT frequenza_m(0) AND NOT frequenza_m(1) AND NOT frequenza_m(2) AND NOT frequenza_m(3));

	semaforo_start: FLIP_FLOP_D PORT MAP (match_pattern, CLOCK_50, rst, '1', start_mem_128k); 
	
	semaforo_read: FLIP_FLOP_D PORT MAP (mem_read,CLOCK_50,rst,'1',read_complete);
	
	status_mux: MUX_NBIT
	GENERIC MAP (N=>3)
	PORT MAP(status_sel,"000","001","010","011","100","000","000","000",status_mux_out);

	registro_stato: DATA_REGISTER
	GENERIC MAP (N=>3)
	PORT MAP(en_status_reg,CLOCK_50,rst,status_mux_out,control_status);
	
	END architecture;
	