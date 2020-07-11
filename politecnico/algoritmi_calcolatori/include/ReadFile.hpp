#ifndef READFILE_H
#define READFILE_H

#include <iostream>
#include <fstream> //file stream
#include <iomanip>
#include <string>
#include <cstdlib>
#include <vector>
#include <string>
#include <sstream>

#include "Nodi_class.hpp"

using namespace std;

class ReadFile
{
    public:
        ReadFile();
        virtual ~ReadFile();
        void stampa_video(); //-> stampo a video gli output, controllo

        void readFile();
        void read_input(string file_bool);
        void set_fname(string _filename);
        unsigned int controllo_gates(); //Utile per definire quante porte dovrò usare
        void elaborazione();
        void recur_calc(Nodi_class *nodo);
        void print();
        void print_complessita();
        void stampa_gate(); //Stampo a video le porte -> controllo
        void pulizia_val_bit();
        void calcolo_complex(Nodi_class *nodo);

    protected:


    private:
        vector<Nodi_class> input_list;
        vector<Nodi_class> net_list;
        vector<Nodi_class> U;
        vector<Nodi_class> outputs_list;
        string _filename;
        int _num_in;

        vector<int> flag_in;
        vector<int> flag_output;
        vector<int> flag_net;

        struct info_circuit
        {
             string _name;
             int _inputs, _outputs, _nets;
        } informazione;
        int _contatore_compl;

};

#endif // READFILE_H
