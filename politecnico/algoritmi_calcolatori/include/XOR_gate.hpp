#ifndef XOR_GATE_H
#define XOR_GATE_H
#include "Logic_Gates.hpp"

class XOR_gate: public Logic_Gates
{
    public:
        XOR_gate();
        virtual ~XOR_gate();
        bool output(vector<Nodi_class*> *vett_punt);

    protected:

    private:
};

#endif // XOR_GATE_H
