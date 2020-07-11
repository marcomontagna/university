#ifndef AND_GATE_H
#define AND_GATE_H
#include "Logic_Gates.hpp"

using namespace std;

class AND_gate: public Logic_Gates
{
    public:
        AND_gate();
        virtual ~AND_gate();
        bool output(vector<Nodi_class*> *vett_punt);

    protected:

    private:
};

#endif // AND_GATE_H
