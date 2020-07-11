/*
 * (C) Politecnico di Torino
 * Questo materiale è distribuito gratuitamente ad esclusivo 
 * uso degli allievi del Politecnico di Torino per la 
 * preparazione all’esame. 
 * Ogni altro uso sia commerciale sia divulgativo 
 * è espressamente vietato senza il consenso scritto dell’autore
*/
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using System.IO.Ports;
using System.Threading;

namespace SerialLineUseManual
{
    public partial class SerialLineUseManual : Form
    {
        SerialPort serialPortInstrument;
        String globalReceivedChars;

        public SerialLineUseManual()
        {
            InitializeComponent();
        }

        private void SerialLineUseManual_Load(object sender, EventArgs e)
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
            serialPortInstrument.PortName = "COM1";
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
            this.buttonSend.Enabled = true;
            this.buttonOpenClose.Text = "Close";

        }
    
         private void serialPortInstrument_DataReceived(object sender, SerialDataReceivedEventArgs e)
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
                    oneLine = globalReceivedChars.Substring(0, lfPosition);
                    //process the message
                    processThisLine(oneLine);
                    //'remove the message from the buffer
                    globalReceivedChars = globalReceivedChars.Substring(lfPosition + 1);
                }
            }


        }
        private void processThisLine(String line)
        {
            //for now do nothing but show the answer
            AppendATextCrossThread(textBoxDataReceived, ">> " + line + "\n");
        }

        delegate void AppendTextCallback(TextBox ctl, string text);

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
                this.Invoke(d, new object[] { ctl, text });
            }
            else
            {
                ctl.Text = ctl.Text + "\r\n" + text;

            }
        }

    }

}
