#ifndef OR_GATE_H
#define OR_GATE_H
#include "Logic_Gates.hpp"

class OR_gate: public Logic_Gates
{
    public:
        OR_gate();
        virtual ~OR_gate();
        bool output(vector<Nodi_class*> *vett_punt);

    protected:

    private:
};

#endif // OR_GATE_H
