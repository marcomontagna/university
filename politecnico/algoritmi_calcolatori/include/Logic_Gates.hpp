#ifndef LOGIC_GATES_H
#define LOGIC_GATES_H
#include <vector>
#include "Nodi_class.hpp"
#include <iostream>



using namespace std;

class Logic_Gates
{
    public:
        Logic_Gates();
        virtual ~Logic_Gates();
        virtual bool output(vector<Nodi_class*> *vett_punt) = 0; //Passaggio con indirizzo, così uso i valori reali del vettore di input di ciascun nodo

    protected:

    private:
};

#endif // LOGIC_GATES_H
