#ifndef NOT_GATE_H
#define NOT_GATE_H
#include "Logic_Gates.hpp"

class NOT_gate: public Logic_Gates
{
    public:
        NOT_gate();
        virtual ~NOT_gate();
        bool output(vector<Nodi_class*> *vett_punt);

    protected:

    private:
};

#endif // NOT_GATE_H
