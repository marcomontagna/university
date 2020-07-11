namespace WindowsFormsApplication1
{
    partial class Form1
    {
        /// <summary>
        /// Variabile di progettazione necessaria.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Liberare le risorse in uso.
        /// </summary>
        /// <param name="disposing">ha valore true se le risorse gestite devono essere eliminate, false in caso contrario.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Codice generato da Progettazione Windows Form

        /// <summary>
        /// Metodo necessario per il supporto della finestra di progettazione. Non modificare
        /// il contenuto del metodo con l'editor di codice.
        /// </summary>
        private void InitializeComponent()
        {
            this.buttonOpenClose = new System.Windows.Forms.Button();
            this.buttonSend = new System.Windows.Forms.Button();
            this.textBoxMessage = new System.Windows.Forms.TextBox();
            this.textBoxDataReceived = new System.Windows.Forms.TextBox();
            this.buttonReadTheFile = new System.Windows.Forms.Button();
            this.textBoxRes = new System.Windows.Forms.TextBox();
            this.textBoxFreqADC = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // buttonOpenClose
            // 
            this.buttonOpenClose.Location = new System.Drawing.Point(23, 23);
            this.buttonOpenClose.Name = "buttonOpenClose";
            this.buttonOpenClose.Size = new System.Drawing.Size(118, 37);
            this.buttonOpenClose.TabIndex = 0;
            this.buttonOpenClose.Text = "OpenSerialLine";
            this.buttonOpenClose.UseVisualStyleBackColor = true;
            this.buttonOpenClose.Click += new System.EventHandler(this.buttonOpenClose_Click);
            // 
            // buttonSend
            // 
            this.buttonSend.Location = new System.Drawing.Point(23, 66);
            this.buttonSend.Name = "buttonSend";
            this.buttonSend.Size = new System.Drawing.Size(535, 58);
            this.buttonSend.TabIndex = 1;
            this.buttonSend.Text = "Start";
            this.buttonSend.UseVisualStyleBackColor = true;
            this.buttonSend.Click += new System.EventHandler(this.buttonSend_Click);
            // 
            // textBoxMessage
            // 
            this.textBoxMessage.Location = new System.Drawing.Point(23, 167);
            this.textBoxMessage.Multiline = true;
            this.textBoxMessage.Name = "textBoxMessage";
            this.textBoxMessage.Size = new System.Drawing.Size(214, 346);
            this.textBoxMessage.TabIndex = 2;
            this.textBoxMessage.TextChanged += new System.EventHandler(this.textBoxMessage_TextChanged);
            // 
            // textBoxDataReceived
            // 
            this.textBoxDataReceived.Location = new System.Drawing.Point(243, 167);
            this.textBoxDataReceived.Multiline = true;
            this.textBoxDataReceived.Name = "textBoxDataReceived";
            this.textBoxDataReceived.Size = new System.Drawing.Size(315, 346);
            this.textBoxDataReceived.TabIndex = 3;
            this.textBoxDataReceived.TextChanged += new System.EventHandler(this.textBoxDataReceived_TextChanged);
            // 
            // buttonReadTheFile
            // 
            this.buttonReadTheFile.Location = new System.Drawing.Point(583, 66);
            this.buttonReadTheFile.Name = "buttonReadTheFile";
            this.buttonReadTheFile.Size = new System.Drawing.Size(318, 58);
            this.buttonReadTheFile.TabIndex = 4;
            this.buttonReadTheFile.Text = "ReadThe File";
            this.buttonReadTheFile.UseVisualStyleBackColor = true;
            this.buttonReadTheFile.Click += new System.EventHandler(this.buttonReadTheFile_Click);
            // 
            // textBoxRes
            // 
            this.textBoxRes.Location = new System.Drawing.Point(583, 136);
            this.textBoxRes.Multiline = true;
            this.textBoxRes.Name = "textBoxRes";
            this.textBoxRes.Size = new System.Drawing.Size(318, 377);
            this.textBoxRes.TabIndex = 5;
            // 
            // textBoxFreqADC
            // 
            this.textBoxFreqADC.Location = new System.Drawing.Point(23, 136);
            this.textBoxFreqADC.Name = "textBoxFreqADC";
            this.textBoxFreqADC.Size = new System.Drawing.Size(100, 22);
            this.textBoxFreqADC.TabIndex = 6;
            this.textBoxFreqADC.TextChanged += new System.EventHandler(this.textBoxFreqADC_TextChanged);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1018, 525);
            this.Controls.Add(this.textBoxFreqADC);
            this.Controls.Add(this.textBoxRes);
            this.Controls.Add(this.buttonReadTheFile);
            this.Controls.Add(this.textBoxDataReceived);
            this.Controls.Add(this.textBoxMessage);
            this.Controls.Add(this.buttonSend);
            this.Controls.Add(this.buttonOpenClose);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonOpenClose;
        private System.Windows.Forms.Button buttonSend;
        private System.Windows.Forms.TextBox textBoxMessage;
        private System.Windows.Forms.TextBox textBoxDataReceived;
        private System.Windows.Forms.Button buttonReadTheFile;
        private System.Windows.Forms.TextBox textBoxRes;
        private System.Windows.Forms.TextBox textBoxFreqADC;
    }
}

