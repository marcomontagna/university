#include "NAND_gate.hpp"

NAND_gate::NAND_gate()
{
    //ctor
}

NAND_gate::~NAND_gate()
{
    //dtor
}



bool NAND_gate::output(vector<Nodi_class*> *vett_punt)
{
    bool andoutput = 1; //oppure inizializzo con il primo valore dei vertici connessi a questa porta...
    unsigned int j;

    for (j = 0; j < (*vett_punt).size(); j++)
    {

        if ((*(*vett_punt)[j]).get_bool() == 0)
        {
            andoutput = 0;
        }
    }

    return !andoutput;
}

