#include "XOR_gate.hpp"

XOR_gate::XOR_gate()
{
    //ctor
}

XOR_gate::~XOR_gate()
{
    //dtor
}


bool XOR_gate::output(vector<Nodi_class*> *vett_punt)
{

    int contatore_1 = 0;

    unsigned int j;

    for (j = 0; j< (*vett_punt).size() ; j++)
    {
        //controllo
        //cout << "Xor: " << (*(*vett_punt)[j]).get_name() << " " << (*(*vett_punt)[j]).get_bool() << " ";

        if((*(*vett_punt)[j]).get_bool() == 1)
        {
            contatore_1++;
        }

    }

    //numero di 1 DISPPARI, cioè contatore_1 non è divisibile per 2 && NON vale 0
    if ((contatore_1 % 2 != 0) && (contatore_1 != 0))
    {
        return 1; //XOR vale 1
    }

    else //numero di 1 PARI
    {
        return 0; //XOR vale 0
    }


}
