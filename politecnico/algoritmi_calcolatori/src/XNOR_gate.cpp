#include "XNOR_gate.hpp"

XNOR_gate::XNOR_gate()
{
    //ctor
}

XNOR_gate::~XNOR_gate()
{
    //dtor
}


bool XNOR_gate::output(vector<Nodi_class*> *vett_punt)
{
    int contatore_1 = 0;

    unsigned int j;

    for (j = 0; j< (*vett_punt).size() ; j++)
    {
        // cout << "Xnor: " << (*(*vett_punt)[j]).get_name() << " " << (*(*vett_punt)[j]).get_bool() << " ";
        if((*(*vett_punt)[j]).get_bool() == 1)
        {
            contatore_1++;
        }

    }
    cout << endl;

    //numero di 1 DISPARI e diverso da 0
    if ((contatore_1 % 2 != 0) && (contatore_1 != 0))
    {
        return 0; //XNOR vale 0
    }

    else //numero di 1 PARI
    {
        return 1; //XNOR vale 1
    }

}

