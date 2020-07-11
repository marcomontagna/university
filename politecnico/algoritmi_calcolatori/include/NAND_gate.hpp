#ifndef NAND_GATE_H
#define NAND_GATE_H
#include "Logic_Gates.hpp"

class NAND_gate: public Logic_Gates
{
    public:
        NAND_gate();
        virtual ~NAND_gate();
        bool output(vector<Nodi_class*> *vett_punt);

    protected:

    private:
};

#endif // NAND_GATE_H
