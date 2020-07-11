#ifndef NODI_CLASS_H
#define NODI_CLASS_H
#include <list>
#include <string>
#include <vector>

using namespace std;


class Nodi_class
{
    public:
        Nodi_class();
        virtual ~Nodi_class();
        void funzione_uscita();
        bool get_bool(); //restituisce il valore booleano assunto da questo nodo
        void set_name(string nome); //setto il nome simbolico della porta U1...
        void set_bool(int value); //per settare il valore booleano -> utile per gli input del circuito I1,I2,...
        void set_tipo_porta (string tipo_porta); //setto il tipo di porta, se il nodo è una porta
        void lettura_corretta_nodo(); //setto a 1 il VB se leggo correttamente
        bool get_val_bit(); //restituisco il VB
        void svuota_lettura();

        string get_name(); //resituisco il nome del nodo -> per il controllo

        void set_compl(int num_com); //aumento la complessita del nodo (ho trovato una NET o una PORTA)
        int get_complessita(); //restituisco la complessita del nodo
        vector<Nodi_class*> restituisci_vettore_p();
        void aggiungi_punt_in(Nodi_class* punt_in);
        int dimensione_punt_in();
        string get_tipo_porta();



    protected:
    private:
        bool _validity_bit; //controllo se la funzione della porta ha agito correttamente (ho tutti gli input in entrata calcolati)
        string _name; //il nome simbolico della porta (U1,U2,...)
        string _porta; //tipo di porta rappresentato dal nodo
        bool _valore_logico;
        int _complessita_nodo; //utile per gli output -> net e porte aumentano la complessita
        vector<Nodi_class*> puntatore_in;

};

#endif // NODI_CLASS_H
