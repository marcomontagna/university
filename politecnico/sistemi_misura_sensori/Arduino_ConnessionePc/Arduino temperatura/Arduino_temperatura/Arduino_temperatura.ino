
void setup() {

	Serial.begin(9600);
	analogReference(INTERNAL);

	int prova = analogRead(A5);
	delay(10);
}

void loop() {
	unsigned int N = analogRead(A5);
	float tensione_VREF = 1.0972;
	float H = 0.3133032621;
	int K = 100;
	float temperatura = (tensione_VREF / 1024 * N / H) * K - 273.15;
	Serial.println("temperatura calcolata con arduino= ");
	Serial.println(temperatura, 7);
	Serial.println("ADC= ");
	Serial.println(N);
	delay(2000);
}