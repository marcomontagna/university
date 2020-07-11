LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_unsigned.all;

ENTITY DUT_handler IS
PORT(
  CLOCK_50,RESET:BUFFER STD_LOGIC;
  CANALE_INGRESSO: BUFFER STD_LOGIC;
  UART_RXD:in std_logic;
  UART_TXD: OUT STD_LOGIC
);  
END ENTITY DUT_handler;

ARCHITECTURE BEH OF DUT_handler IS
  
  CONSTANT PERIODO : TIME := 20 ns;
  CONSTANT RESET_TIME : TIME := 45 ns;

  COMPONENT COUNTER_NBIT IS
GENERIC (N:INTEGER);
PORT(
EN_COUNT, LOAD_COUNT,CLK,RESET	: IN STD_LOGIC;	--abilita conta, carica dato da cui iniziare a contare
COUNT_IN	:	IN STD_LOGIC_VECTOR((N-1) DOWNTO 0);	--dato da caricare in parallelo
COUNT_OUT	:	OUT STD_LOGIC_VECTOR((N-1) DOWNTO 0);
TC	:	OUT STD_LOGIC	--terminal count
);
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
	
	COMPONENT UART_TX is 
   PORT( 
			start_macchina:IN std_logic;
			Reset:IN std_logic;
			Data_In: In std_logic_vector(7 downto 0);
      CLOCK_50 :IN std_logic;
			Q: OUT std_logic;
			Done: OUT std_Logic);
end COMPONENT;

signal start_rx,done_rx,start_macchina,Done_tx,Q:std_logic;
signal out_rx,data_in_tx:std_logic_vector(7 downto 0);
signal flag:integer; 

type carattere is (uno,zero,conflitto,o_trasmesso,k_trasmesso,lf_trasmesso,cr_trasmesso,nulla);
  signal dato_trasmesso : carattere;
  type flagflag is (   idle, inviaF,attesa1, inviaPR,attesaokf,attesaflf,attesacrf, inviaT,attesa2, inviaTMSB,attesa3, inviaTLSB,attesaokt,attesaflt,attesacrt,
 inviaS,attesaoks,attesafls,attesacrs, inviaR,attesaokr,attesaflr,attesacrr,attesaprimadit,attesaprimadis,attesaprimadir);
  signal statotx: flagflag;

  BEGIN
    
    ricezione: UART_RX
		PORT MAP (start_RX, RESET, UART_RXD, CLOCK_50, out_RX, done_rx);
		  
		trasmissione: UART_TX PORT MAP(start_macchina, RESET,data_in_tx,CLOCK_50,Q,Done_tx);
		UART_TXD<=Q;  
 --test parte trasmissione 
  
process (clock_50,canale_ingresso,reset)
variable valore:integer;
variable flag: integer;
begin  
    if reset='0' then
      valore:=0;
      canale_ingresso<='0'; 
  else
 if valore=10 then
   valore:=0;
  if canale_ingresso='0' then
    canale_ingresso<='1';
  else 
    canale_ingresso<='0';
  end if;
else valore:=valore+1;
end if;
end if;
end process;

process(out_rx,reset)  --usato per poter leggere meglio i dati ricevuti dalla uart rx che lavora in modo indipendente e parallelo
  BEGIN
   if reset='0' then
      dato_trasmesso<=nulla; 
  else
    
    if out_rx="00110000" then
      dato_trasmesso<=zero;
      
    elsif out_rx="00110001" then
      dato_trasmesso<=uno;
    
     elsif out_rx="01111000" then
      dato_trasmesso<=conflitto;
    
         elsif out_rx="01001111" then
      dato_trasmesso<=o_trasmesso;
    
         elsif out_rx="01001011" then
      dato_trasmesso<=k_trasmesso;
    
           elsif out_rx="00001010" then
      dato_trasmesso<=lf_trasmesso;
    
            elsif out_rx="00001101" then
      dato_trasmesso<=cr_trasmesso;
  else
    dato_trasmesso<=nulla;
    
end if; end if;  
END PROCESS;

generazione_comandi: PROCESS(clock_50,reset,dato_trasmesso,done_tx)
variable conta: integer;

BEGIN
  
if reset='0' then
conta:=0;
statotx<=idle;
start_macchina<='0';
data_in_tx<="00000000";
ELSE IF CLOCK_50='1' AND CLOCK_50'EVENT THEN
  
case statotx is
when idle=>
  statotx<=inviaF;
  
when inviaF=>
  data_in_tx<="01000110";
  start_macchina<='1';
  statotx<=attesa1;
when attesa1=>
  start_macchina<='0';
  if done_tx='1' then
    statotx<=inviapr;
  else statotx<=attesa1;
  end if;
when inviapr=>
  data_in_tx<="00110000"; --invio 0
  start_macchina<='1';
  statotx<=attesaokf;
  
when attesaokf=>
  start_macchina<='0';
  if dato_trasmesso=o_trasmesso then
  statotx<=attesaflf;
  else statotx<=attesaokf;
  end if;
when attesaflf=>
  if dato_trasmesso=lf_trasmesso then
  statotx<=attesacrf;
else statotx<=attesaflf;
end if;
when attesacrf=>
  if dato_trasmesso=cr_trasmesso then
  statotx<=attesaprimadit;
else statotx<=attesacrf;
end if; 

when attesaprimadit=>
conta:=conta+1 ; 
if conta=5000 then
statotx<=inviaT;
else 
statotx<=attesaprimadit;
end if;
  
when inviaT=>  
    data_in_tx<="01010100";
  start_macchina<='1';
  statotx<=attesa2;  
  conta:=0;

when attesa2=>
  start_macchina<='0';
  if done_tx='1' then
    statotx<=inviaTMSB;
  else statotx<=attesa2;
  end if;
when inviatmsb =>
      data_in_tx<="00110101"; --invia F in ASCII
  start_macchina<='1';
  statotx<=attesa3;
when attesa3=>
  start_macchina<='0';
  if done_tx='1' then
    statotx<=inviaTLSB;
  else statotx<=attesa3;
  end if;  
 when inviatlsb =>
      data_in_tx<="00110101"; --invia 3 in ASCII
  start_macchina<='1';
  statotx<=attesaokt;
    
 when attesaokt=>
   start_macchina<='0';
  if dato_trasmesso=o_trasmesso then
  statotx<=attesaflt;
else statotx<=attesaokt;
end if;
when attesaflt=>
  if dato_trasmesso=lf_trasmesso then
  statotx<=attesacrt;
else statotx<=attesaflt;
end if;
when attesacrt=>
  if dato_trasmesso=cr_trasmesso then
  statotx<=inviaS;
else statotx<=attesacrt;
end if;    
   
 when attesaprimadis=>
conta:=conta+1 ; 
if conta=5000 then
statotx<=inviaS;
else 
statotx<=attesaprimadis;
end if;  
   
when inviaS =>
       data_in_tx<="01010011"; --invia S start
  start_macchina<='1';
  statotx<=attesaoks;
  conta:=0; 
 when attesaoks=>
   start_macchina<='0';
  if dato_trasmesso=o_trasmesso then
  statotx<=attesafls;
else statotx<=attesaoks;
end if;   
when attesafls=>
  if dato_trasmesso=lf_trasmesso then
  statotx<=attesacrs;
else statotx<=attesafls;
end if;
when attesacrs=>
  if dato_trasmesso=cr_trasmesso then
  statotx<=attesaprimadir;
else statotx<=attesacrs;
end if;  

 when attesaprimadir=>
conta:=conta+1 ; 
if conta=40000 then
statotx<=inviaR;
else 
statotx<=attesaprimadir;
end if;  

when inviaR =>
       data_in_tx<="01010010"; --invia R READ
  start_macchina<='1';
  statotx<=attesaokr; 
  
 when attesaokr=>
   start_macchina<='0';
  if dato_trasmesso=o_trasmesso then
  statotx<=attesaflr;
else statotx<=attesaokr;
end if;   
when attesaflr=>
  if dato_trasmesso=lf_trasmesso then
  statotx<=attesacrr;
else statotx<=attesaflr;
end if;
when attesacrr=>
  if dato_trasmesso=cr_trasmesso then
  statotx<=attesacrr;
else statotx<=attesacrr;
end if;  


 END CASE;
  END IF;  END IF;  
END PROCESS;   
   
RESET <= '0', '1' AFTER RESET_TIME;

GENERATORE_CLOCK :PROCESS
   BEGIN
        CLOCK_50 <= '0';
        WAIT FOR PERIODO/2;  --SEGNALE A 0 PER MEZZO PERIODO
        CLOCK_50 <= '1';
        WAIT FOR PERIODO/2;  --SEGNALE A 1 PER MEZZO PERIODO
   END PROCESS; 
   
END BEH;