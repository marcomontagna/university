-- trigger_generator

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY trigger_generator IS
	PORT (clock, load_pattern, rst_as_n, trigger_ack: IN STD_LOGIC;
			pattern, input: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			match_trigger: BUFFER STD_LOGIC);
END trigger_generator;

ARCHITECTURE behavior OF trigger_generator IS

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

TYPE state_type IS (S0_RESET, S1_IDLE, S2_WAIT, S3_MATCH,S4_RESET_MATCH);
SIGNAL stato: state_type;

SIGNAL en_match,match: STD_LOGIC;
SIGNAL rst_sync,rst_dff: STD_LOGIC;
SIGNAL confronto: STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN


	-- control unit
	state_update: PROCESS (clock, rst_as_n)
	BEGIN
	
	IF (clock'EVENT AND clock = '1') THEN

		IF (rst_as_n = '0') THEN
			stato <= S0_RESET;
		ELSE
					
					CASE stato IS
					
					WHEN S0_RESET =>
						stato <= S1_IDLE;
						
					WHEN S1_IDLE =>
						IF load_pattern = '1' THEN
							stato <= S2_WAIT ;
						ELSE	
							stato <= S1_IDLE;
						END IF;
								
					WHEN S2_WAIT =>
						IF match = '1' THEN
							stato <= S3_MATCH;
						ELSE	
							stato <= S2_WAIT;
						END IF;
					
					WHEN S3_MATCH =>
					IF trigger_ack='1' THEN
						stato <= S4_RESET_MATCH;
					ELSE 
					stato <= S3_MATCH;
					END IF;
					
					WHEN S4_RESET_MATCH=>
					stato <= S1_IDLE;
					
					WHEN OTHERS=>
				   stato <= S0_RESET;

				END CASE;
			END IF;
		END IF;
	END PROCESS;
	
	output_process: PROCESS (stato)
	BEGIN
		rst_sync <= '1';
		en_match <= '0';
		rst_dff<='1';

		CASE stato IS
			WHEN S0_RESET => 
				rst_sync <= '0';
				rst_dff<='0';
			WHEN S1_IDLE => 
				rst_sync <= '1';
			WHEN S2_WAIT =>
				en_match<='1';
				rst_sync <= '1';
			WHEN S3_MATCH =>
				rst_sync <= '1';
			WHEN S4_RESET_MATCH=>
				rst_dff<='0';
			WHEN OTHERS =>
				rst_sync <= '0';
				rst_dff<='0';
		END CASE;
	END PROCESS;
	
	-- datapath
	reg_match: FLIP_FLOP_D PORT MAP(en_match,clock,rst_dff,match,match_trigger);
	reg_pattern: DATA_REGISTER GENERIC MAP(N=>8)
	PORT MAP(load_pattern,clock,rst_sync,pattern,confronto);
	match<= ((input(0) XNOR confronto(0)) AND (input(1) XNOR confronto(1)) AND (input(2) XNOR confronto(2)) AND (input(3) XNOR confronto(3)) 
	AND (input(4) XNOR confronto(4)) AND (input(5) XNOR confronto(5)) AND (input(6) XNOR confronto(6)) AND (input(7) XNOR confronto(7)));
END behavior;