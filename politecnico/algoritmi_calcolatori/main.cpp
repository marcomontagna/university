#include <iostream>
#include <string>
#include "ReadFile.hpp"


using namespace std;

int main()
{
    string name_f;
    cout << "Inserire nome file con descrizione circuito: ";
    cin >> name_f;

    ReadFile lettura;
    lettura.set_fname(name_f);
    lettura.readFile();

    cout << "Inserire nome file con i valori degli input: ";
    cin >> name_f;

    lettura.read_input(name_f);


    return 0;
}

/*
FUNZIONI DA DEBUGGARE:
- Read_inputs per vedere se assegna correttamente i valori di input
- ho fatto una funzione per stampare i valori degli input attaccati ad una porta e la dimenzione della lista input di tale porta STAMPA_GATE()
- bisogna debuggare la funzione di elaborazione con quella ricorsiva (dovrebbe funzionare in teoria ma non lo fa)
- controllare complessita, si incrementa qualche volta di troppo*/
