//modificare range dell'output MULTIMETRO
//la scheda DAQ si aggiusta automaticamente nel range?
//Vref di Arduino
//QUANTI PUNTI PRENDERE
//WARM UP SCHEDA
//CALIBRAZIONE SCHEDA
//address multimetro
//indirizzo multimetro e dev
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
//using System.Char;
using System.IO.Ports;
using System.Threading;
using System.IO;
using NationalInstruments.DAQmx;
//using NationalInstruments.NI4882;
using Microsoft.VisualBasic;
using System.Threading.Tasks;
using Ivi.Visa.Interop;
using System.Globalization;

namespace arduino_lin
{
    public partial class Form1 : Form
    {
        N = 2048
        SerialPort serialPortInstrument;                                    //oggetto PortaSeriale
        String globalReceivedChars;
        String esito_mult;                                                  //esito_mult
        string[] misure_mult = new string[N+1];                               //misure multimetro
        const String dev = "Dev1";                                          //per la NATIONAL INSTRUMENT DAQ
        //Task globalTask = null;                                             //        "          "
        //private AnalogMultiChannelReader globalReader = null;
        //bool stopIT = false, running = false;

        //private int BOARD = 0;                                              //per la NI IEEE 488 //occorre trovare il numero corretto della board in aula (vedi pdf)
        //private byte ADDRESS = 9;
        //private byte SEC_ADDRESS = 0;

        int adc = 0;
        double Vref = 

        //private NationalInstruments.NI4882.Device gpibDmm;

        String instrumentAddress = "GPIB0::12";

        //this is the variable employed to access the device
        private Ivi.Visa.Interop.FormattedIO488 ioDmm = null;



        public Form1()
        {
            InitializeComponent();
        }

        private void SerialLineUseManual_Load(object sender, EventArgs e)   //ne so quanto voi
        {

        }

        private void OpenSerialLine_Click(object sender, EventArgs e)
        {
            if (serialPortInstrument == null)
            {
                serialPortInstrument = new SerialPort();
                serialPortInstrument.DataReceived +=
                    new System.IO.Ports.SerialDataReceivedEventHandler
                        (this.serialPortInstrument_DataReceived);
            }
            if (!serialPortInstrument.IsOpen)
            {
                serialPortInstrument.PortName = "COM4";
                serialPortInstrument.BaudRate = 9600;
                serialPortInstrument.Parity = Parity.None;
                serialPortInstrument.StopBits = StopBits.One;
                serialPortInstrument.DataBits = 8;

                serialPortInstrument.DtrEnable = true;
                serialPortInstrument.Handshake = Handshake.None;
                //serialPortInstrument.Handshake = Handshake.RequestToSend;
                //serialPortInstrument.Handshake = Handshake.XOnXOff;
                serialPortInstrument.ReceivedBytesThreshold = 1;
                serialPortInstrument.Open();
                this.ButtonStart.Enabled = true;                             //abilito pulsnate START
                this.OpenSerialLine.Text = "Close";
            }
            else
            {                                                          //disabilito pulsante START, attivo Open
                serialPortInstrument.Close();
                this.ButtonStart.Enabled = false;
                this.OpenSerialLine.Text = "Open";
            }
        }

        private void serialPortInstrument_DataReceived(object sender, SerialDataReceivedEventArgs e) //gestione della conessione HardWINNO ---> PC
        {
            //manage received data
            int lfPosition;
            String oneLine;
            if (e.EventType == SerialData.Chars)
            {
                globalReceivedChars = globalReceivedChars +
                    serialPortInstrument.ReadExisting();
                //check is a delimiter i.e. a LF has arrived
                lfPosition = globalReceivedChars.IndexOf("\n");
                if (lfPosition > 0)
                {

                    //extract the message

                    oneLine = globalReceivedChars.Substring(1, lfPosition);               //0
                    //process the message
                    if (globalReceivedChars[0] == '#')
                        processThisLine(oneLine);
                    //'remove the message from the buffer
                    globalReceivedChars = globalReceivedChars.Substring(lfPosition + 1);
                }
            }


        }

        private void processThisLine(String line)                                   //funzione processThisLine chiamata nella funzione serialPortInstrument_DataReceived
        {
            //for now do nothing but show the answer

            AppendATextCrossThread(textBoxDataReceived, ">> " + line + "\n");

            adc = (int)(Convert.ToInt16(line));
        }


        delegate void AppendTextCallback(TextBox ctl, string text);                 //delegato che è usato dalla funzione AppendATextCrossThread, in quest'utiltima diventa una copia stessa della funzione in cui è usato il delegato
        private void AppendATextCrossThread(TextBox ctl, string text)
        {
            // InvokeRequired compares the thread ID of the
            // calling thread to the thread ID of the creating thread.
            // If these threads are different, it returns true.
            if (ctl.InvokeRequired)
            {
                //create the callback object and invoke it
                AppendTextCallback d =
                    new AppendTextCallback(AppendATextCrossThread);
                this.Invoke(d, new object[] { ctl, text });                         //E' qua che chiedo al thread SerialLine di eseguire AppendATextCrossoThread nel thread grafico
            }
            else
            {
                ctl.Text = ctl.Text + "\r\n" + text;

            }
        }



        private void ButtonStart_Click(object sender, EventArgs e)
        {
            NationalInstruments.DAQmx.Task writeTask = null;
            AnalogSingleChannelWriter writer = null;
            //create a write task
            for (int i = 0; i <= N; i++) {                               //i <= 1024X2? OKAY?
            
            
                try
                {
                    writeTask = new NationalInstruments.DAQmx.Task();
                    writeTask.AOChannels.CreateVoltageChannel(dev + "/ao0", "", 0, 5,
                        AOVoltageUnits.Volts);

                    writeTask.Control(TaskAction.Verify);
                    writer = new AnalogSingleChannelWriter(writeTask.Stream);
                    double dataOut = i*Vref/(2^10);
                    AppendATextCrossThread(textBoxDAQ, ">> SDAQ INVIA" + dataOut + "\n");
                    writer.WriteSingleSample(true, dataOut);
                }
                catch (DaqException exception)
                {
                    MessageBox.Show(exception.Message);
                }
                finally
                {
                    //qua potrei inviare il comando ad Arduino
                    textBoxMessage.AppendText(" Sending adc");
                    serialPortInstrument.Write("meas\n");
                    Application.DoEvents();
                    //fine Arduino
                    //MULTIMETER
                    try
                    {
                        ioDmm = new Ivi.Visa.Interop.FormattedIO488();
                        //                    ioDmm = new FormattedIO488Class();
                    }
                    catch (SystemException ex)
                    {
                        MessageBox.Show("FormattedIO488Class object creation failure. "
                            + ex.Source + "  " + ex.Message, "HP488 BasicRead",
                            MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                    int timeOutValue_ms = 2000;
                    try
                    {
                        ResourceManager grm = new ResourceManager();
                        ioDmm.IO = (IMessage)grm.Open(instrumentAddress,
                            AccessMode.NO_LOCK, timeOutValue_ms, "");
                    }
                    catch (SystemException ex)
                    {
                        MessageBox.Show("Open failed on " + instrumentAddress + " " + ex.Source
                            + "  " + ex.Message, "HP488 BasicRead",
                            MessageBoxButtons.OK,
                            MessageBoxIcon.Error);
                        ioDmm.IO = null;
                        //return;
                    }
                    //eventually change the buffer size
                    ioDmm.SetBufferSize(BufferMask.IO_IN_BUF, 30000);
                    try
                    {
                        ioDmm.WriteString("MEAS:VOLT:DC? 10,0.00001\n", true);          //POTREBBE ESSERE LA PRECISIONE?
                    }
                    catch (SystemException ex)
                    {
                        MessageBox.Show("Write failed on " + instrumentAddress + " " + ex.Source
                            + "  " + ex.Message, "HP488 BasicRead",
                            MessageBoxButtons.OK,
                            MessageBoxIcon.Error);

                    }
                    try
                    {
                        String esito_mult = ioDmm.ReadString();                                                  //esito_mult
                        //this.textBoxResponse.Text = ioDmm.ReadString();
                        this.textBoxResponse.Text = ioDmm.ReadString();
                        misure_mult[i] = esito_mult;

                    }
                    catch (SystemException ex)
                    {
                        MessageBox.Show("Read failed on " + instrumentAddress + " " + ex.Source
                            + "  " + ex.Message, "HP488 BasicRead",
                            MessageBoxButtons.OK,
                            MessageBoxIcon.Error);
                        //return;
                    }
                    //MULTIMETER

                    //FILE1 //BINARY
                    //beware: when working with the IDE the startup path is
                    //the either sub dir bin/debug or bin/release
                    String myPath = System.Windows.Forms.Application.StartupPath;
                    //open the file for write
                    FileStream file = new FileStream(myPath + "\\test_ADC.bin",
                    FileMode.OpenOrCreate,
                    FileAccess.ReadWrite);
                    BinaryWriter swB = new BinaryWriter(file); //create writer

                    swB.Seek(0, SeekOrigin.End);
                    swB.Write(adc);

                    swB.Close(); //close writer
                    file.Close(); //close file
                    //FILE 1
                    


                    










                    //AppendATextCrossThread(textBoxResponse, ">> SDAQ INVIA" + response + "\n");
                    writeTask.Dispose();                                                                  //dispose the task for less memory usage
                }

             }
            //FILE 2 //ASCII
                    
            //beware: when working with the IDE the startup path is
            //the either sub dir bin/debug or bin/release
            String myPath = System.Windows.Forms.Application.StartupPath;
            //open the file in write mode
            FileStream file = new FileStream(myPath + "\\test_MULT.txt", FileMode.OpenOrCreate, FileAccess.Write);
            StreamWriter sw = new StreamWriter(file); //create writer
            CultureInfo cEn = new CultureInfo("en-US");

            for (int i=0;i<N+1;i++){
                String s=String.Format("{0:##.###}\r\n", misure_mult[i]);
                sw.Write(s);
            }
            sw.Close(); //close writer
            file.Close(); //close file
            //re-open the file in read mode
            file = new FileStream(myPath + "\\test.txt", FileMode.Open, FileAccess.Read);
            StreamReader sr = new StreamReader(file); //create reader
            String sRead = sr.ReadToEnd(); //read
            outputFile2.Text = "reading from test.txt\r\n";
            
            outputFile2.AppendText(sRead);
            sr.Close(); //close reader
            file.Close(); //close file
            
           

            //FILE 2




        }
       

        



        private void textBoxMessage_TextChanged(object sender, EventArgs e)
        {
            //messaggi su invio dati ADC
        }

        private void textBoxDataReceived_TextChanged(object sender, EventArgs e)
        {
            //DATI RICEVUTI SULLA LINEA SERIALE
        }

        private void textBoxResponse_TextChanged(object sender, EventArgs e)
        {
            //stampo i valori del multimetro
        }

        private void textBoxDAQ_TextChanged(object sender, EventArgs e)
        {
            //STAMPA DATI IN USCIDA DAL DAQ
        }

        private void buttonReadTheFile_Click(object sender, EventArgs e)
        {
            //beware: when working with the IDE the startup path is
            //the either sub dir bin/debug or bin/release
            String myPath = System.Windows.Forms.Application.StartupPath;
            //open the file for read
            FileStream file = new FileStream(myPath + "\\test_ADC.bin",
                FileMode.OpenOrCreate,
                FileAccess.ReadWrite);
            BinaryReader srB = new BinaryReader(file); //create reader

            //rewind the file
            //file.Seek(0, SeekOrigin.Begin);
            CultureInfo cEn = new CultureInfo("en-US");

            outputFile1.Text = "Read from test.bin file\r\n";
            //reqad the 5 integer
            for (int x = 0; x <= N; x++)                             //SE ARDUINO PRENDE UN NUMERO FISSO O VARIABILE DI CAMPIONI DEVE ESSERE OPPORTUNAMENTE FIXATO
            {                                                       //SE NON SI CONOSCE IL NUMERO DI CAMPIONI, COSA NON PROBABILE, SI POTREBBE LEGGERE IL FILE FINO A QUANDO LA POSIZIONE DI FLUSSO DI TESTO RAGGIUNGA .END
                int r = srB.ReadInt32();
                outputFile1.AppendText(String.Format(cEn, "{0:000 }\r\n", r));
            }
            srB.Close(); //close reader
            file.Close(); //close file
        }

        private void outputFile2_TextChanged(object sender, EventArgs e)
        {
        
        }

        private void outputFile1_TextChanged(object sender, EventArgs e)
        {
        
        }
    }
}


// //MULTIMETER
// try
// {
//     ioDmm = new Ivi.Visa.Interop.FormattedIO488();
// //  ioDmm = new FormattedIO488Class();
// }
// catch (SystemException ex)
// {
//     MessageBox.Show("FormattedIO488Class object creation failure. "
//         + ex.Source + "  " + ex.Message, "HP488 BasicRead",
//         MessageBoxButtons.OK, MessageBoxIcon.Error);
// }
//// int timeOutValue_ms = 2000;
// try
// {
//     ResourceManager grm = new ResourceManager();
//     ioDmm.IO = (IMessage)grm.Open(instrumentAddress,
//         AccessMode.NO_LOCK, timeOutValue_ms, "");
// }
// catch (SystemException ex)
// {
//     MessageBox.Show("Open failed on " + instrumentAddress + " " + ex.Source
//         + "  " + ex.Message, "HP488 BasicRead",
//         MessageBoxButtons.OK,
//         MessageBoxIcon.Error);
//     ioDmm.IO = null;
//     //return;
// }
// //eventually change the buffer size
// ioDmm.SetBufferSize(BufferMask.IO_IN_BUF, 30000);
// try
// {
//     ioDmm.WriteString("*IDN?", true);
// }
// catch (SystemException ex)
// {
//     MessageBox.Show("Write failed on " + instrumentAddress + " " + ex.Source
//         + "  " + ex.Message, "HP488 BasicRead",
//         MessageBoxButtons.OK,
//         MessageBoxIcon.Error);

//     //return;
// }
// try
// {
//     this.textBoxResponse.Text = ioDmm.ReadString();
// }
// catch (SystemException ex)
// {
//     MessageBox.Show("Read failed on " + instrumentAddress + " " + ex.Source
//         + "  " + ex.Message, "HP488 BasicRead",
//         MessageBoxButtons.OK,
//         MessageBoxIcon.Error);
//     //return;
// }

// if (ioDmm != null)
// {
//     ioDmm.IO.Close();
// }

// //MULTIMETRO