LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY sampler IS
	PORT (input, clk, sample, rst_as_n : IN STD_LOGIC;
			D: BUFFER STD_LOGIC;
			P: OUT STD_LOGIC);
END sampler;

ARCHITECTURE behavior OF sampler IS

COMPONENT D_FF_RST_AS 
	PORT ( input, clock, reset_as_n: IN STD_LOGIC;
			Q: OUT STD_LOGIC);
END COMPONENT;

COMPONENT FLIP_FLOP_D IS
PORT(
EN_REG,CLK,RESET	: IN STD_LOGIC;	--segnale di enable, reset e clock
DATA_REG_IN	:	IN STD_LOGIC;	--dato in ingresso
DATA_REG_OUT	:	OUT STD_LOGIC --dato in uscita
);
END COMPONENT;

TYPE state_type IS (S0_RESET, S1_IDLE, S2_SAMPLE);
SIGNAL stato: state_type;
SIGNAL past_D, rst_sy_n1, rising, falling: STD_LOGIC;
SIGNAL P1, P2, P3, P4: STD_LOGIC;
SIGNAL rising_flag, falling_flag,input_n: STD_LOGIC;


BEGIN

	-- control unit
	state_update: PROCESS (clk, rst_as_n)
	BEGIN
				IF (clk'EVENT AND clk = '1') THEN
		
		IF (rst_as_n = '0') THEN
			stato <= S0_RESET;
			ELSE
				CASE stato IS
					WHEN S0_RESET =>
						stato <= S1_IDLE;
					WHEN S1_IDLE =>
						IF sample ='1' THEN
							stato <= S2_SAMPLE;
						ELSE	
							stato <= S1_IDLE;
						END IF;
					
					WHEN S2_SAMPLE =>
						stato <= S1_IDLE;
					WHEN OTHERS =>
					stato <=S0_RESET;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	
	output_process: PROCESS (stato)
	BEGIN
		rst_sy_n1 <= '1';
		
		CASE stato IS
			WHEN S0_RESET => 
				rst_sy_n1 <= '0';
			WHEN S1_IDLE => 
				rst_sy_n1 <= '1';
			WHEN S2_SAMPLE =>
				rst_sy_n1 <= '0';
				
		END CASE;
	END PROCESS;
	
	-- datapath
	reg_D: FLIP_FLOP_D PORT MAP (sample,clk,rst_as_n,input, D);
	eg_pastD: FLIP_FLOP_D PORT MAP (sample,clk,rst_as_n,D, past_D);
  input_n<=not input;
	rise_detector_as: D_FF_RST_AS PORT MAP ('1', input, rst_sy_n1, rising);
	fall_detector_as: D_FF_RST_AS PORT MAP ('1', input_n, rst_sy_n1, falling);
	
	rise_register: FLIP_FLOP_D PORT MAP(sample,clk,rst_as_n,rising,rising_flag); 
	fall_register: FLIP_FLOP_D PORT MAP(sample,clk,rst_as_n,falling,falling_flag); 
	
	-- come scrivo rilevatore di glitch, a livello comportamentale come si scrive
	P1 <= not(D) AND not(past_D) AND rising_flag; --giusto
	P2 <= not(D) AND (past_D) AND rising_flag; --giusto
	P3 <= D AND past_D AND falling_flag; --giusto
	P4 <= D AND not(past_D) AND falling_flag;--giusto

	P <= P1 OR P2 OR P3 OR P4;

END behavior;

