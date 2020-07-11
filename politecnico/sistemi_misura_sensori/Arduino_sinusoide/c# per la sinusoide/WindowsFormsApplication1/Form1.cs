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
using System.Globalization;




namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {

        
        
        
        SerialPort serialPortInstrument;                                    //oggetto PortaSeriale
        String globalReceivedChars;                                         //stringa per immagazzinare i dati ricevuti da Arduino
        int adc = 1500;                                                     //valore ricevuto dall'adc, inizializzato a un valore > di 1023: in caso di errori, in fase di debug è comodo
        int N = 50;                          //WARNING: NON HO IDEA DI QUANTI CAMPIONI PRENDA FRANCESCA: DA CORREGGERE SE NON SONO 50 I CAMPIONI RACCOLTI DA ARDUINO
        
        public Form1()
        {
            InitializeComponent();
        }

        private void SerialLineUseManual_Load(object sender, EventArgs e)   //funzione_Load PortaSeriale
        {

        }


        private void buttonOpenClose_Click(object sender, EventArgs e)
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
                this.buttonSend.Enabled = true;                             //disabilito i pulsanti Send
                this.buttonOpenClose.Text = "Close";
            }
            else
            {                                                          //disabilito i pulsanti Send
                serialPortInstrument.Close();
                this.buttonSend.Enabled = false;
                this.buttonOpenClose.Text = "Open";
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
                //ashPosition = globalReceivedChars.IndexOf("#");
                if (lfPosition > 0)
                {

                    //extract the message

                    oneLine = globalReceivedChars.Substring(1, lfPosition);
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

            AppendATextCrossThread(textBoxDataReceived, ">> " + line + "\n");

            adc = (int)(Convert.ToInt16(line));

            //beware: when working with the IDE the startup path is
            //the either sub dir bin/debug or bin/release
            String myPath = System.Windows.Forms.Application.StartupPath;
            //open the file for write
            FileStream file = new FileStream(myPath + "\\test.bin",
                FileMode.OpenOrCreate,
                FileAccess.ReadWrite);
            BinaryWriter swB = new BinaryWriter(file); //create writer

            swB.Seek(0, SeekOrigin.End);
            swB.Write(adc);

            swB.Close(); //close writer
            file.Close(); //close file


        }


        delegate void AppendTextCallback(TextBox ctl, string text);                 //delegato di cui si serve dalla funzione AppendATextCrossThread, in quest'utiltima diventa una copia stessa della funzione in cui è usato il delegato
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

        private void buttonSend_Click(object sender, EventArgs e)
        {
            textBoxMessage.AppendText(" Sending adc");
            serialPortInstrument.Write(textBoxFreqADC.Text);                         //invia ad Arduino un numero (prescaler) per l'ADC
            Application.DoEvents();
        }

        private void textBoxDataReceived_TextChanged(object sender, EventArgs e)
        {

        }

        private void buttonReadTheFile_Click(object sender, EventArgs e)
        {
            //beware: when working with the IDE the startup path is
            //the either sub dir bin/debug or bin/release
            String myPath = System.Windows.Forms.Application.StartupPath;
            //open the file for read
            FileStream file = new FileStream(myPath + "\\test.bin",
                FileMode.OpenOrCreate,
                FileAccess.ReadWrite);
            BinaryReader srB = new BinaryReader(file); //create reader

            //rewind the file
            //file.Seek(0, SeekOrigin.Begin);
            CultureInfo cEn = new CultureInfo("en-US");

            textBoxRes.Text = "Read from test.bin file\r\n";
            //reqad the 5 integer
            for (int x = 0; x < N; x++)                             //SE ARDUINO PRENDE UN NUMERO FISSO O VARIABILE DI CAMPIONI DEVE ESSERE OPPORTUNAMENTE FIXATO
            {                                                       //SE NON SI CONOSCE IL NUMERO DI CAMPIONI, COSA NON PROBABILE, SI POTREBBE LEGGERE IL FILE FINO A QUANDO LA POSIZIONE DI FLUSSO DI TESTO RAGGIUNGA .END
                int r = srB.ReadInt32();
                textBoxRes.AppendText(String.Format(cEn, "{0:000 }\r\n", r));
            }

            srB.Close(); //close reader
            file.Close(); //close file
        }

        private void textBoxMessage_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBoxFreqADC_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
