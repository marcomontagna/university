LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY TESTBENCH IS
END ENTITY TESTBENCH;
ARCHITECTURE TEST OF TESTBENCH IS
  
SIGNAL   GPIO_1: STD_LOGIC_VECTOR(35 DOWNTO 0);
SIGNAL   CLOCK_50:STD_LOGIC;
SIGNAL   KEY: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL			SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N:  STD_LOGIC;	--segnali controllo verso la SRAM 
SIGNAL			SRAM_ADDR	:	 STD_LOGIC_VECTOR(4 DOWNTO 0);	--indirizzo in uscita verso la SRAM
SIGNAL			SRAM_DQ	:	STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in uscita verso la SRAM
SIGNAL			UART_RXD:  STD_LOGIC;
SIGNAL			UART_TXD:  STD_LOGIC;
SIGNAL canale_ingresso,RESET: STD_LOGIC;

COMPONENT single_port_ram is
	generic 
	(
		DATA_WIDTH : integer := 16;
		ADDR_WIDTH : integer := 5 --simuliamo con 32 locazioni 
	);

	port 
	(
		CE_N,OE_N, WE_N: in std_logic;
		addr	: in std_logic_vector((ADDR_WIDTH - 1) downto 0);
		sram_dq	: inout std_logic_vector((DATA_WIDTH-1) downto 0)
	);
end COMPONENT;
  
COMPONENT DUT_HANDLER IS
PORT(
  CLOCK_50,RESET:BUFFER STD_LOGIC;
  CANALE_INGRESSO: BUFFER STD_LOGIC;
  UART_RXD:in std_logic;
  UART_TXD: OUT STD_LOGIC
);  
END COMPONENT; 

COMPONENT Logic_analyzer IS
	PORT (
			GPIO_1: IN STD_LOGIC_VECTOR(35 DOWNTO 0);
			CLOCK_50: IN STD_LOGIC;
			KEY : STD_LOGIC_VECTOR( 3 downto 0);
			SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N: OUT  STD_LOGIC;	--segnali controllo verso la SRAM 
			SRAM_ADDR	:	OUT STD_LOGIC_VECTOR(4 DOWNTO 0);	--indirizzo in uscita verso la SRAM
			SRAM_DQ	:	INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);	--dato in uscita verso la SRAM
			UART_RXD: IN STD_LOGIC;
			UART_TXD: OUT STD_LOGIC);
END COMPONENT;

BEGIN
  
gestore_dut:DUT_HANDLER port map(CLOCK_50,RESET,CANALE_INGRESSO,UART_TXD,UART_RXD);
  
KEY(0)<=RESET;
GPIO_1(35 downto 1)<=(others=>'0');
GPIO_1(0)<=canale_ingresso;

dut:Logic_analyzer PORT MAP
(GPIO_1, 
CLOCK_50, KEY,
SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N,
SRAM_ADDR,
SRAM_DQ,
UART_RXD,
UART_TXD);  

SSRAM: single_port_ram
GENERIC MAP (DATA_WIDTH=>16, ADDR_WIDTH=>5)
PORT MAP (SRAM_CE_N, SRAM_OE_N, SRAM_WE_N, SRAM_ADDR, SRAM_DQ);

  
END TEST;