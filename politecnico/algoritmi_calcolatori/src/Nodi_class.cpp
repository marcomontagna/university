#include "Nodi_class.hpp"
#include <vector>
#include <iostream>
#include <stdlib.h>
#include "AND_gate.hpp"
#include "NAND_gate.hpp"
#include "OR_gate.hpp"
#include "XOR_gate.hpp"
#include "NOR_gate.hpp"
#include "NOT_gate.hpp"
#include "XNOR_gate.hpp"



Nodi_class::Nodi_class()
{
    //Inizializzo come vuota la lista di input, perché i primi nodi di input non hanno niente collegato ad essi
    puntatore_in.clear();

    //Validity Bit inizializzato a 0 perché non ho ancora letto nulla
    _validity_bit = 0;

    //imposto il nome come vuoto > poi lo cambierò...
    _name.clear();

    //inizializzo come vuota la stringa di tipo_porta (input,output e nets non hanno porta)
    _porta.clear();

    _valore_logico = 0; //imposto a zero per vedere se gli output variano

    _complessita_nodo = 0; //usato per contare il numero di NET e la complessita di un certo output

    //ctor
}

Nodi_class::~Nodi_class()
{
    //dtor
}

bool Nodi_class::get_bool() //restituisce il valore booleano assunto da questo nodo
{
    return _valore_logico;
}

void Nodi_class::set_name(string nome) //setto il nome simbolico della porta U1...
{
    _name = nome;
}

void Nodi_class::set_bool(int value) //per settare il valore booleano -> utile per gli input del circuito I1,I2,...
{
    if (value == 0 )
    {
        _valore_logico = 0;
    }

    else if (value == 1)
    {
        _valore_logico = 1;
    }

    else
        {
            cerr << "Valore logico errato!" << endl;
            exit(EXIT_FAILURE);
        }


}


void Nodi_class::set_tipo_porta(string tipo_porta)
{
    _porta = tipo_porta;
}




void Nodi_class::lettura_corretta_nodo() //setto a 1 il VB se leggo correttamente
{
    _validity_bit = 1;
}


bool Nodi_class::get_val_bit() //restituisco il VB
{
    return _validity_bit;
}



string Nodi_class::get_name()
{
    return _name;
}

void Nodi_class::set_compl(int num_com)
{
    _complessita_nodo = num_com;
}

int Nodi_class::get_complessita()
{
    return _complessita_nodo;
}

vector<Nodi_class*> Nodi_class::restituisci_vettore_p()
{
    return puntatore_in;

}



void Nodi_class::funzione_uscita()
{
    int flag_porta = 0;
    // vector<string> nomi_porte = {"AND", "NAND", "OR", "XOR", "NOT", "NOR"}; -> vettore di stringhe per confrontare i nomi delle porte
    if (_porta == "AND")
    {
        AND_gate porta_and;
        _valore_logico = porta_and.output(&puntatore_in);
        //n_valore_logico = andgate();
        flag_porta ++;
    }

    if (_porta == "NAND" )
    {
        NAND_gate porta_nand;
        _valore_logico = porta_nand.output(&puntatore_in);
        flag_porta ++;
    }

    if (_porta == "OR")
    {
        OR_gate porta_or;
        _valore_logico = porta_or.output( &puntatore_in);
        flag_porta ++;
    }

    if (_porta == "NOR")
    {
        NOR_gate porta_nor;
        _valore_logico = porta_nor.output(&puntatore_in);
        flag_porta ++;
    }

    if (_porta == "XOR")
    {
        XOR_gate porta_xor;
        _valore_logico= porta_xor.output(&puntatore_in);
        flag_porta ++;
    }


    if (_porta == "NOT")
    {
        NOT_gate porta_not;
        _valore_logico = porta_not.output(&puntatore_in);
        flag_porta ++;
    }

    if (_porta == "XNOR")
    {
        XNOR_gate porta_xnor;
        _valore_logico = porta_xnor.output(&puntatore_in);
        flag_porta ++;
    }



    if(_name[0] == 'N' || _name[0] == 'O') //Nelle net e negli output il valore logico è uguale a quello uscente dalla porta dela sua lista
    {
        _valore_logico = (*puntatore_in[0]).get_bool();
        flag_porta ++;
    }

    if (flag_porta == 0)
    {
        cerr << "Errore: nome porta non trovato";
        exit(EXIT_FAILURE);
    }
}


void Nodi_class::aggiungi_punt_in(Nodi_class* punt_in)
{
    puntatore_in.push_back(punt_in);
}

int Nodi_class::dimensione_punt_in()
{
    return (puntatore_in.size());
}

string Nodi_class::get_tipo_porta() //funzione usata per controllare che le porrte siano assegnate correttamente
{
    return _porta;
}

void Nodi_class::svuota_lettura() //Utile ad ogni 'giro' in cui leggo gli input per reinizializzare tutti i validity_bit
{
    _validity_bit = 0;
}

