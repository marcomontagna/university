 #include "ReadFile.hpp"


using namespace std;

ReadFile::ReadFile()
{
    //ctor -> inizializzo tutto e imposto i vettori come vuoti
    _contatore_compl = 0;

    input_list.clear();
    net_list.clear();
    U.clear();
    outputs_list.clear();

    flag_in.clear();
    flag_net.clear();
    flag_output.clear();

    _num_in = 0;

}

ReadFile::~ReadFile()
{
    //dtor
}

void ReadFile::set_fname(string nomefile)
{
    _filename = nomefile;
}

void ReadFile::print_complessita()
{
    ofstream fout;
    fout.open("Output", ios::app);
    if(!fout.is_open())
    {
        cerr << "Errore apertura file output!" << endl;
        exit (EXIT_FAILURE);
    }

    fout << endl;
    int max_compl = 0;
    int i_max = 0;

    //con singolo accesso
    for (unsigned int j = 0; j<outputs_list.size(); j++)
    {
        fout << "Complessita' dell'output " << outputs_list[j].get_name() << " vale: " << outputs_list[j].get_complessita() << " (Net + Porte)" << endl;
        if (outputs_list[j].get_complessita() > max_compl)
        {
            max_compl = outputs_list[j].get_complessita();
            i_max = j;
        }

    }

    fout << "Output " << i_max << " e' il piu' complesso -> " << max_compl << " Net + Porte!" << endl;
    fout.close();
}


void ReadFile::stampa_video() //per controllo
{
    vector<Nodi_class>::iterator it;
    for(it = outputs_list.begin(); it != outputs_list.end(); it++)
    {
        cout << (*it).get_bool() << " ";
    }

    cout << endl;
}

void ReadFile::print()
{
    ofstream fout;
    fout.open("Output", ios::app);

    if(!fout.is_open())
    {
        cerr << "Errore apertura file output!" << endl;
        exit (EXIT_FAILURE);
    }

    vector<Nodi_class>::iterator it;
    for(it = outputs_list.begin(); it != outputs_list.end(); it++)
    {
        fout << (*it).get_bool() << " ";
    }
    fout << endl;

    fout.close();
}

//RECURSION
void ReadFile::calcolo_complex(Nodi_class *nodo) //passo con indirizzo -> cosi i valori si modificano davvero
{
    vector<Nodi_class*> vett_aux;
    vett_aux = (*nodo).restituisci_vettore_p();

    unsigned int j;
    for(j = 0; j < vett_aux.size(); j++)
    {

        string aux = (*vett_aux[j]).get_name();
        if ((aux[0] != 'I')&&(aux[0] != 'N'))
        {
            _contatore_compl++;
            calcolo_complex(&(*vett_aux[j]));

        }

    }
}


void recur_calc(Nodi_class *nodo);

void ReadFile::elaborazione()

{
    for (unsigned int j = 0; j<outputs_list.size(); j++)
    {
        _contatore_compl = 0;
        calcolo_complex(&outputs_list[j]);
        recur_calc(&outputs_list[j]); //passagio by indirizzo -> cosi sarà modificato
        outputs_list[j].set_compl(_contatore_compl);
    }
}

//RECURSION
void ReadFile::recur_calc(Nodi_class *nodo) //passo con indirizzo -> cosi i valori si modificano davvero

{
    vector<Nodi_class*> vett_aux;
    vett_aux = (*nodo).restituisci_vettore_p();

    //Usato per controllare quale nodo subirà ricorsione
    /*cout << "Nodo usato dalla ricorsione: " << endl;
    cout << (*nodo).get_name() << endl;*/

    unsigned int j;
    for(j = 0; j < vett_aux.size(); j++)
    {

        if((*vett_aux[j]).get_val_bit() == 0) //non calcolo due volte eventuali net o gate comuni
        {
            //Se il nodo non è correttamente aggiornato (val_bit = 0) allora eseguo la ricorsione
            //cout << "Nome nodo che subira' ricorsione: " << (*vett_aux[j]).get_name() << endl;
            recur_calc(&(*vett_aux[j]));
        }

    }

    (*nodo).funzione_uscita();
    (*nodo).lettura_corretta_nodo();
    return;

}



void ReadFile::stampa_gate() //controllo
{
    vector<Nodi_class*> vett_aux;
    cout << "Valori degli input di tutte le porte" << endl;
    cout << "BOOL\tNOME\tVALBIT" << endl;
    for (unsigned int j = 0; j < U.size(); j++)
    {
        vett_aux = U[j].restituisci_vettore_p();
        for (unsigned int i = 0; i<vett_aux.size(); i++)
        {
            cout << (*vett_aux[i]).get_bool() << "\t" << (*vett_aux[i]).get_name() << "\t" << (*vett_aux[i]).get_val_bit() << endl;
        }
        cout << "DIMENSIONE PORTA " << j << " e': " << U[j].dimensione_punt_in() << " tipo: "<< U[j].get_tipo_porta()<< " valore: " << U[j].get_bool() << endl;
    }
}

void ReadFile::pulizia_val_bit() //Per il ciclo successivo
{
    unsigned int i;
    for (i=0;i<outputs_list.size();i++)
    {
        outputs_list[i].svuota_lettura();
    }

    for (i=0;i<input_list.size();i++)
    {
        input_list[i].svuota_lettura();
    }


    for (i=0;i<net_list.size();i++)
    {
        net_list[i].svuota_lettura();
    }


    for (i=0;i<U.size();i++)
    {
        U[i].svuota_lettura();
    }
}

void ReadFile::read_input(string file_bool)
{
    //Apro file
    ifstream input_file;
    int val;
    input_file.open(file_bool.c_str(), ios::in);

    if (!input_file)
    {
        cerr << "File could not be opened" << endl;
        exit( EXIT_FAILURE );
    }

    //Elabora_circuito elaborazione;
    string aux;

    while(getline(input_file,aux))
    {
        unsigned int j = 0;
        istringstream iss(aux);
        while(iss >> val)
        {
            /*if (j >= input_list.size())
            {
                cerr << "Errore, troppi input nella riga!" << endl;
                exit(EXIT_FAILURE);
            }*/
            input_list[j].set_bool(val);
            input_list[j].lettura_corretta_nodo();


            if (input_list[j].get_val_bit() == 0)
            {
                cerr << "Input non inserito correttamente!" << endl;
                exit(EXIT_FAILURE);
            }
            j++;
        }

        if (j != input_list.size())
        {
            cerr << "Errore, troppi input nella riga!" << endl;
            exit(EXIT_FAILURE);
        }



        //Funzione per controllare che ad ogni ciclo gli input siano aggiornati correttamente
        /*unsigned int i = 0;
        cout << "Valore del vettore di input (variabile privata, non delle porte)" << endl;
        for (i = 0; i<input_list.size();i++)
        {
            cout << input_list[i].get_bool() << " ";
        }
        cout << endl;*/

    elaborazione();

    print();
    //stampa_gate(); //Funzione di controllo
    //stampa_video(); //funzione di controllo per vedere gli output su schermo
    pulizia_val_bit(); //per il prossimo ciclo
    }

    print_complessita();
    input_file.close();
}



unsigned int ReadFile::controllo_gates() //Utile per controllare il numero di porte e dimensionare appositamente il vettore GATE
{
	string line;
	unsigned int n_gates = 0;
	ifstream myfile (_filename.c_str(), ios::in);
    if (myfile.is_open())
    {
        while (getline (myfile,line))
    		{
     		if (line[0] == ' ')
			{
				n_gates++;
			}
		}

        myfile.close();
	}

    else
    {
		cerr << "Unable to open the file" << endl;
        exit (EXIT_FAILURE);
    }
	return n_gates;

}



void ReadFile::readFile()
{

    unsigned int dimensione_gates = controllo_gates();
    U.resize(dimensione_gates);

    //Apro file
    ifstream in_file;
    in_file.open(_filename.c_str(), ios::in);

    //Contatore oggetti porte
    int j = 0;

    string aux;
    string argoument;
    string useless;


    vector<int> flag(5, 0);

    if (!in_file)
    {
        cerr << "File could not be opened" << endl;
        exit( EXIT_FAILURE );
    }

    int cont = 0;
    int contatore = 0;


    while (getline(in_file,aux))
    {

        istringstream iss(aux);
        iss >> argoument;

        if (isalpha(aux[0]))
        {
            if (argoument == "NAME")
            {
                flag[0]++;
                iss >> informazione._name;

            }

            else if (argoument == "INPUTS")
            {
                flag[1]++;
                iss >> informazione._inputs;
                input_list.resize(informazione._inputs);
                contatore = 1;
            }

            else if (argoument == "OUTPUTS")
            {
                flag[2]++;
                iss >> informazione._outputs;
                outputs_list.resize(informazione._outputs);
                contatore++;
            }

            else if (argoument == "NETS")
            {
                flag[3]++;
                iss >> informazione._nets;
                net_list.resize(informazione._nets);
                contatore++;
            }

            else if (argoument == "GATES")
            {
                flag[4]++;
            }
        }

        if (contatore == 3) //Flag usati per vedere se uso tutti gli I,N e O -> alla fine di tutto controllo di essere arrivati alla fine del flag e aver usato tutto
        {
            flag_in.resize(informazione._inputs);


            flag_output.resize(informazione._outputs);


            flag_net.resize(informazione._nets);

            contatore++;
        }


        if (aux[0] == ' ')
        {
            //Per la posizione degli inputs nei vettori
            unsigned int pos;
            string temp_1;
            temp_1.clear();
            string temp_2;
            temp_2.clear();

            /*if (!isalpha(aux[1]))
            {
                cerr << " Nella riga (gates) " << j << " il secondo carattere non e' una lettera" << endl;
                exit(EXIT_FAILURE);
            }*/

            //Ciclo per leggere la linea salvata parola per parola

            do
            {
                cont++;
                if (cont == 1)
                {
                    if (argoument == "NOT")
                    {
                        _num_in = 1;
                        (U.at(j)).set_tipo_porta(argoument);
                        argoument.clear();
                    }

                    else

                    {
                        int aux_flag = 1;

                        for (unsigned int i = 0; i < argoument.size(); i++)
                        {
                            //Controllo che i valori siano lettere e inserisco nella variabile temporanea 1 il nome della porta
                            if (isalpha(argoument[i]))
                            {
                                temp_1 += argoument[i];
                            }
                            //Controllo che i caratteri siano numeri
                            else if (isdigit(argoument[i]))
                            {
                                temp_2 += argoument[i];
                                aux_flag = 1;
                            }
                            //Se non è né una lettera né un numero errore nella descrizione della porta
                            else
                            {
                                cerr << "Errore nel nome della porta " << j << endl;
                                exit (EXIT_FAILURE);
                            }
                        }

                        if (aux_flag != 1)
                            {

                                cerr << "Riga (GATES) " << j << " numero nodo non assegnato correttamente." << endl;
                                exit(EXIT_FAILURE);

                            }

                        _num_in = atoi(temp_2.c_str());
                        temp_2.clear();


                        (U.at(j)).set_tipo_porta(temp_1);
                        temp_1.clear();

                    }
                }


                if (cont == 2)
                {
                    U[j].set_name(argoument);
                    //Controllo nome della porta
                    if (argoument[0] != 'U')
                    {
                        cerr << "Il nome della porta numero "  << j << " non e' impostato correttamente." << endl;
                        exit (EXIT_FAILURE);
                    }
                }
                //Inizio lettura degli input della porta
                if (cont > 2 && cont <= _num_in + 2)
                {

                        //Cancello virgola
                        argoument.pop_back();
                        //Se è inputs allora salvo nella lista degli inputs
                        if (argoument[0] == 'I')
                        {
                            //Ciclo for per leggere la posizione ad esempio I86 il numero 86
                            //Parto dalla prima posizione perche' ho già letto
                            int aux_flag = 0;
                            for (unsigned int i = 1; i < argoument.size(); i++)
                            {
                                if (isdigit(argoument[i]))
                                {
                                    temp_2 += argoument[i];
                                    aux_flag = 1;
                                }
                                //Else errore
                            }
                            if (aux_flag != 1)
                            {

                                cerr << "Riga (GATES) " << j << " numero nodo non assegnato correttamente." << endl;
                                exit(EXIT_FAILURE);

                            }
                            pos = atoi(temp_2.c_str());
                            temp_2.clear();

                            //se la posizione non esiste errore
                            if (pos < 0 || pos >= input_list.size())
                            {
                                cerr << "Input non esiste. Riga (GATES) " << j << endl;
                                exit(EXIT_FAILURE);
                            }



                            //aggiungo al contatore
                            flag_in[pos] ++; //controllo

                            //Aggiungo alla porta il nodo dell'input
                            U[j].aggiungi_punt_in(&input_list[pos]);
                        }

                        //Se nella porta entra net
                        else if (argoument[0] == 'N')
                        {
                            //Ciclo for per leggere la posizione ad esempio I86 il numero 86
                            //Parto dalla prima posizione perche' ho già letto

                            int aux_flag = 0;
                            for (unsigned int i = 1; (unsigned)i < argoument.length(); i++)
                            {
                                if (isdigit(argoument[i]))
                                {
                                    temp_2 += argoument[i];
                                    aux_flag = 1;

                                }
                            }

                            if (aux_flag != 1)
                            {

                                cerr << "Riga (GATES) " << j << " numero nodo non assegnato correttamente." << endl;
                                exit(EXIT_FAILURE);

                            }
                            //Errore stoi
                            pos = atoi(temp_2.c_str());
                            temp_2.clear();
                            //se la posizione non esiste errore
                            if (pos < 0 || pos >= net_list.size())
                            {
                                cerr << "net non esiste. Problema riga (GATES) " << j << endl;
                                exit(EXIT_FAILURE);
                            }
                            //aggiungo al contatore
                            flag_net[pos]++;
                            //Aggiungo alla porta il nodo net
                            U[j].aggiungi_punt_in(&net_list[pos]);
                        }

                        else
                        {
                            cerr << "Nella porta (gates) " << j << " errore nella descrizione" << endl;
                            exit(EXIT_FAILURE);
                        }

                }//Chiusura if

                //Leggo output

                if (cont == _num_in + 3)
                {
                    //Controllo se la prima lettera è un output

                    if (argoument[0] == 'O')
                    {
                        int aux_flag = 0;
                        for (unsigned int i = 1; (unsigned)i < argoument.length(); i++)
                        {
                            if (isdigit(argoument[i]))
                            {
                                temp_2 += argoument[i];
                                aux_flag = 1;
                            //else
                                //errore
                            }
                        }
                        if (aux_flag != 1)
                            {

                                cerr << "Riga (GATES) " << j << " numero nodo non assegnato correttamente." << endl;
                                exit(EXIT_FAILURE);

                            }
                        pos = atoi(temp_2.c_str());
                        temp_2.clear();
                        //se la posizione non esiste errore
                        if (pos < 0 || pos >= outputs_list.size())
                        {
                            cerr << "output non esiste. Posizione(GATES) " << pos << " non valida" << endl;
                            cerr << "Vettore output ha valore massimo " << outputs_list.size() -1 << endl;
                            exit(EXIT_FAILURE);
                        }
                        //aggiungo al contatore
                        flag_output[pos]++; //controllo se usato
                        //Aggiungo a
                        outputs_list[pos].aggiungi_punt_in(&U[j]);
                    }//Fine se è un output, ora if con net

                    else if (argoument[0] == 'N')
                    {
                        int aux_flag = 0;
                        for (unsigned int i = 1; i < argoument.length(); i++)
                        {
                            if (isdigit(argoument[i]))
                            {
                                temp_2 += argoument[i];
                                aux_flag = 1;
                            //else
                                //errore
                            }
                        }
                        if (aux_flag != 1)
                            {

                                cerr << "Riga (GATES) " << j << " numero nodo non assegnato correttamente." << endl;
                                exit(EXIT_FAILURE);

                            }
                        pos = atoi(temp_2.c_str());
                        temp_2.clear();
                        //se la posizione non esiste errore
                        if (pos < 0 || pos >= net_list.size())
                        {
                            cerr << "net non esiste. Posizione (GATES) " << pos << " non valida" << endl;
                            cerr << "Vettore net ha valore massimo " << net_list.size() -1 << endl;
                            exit(EXIT_FAILURE);
                        }//Fine if controllo se la posizione esiste
                        //aggiungo al contatore
                        flag_net[pos]++;
                        //Aggiungo a
                        net_list[pos].aggiungi_punt_in(&U[j]);
                    }//Fine se è una net

                    else
                    {
                        cerr << "Errore nome output riga (GATES) " << j << endl;
                        exit(EXIT_FAILURE);
                    }
                    //Modifico contatori
                    j++;
                    cont = 0;
                }//Fine lettura ultimo valore output

                if (cont > _num_in +3)
                {
                    cerr << "Errore numero di input o output" << endl;
                    exit (EXIT_FAILURE);
                }

            } while(iss >> argoument);
        }
    }


    //Ciclo per controllare i flag delle prima righe
    for ( int k = 0; k < 5; k++)
    {
        if (flag[k] != 1)
        {
            cerr << "Errore nella descrizione sintattica del file, prime righe." << endl;
            exit (EXIT_FAILURE);
        }
    }

    for (unsigned int i = 0; i< input_list.size(); i++) //utile per il valore logico delle net
    {
        stringstream convert;
        convert << "I" << i;
        input_list[i].set_name(convert.str());
    }

    for (unsigned int i = 0; i< net_list.size(); i++) //utile per il valore logico delle net
    {
        stringstream convert;
        convert << "N" << i;
        net_list[i].set_name(convert.str());
    }

    for (unsigned int i = 0; i< outputs_list.size(); i++) //utile per il valore logico degli output
    {
        stringstream convert;
        convert << "O" << i;
        outputs_list[i].set_name(convert.str());
    }

    in_file.close();


    /*Ciclo per controllare di aver usati TUTTI gli inputs, nets e outputs siano usati nel circuito, in modo corretto
    for (unsigned int i = 0; i < flag_in.size(); i++)
    {
        cout << "input usati" << flag_in[i] << endl;
    }

    for (unsigned int i = 0; i < flag_output.size(); i++)
    {
        cout << "output usati" << flag_output[i] << endl;
    }

    for (unsigned int i = 0; i < flag_net.size(); i++)
    {
        cout << "net usate" << flag_net[i] << endl;
    }*/

    //controllo sulla dimensione dei flag usati per i vari vettori
    /*cout << flag_in.size() << endl;
    cout << flag_output.size() << endl;
    cout << flag_net.size() << endl;*/

    cout << "dim input_list: " << input_list.size() << endl;
    cout << "dim net_list: " << net_list.size() << endl;
    cout << "dim output_list: " <<outputs_list.size() << endl;
    cout << "dim U gate: " <<U.size() << endl;
    cout << "nome circuito: " << informazione._name << endl;
    //controllo


    //Fine ciclo while che legge la riga, se il file non è finito ricomincia e legge una nuova riga
}//Fine funzione readfile



