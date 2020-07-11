#ifndef NOR_GATE_H
#define NOR_GATE_H
#include "Logic_Gates.hpp"

class NOR_gate: public Logic_Gates
{
    public:
        NOR_gate();
        virtual ~NOR_gate();
        bool output(vector<Nodi_class*> *vett_punt);

    protected:

    private:
};

#endif // NOR_GATE_H
