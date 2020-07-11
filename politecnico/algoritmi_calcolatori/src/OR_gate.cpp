#include "OR_gate.hpp"

OR_gate::OR_gate()
{
    //ctor
}

OR_gate::~OR_gate()
{
    //dtor
}



bool OR_gate::output(vector<Nodi_class*> *vett_punt)
{
    bool flag_uno = 0; //oppure inizializzo con il primo valore dei vertici connessi a questa porta...
    unsigned int j;

    for (j = 0; j < (*vett_punt).size() ; j++)
    {
        //funzione di controllo
        //cout << "or: "<< (*(*vett_punt)[j]).get_name() << " "  << (*(*vett_punt)[j]).get_bool() << " ";

        if ((*(*vett_punt)[j]).get_bool() == 1)
        {
            flag_uno = 1;
        }


    }

    return flag_uno;

}
