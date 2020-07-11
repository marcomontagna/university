#ifndef XNOR_GATE_H
#define XNOR_GATE_H
#include "Logic_Gates.hpp"

class XNOR_gate: public Logic_Gates
{
    public:
        XNOR_gate();
        virtual ~XNOR_gate();
        bool output(vector<Nodi_class*> *vett_punt);

    protected:

    private:
};

#endif // XNOR_GATE_H
