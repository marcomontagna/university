-- decodifica ascii
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY decodifica_ascii IS
	PORT (clk, load_decodifica,done_rx, rst_as_n: IN STD_LOGIC;
			input_decodifica: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			start_ack,read_ack: IN STD_LOGIC;
			fail: BUFFER STD_LOGIC;
			F, T, S, R, done_decodifica: OUT STD_LOGIC;
			freq: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			pat: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END decodifica_ascii;

ARCHITECTURE behavior OF decodifica_ascii IS



COMPONENT DATA_REGISTER
GENERIC (N:INTEGER);
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato in ingresso
DATA_REG_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0) --dato in uscita
);
END COMPONENT;

COMPONENT FLIP_FLOP_D IS
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN STD_LOGIC;	--dato in ingresso
DATA_REG_OUT	:	OUT STD_LOGIC --dato in uscita
);
END COMPONENT;

COMPONENT adder_4bit
	PORT
		( 
		NUM1: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		NUM2: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		SUM: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- volontariamente non considero il caso dell'overflow perchè non ha senso
END COMPONENT;

COMPONENT mux_2to1
	PORT
	(
		in1: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		in2: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		SEL_MUX: IN STD_LOGIC;
		out_mux: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END COMPONENT;

COMPONENT comparatore 
	PORT
	(
		command: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		matchF, matchT, matchS, matchR, err, n_09, n_AF, num: OUT STD_LOGIC);
END COMPONENT;

TYPE state_type IS (S_RESET, S0_IDLE, S1_FAIL, S2_F, S2_F_WAIT_PR,  S3_T_WAIT1, S3_T_UPPER, S4_S, S5_R, S6_Fn09, S7_ESEGUI_F, 
S8_Th1_09, S8_Th1_AF, S9_Th2_09, S9_Th2_AF, S9_T_WAIT2, S9_T_LOWER, S11_SAVE_PATTERN);
SIGNAL stato: state_type;
SIGNAL rst_sync, frequenza, start, leggi, pattern, n_09, n_AF, num, num_sel, load_MSB, load_LSB: STD_LOGIC;
SIGNAL en_frequenza, en_pattern, en_start, en_leggi,reset_read, reset_start: STD_LOGIC;
SIGNAL out_adder, in_pattern_reg, out_mux: STD_LOGIC_VECTOR (7 DOWNTO 0);
SIGNAL MSB, LSB: STD_LOGIC_VECTOR (3 DOWNTO 0);

BEGIN

-- control unit
	state_update: PROCESS (clk, rst_as_n)
	BEGIN
		IF (rst_as_n = '0') THEN
			stato <= S_RESET;
		ELSE
			IF (clk'EVENT AND clk = '1') THEN
			
				CASE stato IS
					
					WHEN S_RESET =>
						stato <= S0_IDLE;
						
					WHEN S0_IDLE =>
					IF load_decodifica='1' THEN
						IF (fail ='1') THEN
						stato <= S1_FAIL;
						ELSIF (frequenza = '1') THEN
							stato <= S2_F_WAIT_PR;
						ELSIF (pattern = '1') THEN
							stato <= S3_T_WAIT1;
						ELSIF (start = '1') THEN
							stato <= S4_S;
						ELSIF (leggi = '1') THEN
							stato <= S5_R;

						END IF;
						ELSE
							stato <= S0_IDLE;
						END IF;
					when S4_S =>
						stato <= S0_IDLE;
					when S5_R =>
						stato <= S0_IDLE;
						
						
					WHEN S1_FAIL =>
							stato <= S0_IDLE;
					
					WHEN S2_F_WAIT_PR =>		--aspettiamo che arrivi il dato del prescaler dalla uart rx
						IF done_rx='1' then
						stato<=S2_F;
						ELSE stato<=S2_F_WAIT_PR;
						END IF;
					
					
									
					WHEN S2_F =>		--aspettiamo che arrivi il dato del prescaler dalla uart rx
						IF (n_09 = '1' AND n_AF = '0') THEN
							stato <= S6_Fn09;
						ELSIF (n_09 = '0' AND n_AF = '1') THEN
							stato <= S1_FAIL;
						ELSE
							stato <= S1_FAIL;
						END IF;
								
								
								
					WHEN S6_Fn09 =>
						stato <= S7_ESEGUI_F;
						
					WHEN S7_ESEGUI_F =>
						stato <= S0_IDLE;
					
					WHEN S3_T_WAIT1=> 
						IF done_rx='1' then
						stato<=S3_T_UPPER;
						ELSE stato<=S3_T_WAIT1;
						END IF;
										
					WHEN S3_T_UPPER =>
						IF (n_09 = '1' AND n_AF = '0') THEN
							stato <= S8_Th1_09;
						ELSIF (n_09 = '0' AND n_AF = '1') THEN
							stato <= S8_Th1_AF;
						ELSE
							stato <= S1_FAIL;
						END IF;
						
					WHEN S8_Th1_09 =>
							stato <= S9_T_WAIT2;
						
					WHEN S8_Th1_AF =>
							stato <= S9_T_WAIT2;
							
					WHEN S9_T_WAIT2=> 
							IF done_rx='1' then
							stato<= S9_T_LOWER;
							ELSE
							stato<=S9_T_WAIT2;
							END IF;
						
					WHEN S9_T_LOWER=>
					IF (n_09 = '1' AND n_AF = '0') THEN
							stato <= S9_Th2_09;
						ELSIF (n_09 = '0' AND n_AF = '1') THEN
							stato <= S9_Th2_AF;
						ELSE
							stato <= S1_FAIL;
						END IF;
					
					WHEN S9_Th2_09  =>
						stato <= S11_SAVE_PATTERN;
						
					WHEN S9_Th2_AF  =>
						stato <= S11_SAVE_PATTERN;
											
					WHEN S11_SAVE_PATTERN =>
						stato <= S0_IDLE;
						
					WHEN OTHERS =>
						stato <= S0_IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	
	output_process: PROCESS (stato)
	BEGIN
		rst_sync <= '1';
		num_sel <= '0';
		load_LSB <= '0';
		load_MSB <= '0';
		en_frequenza <= '0';
		en_pattern <= '0';
		en_start <= '0';
		en_leggi <= '0';
		done_decodifica <= '0';
		
		CASE stato IS
	
			WHEN S_RESET => 
				rst_sync <= '0';
			
			WHEN S0_IDLE =>
				rst_sync <= '1';
				
			WHEN S1_FAIL => 
				done_decodifica <= '1';
				
			WHEN S2_F =>
				rst_sync <= '1';
				
			WHEN S2_F_WAIT_PR=>	
				rst_sync <= '1';				
				
			WHEN S3_T_WAIT1 =>
				rst_sync <= '1';	
			
			WHEN S3_T_UPPER =>
				rst_sync <= '1';
				
			WHEN S4_S =>
				en_start<='1';
				done_decodifica <= '1';
			
			WHEN S5_R =>
			en_leggi<='1';
			done_decodifica <= '1';
				
			WHEN S6_Fn09 =>
				num_sel <= '0';
							
			WHEN S7_ESEGUI_F =>
				en_frequenza <= '1';
				done_decodifica <= '1';
		
			WHEN S8_Th1_09 =>
				num_sel <= '0';
				LOAd_MSB<='1';
				
			WHEN S8_Th1_AF =>
				num_sel <= '1';
				LOAd_MSB<='1';
				
			WHEN S9_T_WAIT2=>
			   rst_sync <= '1';
			
			WHEN S9_T_LOWER=>
				rst_sync <= '1';
				
			WHEN S9_Th2_09 =>
				num_sel <= '0';
				load_LSB <= '1';
			
			WHEN S9_Th2_AF =>
				num_sel <= '1';
				load_LSB <= '1';
				
			WHEN S11_SAVE_PATTERN =>
				done_decodifica <= '1';
				en_pattern<='1';

		END CASE;
	END PROCESS;

-- datapath

	comparatore_decodifica: comparatore PORT MAP (input_decodifica, frequenza, pattern, start, leggi, fail, n_09, n_AF, num );
	sommatore: adder_4bit PORT MAP (input_decodifica, "00001001", out_adder);
	multiplexer: mux_2to1 PORT MAP (input_decodifica, out_adder, num_sel, out_mux);
	
	reg_frequenza: DATA_REGISTER GENERIC MAP(N=>4)
	PORT MAP(en_frequenza,clk, rst_sync,out_mux(3 downto 0),freq);
	
	reg_MSB: DATA_REGISTER GENERIC MAP(N=>4)
	PORT MAP (load_MSB,clk, rst_sync,out_mux(3 downto 0),MSB);
	
	reg_LSB: DATA_REGISTER GENERIC MAP(N=>4)
	PORT MAP (load_LSB,clk, rst_sync,out_mux(3 downto 0),LSB);
	
	in_pattern_reg <= MSB & LSB;
	
	reg_pattern: DATA_REGISTER GENERIC MAP(N=>8)
	PORT MAP (en_pattern,clk, rst_sync,in_pattern_reg,pat);
	
	flag_frequenza: FLIP_FLOP_D PORT MAP(en_frequenza,clk,rst_sync,'1',F);
	flag_pattern: FLIP_FLOP_D PORT MAP(en_pattern,clk,rst_sync,'1',T);

	reset_start<=rst_sync AND NOT start_ack;
	reset_read<=rst_sync AND NOT read_ack;
	flag_start: FLIP_FLOP_D PORT MAP (en_start, clk, reset_start, '1', S);
	flag_read: FLIP_FLOP_D PORT MAP (en_leggi, clk, reset_read, '1', R);

END behavior;
	