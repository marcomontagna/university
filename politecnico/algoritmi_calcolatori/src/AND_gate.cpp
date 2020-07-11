#include "AND_gate.hpp"
#include <iostream>

using namespace std;

AND_gate::AND_gate()
{
    //ctor
}

AND_gate::~AND_gate()
{
    //dtor
}


bool AND_gate::output(vector<Nodi_class*> *vett_punt)
{

    bool andoutput = 1; //oppure inizializzo con il primo valore dei vertici connessi a questa porta...
    unsigned int j;

    for (j = 0; j < (*vett_punt).size(); j++)
    {
        //funzione usata per stampare gli input della porta and in uso
        //cout << "and: " << (*(*vett_punt)[j]).get_name() << "  "  <<(*(*vett_punt)[j]).get_bool() << " ";

        andoutput = andoutput * (*(*vett_punt)[j]).get_bool();
    }
    return andoutput;
}

