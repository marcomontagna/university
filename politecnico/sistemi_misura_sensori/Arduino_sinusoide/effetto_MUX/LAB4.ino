String command;
int ADC_PR = 1024;
int timer_PR = 1024;
int ADC_ref = 0; 
int analog_in = 0;
int analog_in1 = 1;
int samples=0;
int samples1=0;
int thA = 5000;
int i = 0;
int k = 0;
int flag_canale = 0;
unsigned int samples_vector[200]; 
unsigned int samples_vector1[200]; 

bool stampa = 0;

// conti fatti con sinusoide a 100 Hz, decido di avere circa 100 campioni, uno ogni 500 micros
// devo arrivare con timer a contare fino a 500 micros

void setADCScaler(int scaler) {
  //ADCSRA &= 0xD8; //clear first 3 bits: enable, start, no adate, flag pulito, interrupt on, altri 3 bit a 0
  ADCSRA &= ~(1<<ADPS2);
  ADCSRA &= ~(1<<ADPS1);
  ADCSRA &= ~(1<<ADPS0);
  switch (scaler) {
    case 2:
      ADCSRA |= 1;
      break;
    case 4:
      ADCSRA |= 2;
      break;
    case 8:
      ADCSRA |= 3;
      break;
    case 16:
      ADCSRA |= 4;
      break;
    case 32:
      ADCSRA |= 5;
      break;
    case 64:
      ADCSRA |= 6;
      break;
    case 128:
      ADCSRA |= 7;
      break;
    default:
      ADCSRA |= 7;
  }
}


void setup() {
  
  ADMUX = 0xC2; // 1.1 V e pin A2 (puoi mettere quello che vuoi)
  ADCSRA = 0b11010111; //adc enable, adc start conversion, pulisco il flag di fine conversione, disabilito l'interrupt, prescaler a 128 (f campionamento: 16M/128 = 125k): dummy read
  ADCSRB = 0x00;

  Serial.begin(115200);
}

void loop() {

  if (Serial.available()) {
    char inChar = Serial.read();
    if (inChar == '\n') {
      i=0;  
      // formato da mandare in seriale prescalerADC, prescalerTimer, ADC_reference, ingresso analogico, numero campioni
      // scelgo il numero di campioni ai calcoli: calcolo ogni quanto esce un dato tramite prescaler ADC, vedo poi ogni quanto incrementa il timer, prendo sinusoide e guardo più o meno il periodo
      sscanf(command.c_str(), "%*s %d %d %d %d %d %d %d", &ADC_PR, &timer_PR, &ADC_ref, &analog_in, &analog_in1, &samples, &thA);

      // registro ADMUX
      // imposto Vref
      if (ADC_ref == 0) { // 5V
        ADMUX &=~ (1<<REFS1);
        ADMUX |=  (1<<REFS0);       
      }
      else { // 1.1V
        ADMUX |=  (1<<REFS1);
        ADMUX |=  (1<<REFS0); 
      }
      ADMUX &=~(1<<ADLAR);
      //imposto il canale tramite quello che gli ho passato in linea seriale
      ADMUX &= 0xF0; 
      ADMUX |= analog_in;
      flag_canale = 0;
      
      //registro ADCSRA: enable, flag e abilitazione interrupt, adsc e prescaler
      ADCSRA = 0x98;      //abilitato, adsc no, adate no, adif sì, adie sì, prescaler a 0 (l'adsc lo setta solo il timer), Ema vai a vederti tutto come fanno
      setADCScaler(ADC_PR);
     // ADCSRB = 0x00;

      
      TCCR1A = 0x00;  // modalità ctc
      TCCR1B = 0x08;  // modalità ctc e prescaler a 0, tanto poi arriva switch prescaler e lo ricorreggo
      // prescaler del timer 
      switch(timer_PR) {
        case 0:
          TCCR1B |= 0;
        break;
        case 1:
          TCCR1B |= 1;
        break;
        case 8:
          TCCR1B |= 2;
        break;
        case 64:
          TCCR1B |= 3;
        break;
        case 256:
          TCCR1B |= 4;
        break;
        case 1024:
          TCCR1B |= 5;
        break;
        default:
          TCCR1B |= 5;  //1024
        break;
      } 
      
      TCNT1 = 0;
      OCR1A = thA-1; // -1 controlla sulla slide, è spiegato
      TIFR1 = 0x27;   //pulisco tutti i flag
      TIMSK1 = 0x02;  //abilito interrupt soglia A
      
      command = ""; // pulisco il comando
    }
    else {
      command += inChar; // li sto concatendando
    }
  }

  if (stampa == 1) { 
    stampa = 0;
    Serial.println("primo canale");
    for (i = 0; i < samples; i++)  
      Serial.println(samples_vector[i]);
      
    Serial.println("secondo canale");
    for (i = 0; i < samples1; i++)  
      Serial.println(samples_vector1[i]);
  }
}

ISR (ADC_vect) {
//Serial.println("isrADC");  
  ADCSRA |= (1<<ADIF);  // clear flag
    
  if (i < samples || k < samples1) {
    if (flag_canale == 0) {
    samples_vector[i] = ADC;  // salvo valore
    i++;
    ADMUX |= analog_in1;
    flag_canale = 1;
    
    }
    else {
    samples_vector1[k] = ADC;  // salvo valore
    k++;
    ADMUX |= analog_in;
    flag_canale = 0;
    }
  }
  else { 
    // quando entro qui significa che ho campionato tutto e resetto tutti i bit, spengo timer...                   
    ADCSRA &= ~(1<<ADEN);
    ADCSRA &= ~(1<<ADIE);
    TCCR1B &= ~(1<<CS12);
    TCCR1B &= ~(1<<CS11);
    TCCR1B &= ~(1<<CS10);
    stampa = 1;
  }
}

ISR (TIMER1_COMPA_vect) {
//Serial.println("isrTIM");  
  TIFR1 |=  (1<<OCF1A);   //pulisco il flag
  ADCSRA |= (1<<ADSC);    //faccio partire l'adc
}

// posso spingermi al massimo fino a 90 campioni circa
