-- datapath dlx project
-- anno scolastico 2017/2018
-- microelectronic systems
-- Montagna Marco, Pistilli Francesca

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.globals.all;
use work.log2_function.all;

entity datapath is 
	generic(reg_size : integer := 32); -- dimensione registri nel datapath
	port (

		-- comandi generali datapath
		clk: in std_logic; -- clock per tutto il datapath
		rst: in std_logic; -- reset attivo basso
		-- pipe stage 1 commands
		flush: in std_logic;
		RF1: in std_logic; -- register file porta 1 lettura
		RF2: in std_logic; -- register file porta 2 lettura
		WF1: in std_logic; -- scrittura rf
		EN_regA: in std_logic; -- abilito registri del primo stage di pipe
		EN_regB: in std_logic; -- abilito registri del primo stage di pipe
		EN_regIMM: in std_logic; -- abilito registri del primo stage di pipe
		EN_regALUOP: in std_logic;
		EN_regRD1: in std_logic;
		EN_regNPC2: in std_logic;
		-- pipe stage 2 commands
		S1: in std_logic; -- comando mux prima porta rf
		S2: in std_logic; -- sel mux seconda porta rf
		-- magari se vogliamo aggiungere altre operazioni dobbiamo inserire qui
		EN_regRET: in std_logic; -- abilito registri secondo stage di pipe
		EN_regOUTALU: in std_logic;
		EN_regB2: in std_logic;
		EN_regRD2: in std_logic;
		-- pipe stage 3 commands
		-- i primi due comandi sono i comandi della memoria, ma se la memoria non fosse un componente interno qui, ma qualcosa di esterno, allora non serve teoricamente che siano qui
		EN_regALU2: in std_logic; -- abilito registri 3o stadio di pipe
		EN_regLMD: in std_logic;
		EN_regRD3: in std_logic;
		Sel_ret_alu: in std_logic; -- mux uscita memoria
		Sel_alu_lmd: in std_logic; -- mux uscita memoria
		sel_31_rd: in std_logic;
		-- segnali della memoria dati
		-- input datapath
		NPC: in std_logic_vector (numbit -1 downto 0);
		IR_dp: in std_logic_vector (numbit -1 downto 0);
		-- output datapath
		OUT_DP: out std_logic_vector (numbit -1 downto 0); -- uscita dal datapath
		comp_branch_i: out std_logic;
		immediate_branch : out std_logic_vector(31 downto 0);
		-- altri comandi che potrebbero servire nel datapath, aggiungere qui
		-- segnali dram
		--ADD_mem : out  std_logic_vector(log2(reg_size) - 1 downto 0); --prima al posto di reg_size cìera row
		ADD_mem : out std_logic_vector(32- 1 downto 0);
	   	DIN_mem : out std_logic_vector(numbit - 1 downto 0);
		DOUT_mem : in std_logic_vector(numbit - 1 downto 0)
		
	);
	
end entity;

architecture behaviour of datapath is
	-- inserisco qui tutti i componenti
	component register_file is
	generic (NBIT: integer := 32;
		row: integer := 32);
 	port ( 
		CLK: 		IN std_logic;
   	RESET: 	IN std_logic;
	 	ENABLE: 	IN std_logic;
	 	RD1: 		IN std_logic;
	 	RD2: 		IN std_logic;
	 	WR: 		IN std_logic;
	 	ADD_WR: 	IN std_logic_vector(log2(row)-1 downto 0); -- devo ancora scegliere la dimensione del rf
	 	ADD_RD1: 	IN std_logic_vector(log2(row)-1 downto 0);
	 	ADD_RD2: 	IN std_logic_vector(log2(row)-1 downto 0);
	 	DATAIN: 	IN std_logic_vector(Nbit-1 downto 0);
    		OUT1: 		OUT std_logic_vector(Nbit-1 downto 0);
		OUT2: 		OUT std_logic_vector(Nbit-1 downto 0));
	end component;

	-- aggiungere blocco per estensione del segno, da controllare
	component SIG_EXT is 
	generic (
	         BITS: INTEGER := 32
	         );
	Port (	
	   EXT_UNSIGNED :  In	std_logic;
	   EXT_FOR_J :  In	std_logic;
	   S_IN:	In	std_logic_vector(BITS-1 downto 0); 
	   S_OUT:	Out	std_logic_vector(BITS-1 downto 0)
		);
	end component ;

	
	component mux21 is
	generic (N: integer:=32);
  	port (
    		A   : in std_logic_vector(N-1 downto 0);
    		B   : in std_logic_vector(N-1 downto 0);
    		SEL : in std_logic;
    		Y: out std_logic_vector(N-1 downto 0));
	end component;

	component registro is
	generic (N: integer := 32);
	port (
		data: in std_logic_vector(N-1 downto 0);
		enable, clock, clear: in std_logic;
		Q: out std_logic_vector(N-1 downto 0));
	end component;

	-- devo ancora inserire componente della alu qui
	-- component alu is
	component ALU is
  	generic (N : integer := NumBit);
 	 	port 	 ( AluOpCode: IN std_logic_vector(2 downto 0); -- selctor of which output operation choose (add/sub or and/or/xor or srl/sll)
	   		CompareOpCode: in std_logic_vector(3 downto 0); --selection of type of compare operation 				CompareOpCode(3)->beqz
--			CompareOpCode(2)->bnez
-- 			CompareOpCode(1)->sge
--			CompareOpCode(0)->sne   
	   		Add_subn: in std_logic; --id add=1 if sub =0
	   		ShiftOpCode:in std_logic_vector(2 downto 0);--specify the type of op for the shifter component: 
--			ShiftOpCode(2)->logic_arith
--     			ShiftOpCode(1)->LEFT_RIGHT
--			ShiftOpCode(0)->shift_rotate								
           		DATA1, DATA2: IN std_logic_vector(N-1 downto 0);
           		OUTALU: OUT std_logic_vector(N-1 downto 0);
           		return_address: buffer std_logic_vector(N-1 downto 0);
	   		CompBranch: out std_logic);
	end component;

	-- componente che genera i comandi per pilotare l'uscita dell'alu
	component AluOpCodeGen is
	port (IR_opcode: in std_logic_vector(5 downto 0);
      		IR_func: in std_logic_vector(10 downto 0);
      		AluOpCode: out std_logic_vector(2 downto 0);
      		Add_Subn: out std_logic;
      		CompareCode: out std_logic_vector(3 downto 0);
      		ShiftOpCode: out std_logic_vector(2 downto 0));
	end component;

	-- se voglio poi inserire altri componenti li devo inseirre qui sotto

	-- ora inizio elenco dei segnali del datapath
	-- segnali primo stadio di pipe
	-- constant nbit_dp: integer := 32; già inserito in globals
	-- segnali RF
	signal A, B : std_logic_vector (Numbit-1 downto 0);
	signal enable_rf: std_logic;
	-- segnali registri
	signal out_A, out_b, npc2, immediate, ext: std_logic_vector (Numbit-1 downto 0);
	signal out_rd1, signal_rd_in: std_logic_vector(log2(numbit)-1 downto 0);
	-- segnali scondo stadio di pipe
	signal out_mux_1, out_mux_2,b2: std_logic_vector (Numbit-1 downto 0);
	signal out_rd2: std_logic_vector(log2(numbit)-1 downto 0);
	signal aluopcode_reg_in, aluopcode_reg_out: std_logic_vector (16 downto 0);
	signal out_alu, reg_alu_in, return_alu, return_out: std_logic_vector (Numbit-1 downto 0);
	signal reset_pipe2 : std_logic;
	-- signal aluopcode, questi segnali bisogna poi aggiungerli alla alu
	signal aluopcode_i, shiftopcode_i: std_logic_vector(2 downto 0);
	signal add_sub_i: std_logic;
	signal compare_code_i: std_logic_vector(3 downto 0);
	-- out_me e out_alu sono i segnali che dovrei mandare alla memoria, devo capire se devo tenerli qui per mandarli al componente o mandari in uscita dal datapath
	-- segnali terzo stadio di pipe
	signal alu2, out_ret_alu, alu2_lmd, lmd, lmd_mem: std_logic_vector (Numbit-1 downto 0);
	signal rd3: std_logic_vector(log2(numbit)-1 downto 0);
	signal add_w_rf: std_logic_vector(log2(numbit)-1 downto 0); -- indirizzo scrittura rf

	-- inserire qui altri segnali aggiuntivi
	signal IR_opcode : std_logic_vector(5 downto 0);
        signal jump_op: std_logic;

	begin -- behaviour datapath

	-- primo stadio di pipe
  reset_pipe2<=not(flush or not(rst));
	enable_rf <= '1';		
	rf: register_file -- questo si potrebbe anche attivare nel terzo stadio di pipe, quando scrivo dentro il rf, perciò lascio a 1 l'enable del rf
	generic map (Numbit, Numbit) -- dimensione rf
	port map (clk, rst, enable_rf, rf1, rf2, WF1, add_w_rf, ir_dp(25 downto 21), ir_dp(20 downto 16), alu2_lmd, A, B); -- questo è da controllare, che significato hanno i comandi ! DA COMPLETARE BENE!

-- qui devo aggiungere il blocco per l'estensione del segno, si deve solo più sistemare questo blocco teoricamente

	estensione_segno: SIG_EXT
	port map('1', jump_op,ir_dp,ext); -- da completare oerche ex_unsigned sempre a 1

	reg_A: registro
	generic map (Numbit) -- dimensione reg
	port map (A, en_regA, clk, reset_pipe2, out_a);

	reg_B: registro
	generic map (Numbit) -- dimensione reg
	port map (B, en_regB, clk, reset_pipe2, out_b);

	reg_NPC2: registro
	generic map (Numbit) -- dimensione reg
	port map (npc, en_regNPC2, clk, rst, npc2);

	reg_IMMEDIATE: registro
	generic map (Numbit) -- dimensione reg
	port map (ext, en_regIMM, clk, rst, immediate);
	  
	  immediate_branch <= immediate;

	aluopcode_reg_in <= ir_dp(31 downto 26 )& ir_dp(10 downto 0);

	reg_aluopcode: registro
	generic map (17) -- dimensione reg
	port map (aluopcode_reg_in, EN_regALUOP, clk, rst, aluopcode_reg_out);
	


        IR_opcode(5 downto 0) <= IR_dp(opcode_up downto opcode_down);

	-- qui dovrei mettere un process che mi aggiorni il segnale di read perchè non è sempre lo stesso

	process (IR_dp, ir_opcode) -- si aggiorna ogni volta che cambia il tipo di istruzione che ho in ingresso, questo segnale non è presente e ne ho bisogno sia qui che nel blocco di extension del segno
	begin
		if (IR_opcode = RTYPE) then-- ho r_type
			signal_rd_in <= ir_dp(15 downto 11);
		elsif ((IR_opcode = J) or (IR_opcode = J_JAL)) then
			jump_op<='1';
		elsif ((IR_opcode = J_BEQZ) or (IR_opcode = J_BNEZ)) then
		jump_op<='0';
			
		else
			signal_rd_in <= ir_dp(20 downto 16);	
		end if;
	end process;
		
	reg_rd1: registro
	generic map (log2(Numbit)) -- dimensione reg
	port map (signal_rd_in, en_regRD1, clk, reset_pipe2, out_rd1);

	-- secondo stadio di pipe

	mux_in1_A: mux21
	generic map (Numbit) -- dimensione bit in out mux
	port map (out_a, npc2, s1, out_mux_1);

	mux_in1_B: mux21
	generic map (Numbit) -- dimensione bit in out mux
	port map (out_b, immediate, s2, out_mux_2);

	-- inserire qui il componente ALU
	alu_dlx: ALU
	generic map (Numbit)
	port map (aluopcode_i, compare_code_i, add_sub_i, shiftopcode_i, out_mux_1, out_mux_2, reg_alu_in, return_alu, comp_branch_i); -- da cmpletare

	alu_opcode_generator:  AluOpCodeGen
	port map (aluopcode_reg_out(16 downto 11), aluopcode_reg_out(10 downto 0), aluopcode_i, add_sub_i, compare_code_i, shiftopcode_i); 

	reg_alu_out: registro
	generic map (Numbit) -- dimensione reg
	port map (reg_alu_in, en_regOUTALU, clk, rst, out_alu);
	out_dp <= out_alu; -- questo è il segnale che mando indietro nel pc

	reg_b2: registro
	generic map (Numbit) -- dimensione reg
	port map (out_b, en_regB2, clk, rst, b2);	

	reg_rd2: registro
	generic map (log2(Numbit)) -- dimensione reg
	port map (out_rd1, en_regRD2, clk, rst, out_rd2);

	reg_return: registro
	generic map (Numbit) -- dimensione reg
	port map (return_alu, en_regRET, clk, rst, return_out);

	-- terzo stadio di pipe
	
	-- qui dovrei avere la memoria, devo capire se la devo mettere qui all'interno oppure no. Se sì allora 		devo fare come per ogni altro comonente, se no (dato che teoricamente le memorie non sono 		sintetizzabili) devo semplicemente mettere che i segnali necessari per pilotare la memoria vadano verso l'esterno
	-- TEORICAMENTE LO SI LASCIA FUORI
	-- quindi questi sono i segnali della dram che entrano ed escono dal datapath
	--. segnali che escono dal dp ed entrano nella dram
	add_mem <= out_alu;
	
	DIN_mem <= b2;
	-- segnali ch escono da dram ed entra nel dp
	lmd_mem <= DOUT_mem;

	mux_ret_alu: mux21 -- multiplexer che decide se saltare la memroia oppure no
	generic map (Numbit) -- dimensione bit in out mux
	port map (out_alu, return_out, sel_ret_alu, out_ret_alu);

	reg_alu2: registro -- registro di uscita
	generic map (Numbit) -- dimensione reg
	port map (out_ret_alu, en_regALU2, clk, rst, alu2);

	reg_lmd: registro -- registro di uscita
	generic map (Numbit) -- dimensione reg
	port map (lmd_mem, en_regLMD, clk, rst, lmd);

	reg_rd3: registro -- registro di uscita
	generic map (log2(Numbit)) -- dimensione reg
	port map (out_rd2, en_regRD3, clk, rst, rd3);

	mux_lmd_alu: mux21 -- multiplexer che decide se saltare la memroia oppure no
	generic map (Numbit) -- dimensione bit in out mux
	port map (alu2, lmd, sel_alu_lmd, alu2_lmd);

	mux_address_write: mux21 
	generic map (log2(numbit)) -- dimensione bit in out mux
	port map (rd3, "11111", sel_31_rd, add_w_rf);

	
end behaviour;

	
	
		
		 
