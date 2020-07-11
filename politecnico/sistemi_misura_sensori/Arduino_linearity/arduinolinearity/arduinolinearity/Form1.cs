//NIDAQ NX drivers installed
//go to Project/Add Reference //attenzione al livello di NET
//DEV3 -- è corretto l'ID della board? (ovviamente devo avere una board e connessa) //capitolo 10.3 IDENTIFYING AND LISTING BOARDS
//go to Measurement & Automation Explorer and search the installed devices and their ID

//WE NEED 2 TASK TO READ AND WRITE? .. non necessariamente


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
using NationalInstruments.NI4882;
using Microsoft.VisualBasic;

namespace arduinolinearity
{
    public partial class Form1 : Form
    {

        SerialPort serialPortInstrument;                                    //oggetto PortaSeriale
        String globalReceivedChars;
        const String dev = "Dev3";                                          //per la NATIONAL INSTRUMENT DAQ
        Task globalTask = null;                                             //        "          "
        //private AnalogMultiChannelReader globalReader = null;
        //bool stopIT = false, running = false;

        private int BOARD = 0;                                              //per la NI IEEE 488 //occorre trovare il numero corretto della board in aula (vedi pdf)
        private byte ADDRESS = 9;
        private byte SEC_ADDRESS = 0;

        int adc = 0;

        private NationalInstruments.NI4882.Device gpibDmm;


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
                this.buttonStart.Enabled = true;                             //abilito pulsnate START
                this.OpenSerialLine.Text = "Close";
            }
            else
            {                                                          //disabilito pulsante START, attivo Open
                serialPortInstrument.Close();
                this.buttonStart.Enabled = false;
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

        private void buttonStart_Click(object sender, EventArgs e)
        {
            String response = "INITIALIZED";                                            //PER IL MULTIMETRO -- DOVE MEMORIZZIAMO LA SUA RISPOSTA
            Task writeTask = null;
            AnalogSingleChannelWriter writer = null;
            //create a write task
            try
            {
                writeTask = new Task();
                writeTask.AOChannels.CreateVoltageChannel(dev + "/ao0", "", 0, 5,
                    AOVoltageUnits.Volts);

                writeTask.Control(TaskAction.Verify);
                writer = new AnalogSingleChannelWriter(writeTask.Stream);
                double dataOut = 3;
                //AppendATextCrossThread(textBoxDAQ, ">> SDAQ INVIA" + dataOut + "\n");
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


                //qua potrei leggere il multimetro
                try
                {
                    gpibDmm = new  NationalInstruments.NI4882.Device(BOARD, ADDRESS, SEC_ADDRESS);  //OGGETTO ATTRAVERSO IL QUALE SCRIVERE IL COMANDO AD ARDUINO
                    gpibDmm.DefaultBufferSize = 32000;                                              //SIZE OF THE INTERNAL BUFFER FOR READING THE DATA
                    gpibDmm.IOTimeout = TimeoutValue.T10s;                                          //FEED THE DOG

                

                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                    //return;
                }
                 //'write the request
                try
                {
                    gpibDmm.Write("MEAS:VOLT:DC? 10,0.00001\n");                                    //IO METTEREI UNA PRECISIONE DI 6 E MEZZO // COMANDO COPIATO DALLE SLIDE
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                    //return;
                }
                //'get the answer
                try
                {
                    response = gpibDmm.ReadString();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                    //return;
                }
                    AppendATextCrossThread(textBoxResponse, ">> SDAQ INVIA" + response + "\n");
                    //textBoxResponse.Text = response;                                                //CROSS THREADING
                writeTask.Dispose();                                                                  //dispose the task for less memory usage
            }
        }

        private void FormIee488_Load(object sender, EventArgs e)                        //MULTIMETRO - PRESENTE NELL'ESEMPIO - NON SO A COSA SERVA
        {

        }

        private void textBoxResponse_TextChanged(object sender, EventArgs e)
        {
            //dove stampo i valori misuarti dal multimetro
        }

        private void textBoxMessage_TextChanged(object sender, EventArgs e)
        {
            //dove stampo informazioni sull'uso di ADC arduino
        }

        private void textBoxDataReceived_TextChanged(object sender, EventArgs e)
        {
            //dove stampo i dati dell'ADC
        }

        private void textBoxDAQ_TextChanged(object sender, EventArgs e)
        {
            //stampo informazioni sul DAQ
        }


    }
}
