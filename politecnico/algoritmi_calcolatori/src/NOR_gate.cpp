#include "NOR_gate.hpp"

NOR_gate::NOR_gate()
{
    //ctor
}

NOR_gate::~NOR_gate()
{
    //dtor
}



bool NOR_gate::output(vector<Nodi_class*> *vett_punt)
{
    bool flag_uno = 0; //oppure inizializzo con il primo valore dei vertici connessi a questa porta...
    unsigned int j;

    for (j = 0; j < (*vett_punt).size() ; j++)
    {

        if ((*(*vett_punt)[j]).get_bool() == 1)
        {
            flag_uno = 1;
        }

    }

    return !flag_uno;

}

