#include "NOT_gate.hpp"
#include <iostream>
#include <stdlib.h>

NOT_gate::NOT_gate()
{
    //ctor
}

NOT_gate::~NOT_gate()
{
    //dtor
}



bool NOT_gate::output(vector<Nodi_class*> *vett_punt)
{
    //Inverto il valore booleano in uscita

    //Devo avere UN SOLO input nella lista dei nodi associati alla NOT (un solo ingresso)
    if ((*vett_punt).size() != 1)
    {
        cerr << "Errore, porta NOT deve avere un solo ingresso e una sola uscita!";
        exit(EXIT_FAILURE);
    }


    return !((*(*vett_punt)[0]).get_bool());
}
