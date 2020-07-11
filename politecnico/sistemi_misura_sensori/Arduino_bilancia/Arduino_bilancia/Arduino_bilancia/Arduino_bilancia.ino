//programma C# arduino bilancia
//macro usate per settare i bit a 1 o 0
#ifndef sbi //macro  per settare singoli bit a 1 set bit
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit)) 
#endif 
#ifndef cbi//macro per settare singoli bit a 0 clear bit
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit)) 
#endif
#define peso_fondo_scala_ponte 2000 //peso fondo scala ponte in g
#define V_ref 1.0848	//tensione riferimento arduino
//parametri misurazione, flag e altre amenita'
unsigned int n_misure = 1000;			//numero di misure da effettuare
float tensione_ponte = 5.0;				//tensione alimentazione ponte espressa in [V]
float sensibilita_ponte = 0.000005;			//sensibilita' ponte a fondo scala espressa in [uV/g]
float media_ADC = 0.0;				//media tra le n_misure
float peso_misurato = 0.0;
float tot_misure = 0.0;					//flag di conteggio delle misure effettuate, all'inizio è impostato a 100 perchè l'autotaratura viene eseguita su 100 misure
int misure_eseguite=0;
int ADC_abilitato = 0;
int operazione = 0;					//seleziono operazione da eseguire:1-misura semplice; 2-taratura software; 3-autotaratura dello zero
int auto_taratura = 0;
int misure_temp = 0;
int peso_temp = 0;
float tensione_offset = 0.0;
float gain = 436; // guadagno, da modificare una volta ricalcolate le resistenze

float costante_taratura = sensibilita_ponte*gain; 

//parametri linea seriale
const int BUFFER_SIZE = 20; //ampiezza buffer
char commandBuffer[BUFFER_SIZE + 1];//spazio da allocare per i caratteri
int bufferPos = 0; //flag posizione puntatore buffer
char comando[30] = { 0 };
String command;

void clearBuffer() {//funzione usata per pulire il buffer di ricezione

	for (int i = 0; i<BUFFER_SIZE + 1; i++)
		commandBuffer[i] = (char)0;//scrive dei caratterri nulli nel buffer di ingresso 
	bufferPos = 0;
}
void clear_comando() {//funzione usata per pulire il valore di comando
	for (int i = 0; i<10; i++)
		comando[i] = (char)0;//scrive dei caratterri nulli nel buffer di ingresso 
}
//routine usata per salvare i dati in ingresso dalla linea seriale, mi basta definire questa funzione e arduino la lancia in automatico ogni volta che c'e' roba sulla linea seriale
void serialEvent() {
	char inChar = Serial.read(); //legge i dati disponibili nel registro di ingresso della linea seriale
	if (inChar == '\n') {
		command = commandBuffer;
		clearBuffer();	//pulisce buffer
	}
	else {
		if (bufferPos<BUFFER_SIZE - 1) {
			commandBuffer[bufferPos++] = inChar;
		}
		else {
			Serial.print("errore ricezione\n");
			clearBuffer();
		}
	}
}

void setup() {
	ADMUX = 0x41;//abilito riferimento tensione alimentazione, imposto left adjust e seleziono canale A3
	ADCSRA = 0x87;//abilito ADC, imposto prescaler a 128, freq ad=125kHz, 104us per misura
	sbi(ADCSRA, ADSC);	//eseguo prima lettura per inizializzare l'adc
	sbi(ADCSRA, ADIF); //pulisco flag interrupt adc
	pinMode(LED_BUILTIN, OUTPUT);	//utilizzo il led L montato sulla scheda per debuggare
	digitalWrite(LED_BUILTIN, LOW);	//inizializzo il led a spento	
 	Serial.begin(115200);//apro linea seriale con 115200bps
	delayMicroseconds(2000);
	sbi(ADCSRA, ADIE); //abilito generazione interrupt ADC, usata per entrare nella ISR dell'ADC

	clearBuffer();  //clean the input buffer
 }


void loop() {	
	if (ADC_abilitato == 1)
		sbi(ADCSRA, ADSC);
	sscanf(command.c_str(), "%*s %s %d %d ", &comando, &misure_temp,  &peso_temp );
	command = "";

	if (strcmp(comando, "meas") == 0)
	{ 
		n_misure = misure_temp;
		operazione = 1;
		ADC_abilitato = 1;
		clear_comando();
	}
	else
	{
		if (strcmp(comando, "tara") == 0)
		{
			peso_misurato = float(peso_temp);
			peso_misurato = peso_misurato / 100;

			operazione = 2;
			ADC_abilitato = 1;
			clear_comando();
		}
		else {
			if (strcmp(comando, "autotara") == 0)
			{

				auto_taratura = 0;
			}
			else {
				if (strcmp(comando, "test_tx") == 0)	//programma test invio dati
				{
					for (int conta = 0; conta < 100; conta++)
					{//stampo dei valori da 0 a 100 col # 
						Serial.print("§");
						Serial.println(conta);
						delay(10);
					}
					clear_comando();
				}
				else {
					if (strcmp(comando, "test_rx") == 0)	//programma test ricezione, fa lampeggiare 3 volte il led
					{//verifico la ricezione corretta dei dati inviati da C#
						digitalWrite(LED_BUILTIN, HIGH);
						delay(800);
						digitalWrite(LED_BUILTIN, LOW);
						delay(800);
						digitalWrite(LED_BUILTIN, HIGH);
						delay(800);
						digitalWrite(LED_BUILTIN, LOW);
						clear_comando();
					}

				}
			}
		}
	}

	if (misure_eseguite == 1)
	{
		if (operazione == 1)	//misura normale
		{
		
			peso_misurato = media_ADC / costante_taratura; 
			n_misure = 5000; //ripristino valore default di misure da effettuare
			Serial.print("#");
			Serial.println(peso_misurato);
			Serial.print("#");
			Serial.println(media_ADC);

			media_ADC = 0.0;
			tot_misure = 0.0;
			misure_eseguite = 0;
			operazione = 0;
		}
		else {
			if (operazione == 2)	//taratura con massa campione
			{
				costante_taratura = media_ADC / peso_misurato;
				Serial.println("taratura sensibilita' eseguita");
				Serial.flush();
				Serial.print("nuova costante di taratura (sensibilita_ponte/gain)': ");
				Serial.println(costante_taratura,3);
				operazione = 0;
				misure_eseguite = 0;
				tot_misure = 0.0;
				media_ADC = 0.0;
			}
			else
			{
				if (operazione == 3)	//auto taratura dello zero
				{
					if (media_ADC > 0)
						tensione_offset = media_ADC;
					else
						tensione_offset = -media_ADC;
					media_ADC = 0.0;
					Serial.println("auto taratura eseguita");
					Serial.println("tensione offset:");
					Serial.println(tensione_offset, 3);
					operazione = 0;
					misure_eseguite = 0;
					tot_misure = 0.0;
				}
			}
		}
	}
	if (auto_taratura == 0)
	{
		delay(50); //aspetto che si stabilizzi ulteriormente tensione di alimentazione
		operazione = 3;
		auto_taratura = 1;	
		ADC_abilitato = 1;
	}
}

ISR(ADC_vect) //usata per calcolare la tensione, inviare i dati e poi 
{
	media_ADC = media_ADC*tot_misure + (ADC / 1024.0 * tensione_ponte -tensione_offset);
	tot_misure=tot_misure+1;
	media_ADC = media_ADC / tot_misure;
	if (tot_misure == n_misure)
	{
		ADC_abilitato = 0;
		misure_eseguite = 1;
	}
}
