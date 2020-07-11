namespace arduinolinearity
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
            this.OpenSerialLine = new System.Windows.Forms.Button();
            this.buttonStart = new System.Windows.Forms.Button();
            this.textBoxMessage = new System.Windows.Forms.TextBox();
            this.textBoxResponse = new System.Windows.Forms.TextBox();
            this.textBoxDataReceived = new System.Windows.Forms.TextBox();
            this.textBoxDAQ = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // OpenSerialLine
            // 
            this.OpenSerialLine.Location = new System.Drawing.Point(33, 27);
            this.OpenSerialLine.Name = "OpenSerialLine";
            this.OpenSerialLine.Size = new System.Drawing.Size(154, 97);
            this.OpenSerialLine.TabIndex = 0;
            this.OpenSerialLine.Text = "OpenSerialLine";
            this.OpenSerialLine.UseVisualStyleBackColor = true;
            this.OpenSerialLine.Click += new System.EventHandler(this.OpenSerialLine_Click);
            // 
            // buttonStart
            // 
            this.buttonStart.Location = new System.Drawing.Point(33, 163);
            this.buttonStart.Name = "buttonStart";
            this.buttonStart.Size = new System.Drawing.Size(154, 93);
            this.buttonStart.TabIndex = 1;
            this.buttonStart.Text = "Start";
            this.buttonStart.UseVisualStyleBackColor = true;
            this.buttonStart.Click += new System.EventHandler(this.buttonStart_Click);
            // 
            // textBoxMessage
            // 
            this.textBoxMessage.AccessibleDescription = "h";
            this.textBoxMessage.Location = new System.Drawing.Point(214, 27);
            this.textBoxMessage.Multiline = true;
            this.textBoxMessage.Name = "textBoxMessage";
            this.textBoxMessage.Size = new System.Drawing.Size(138, 176);
            this.textBoxMessage.TabIndex = 2;
            this.textBoxMessage.TextChanged += new System.EventHandler(this.textBoxMessage_TextChanged);
            // 
            // textBoxResponse
            // 
            this.textBoxResponse.Location = new System.Drawing.Point(214, 235);
            this.textBoxResponse.Multiline = true;
            this.textBoxResponse.Name = "textBoxResponse";
            this.textBoxResponse.Size = new System.Drawing.Size(138, 188);
            this.textBoxResponse.TabIndex = 3;
            this.textBoxResponse.TextChanged += new System.EventHandler(this.textBoxResponse_TextChanged);
            // 
            // textBoxDataReceived
            // 
            this.textBoxDataReceived.Location = new System.Drawing.Point(388, 27);
            this.textBoxDataReceived.Multiline = true;
            this.textBoxDataReceived.Name = "textBoxDataReceived";
            this.textBoxDataReceived.Size = new System.Drawing.Size(246, 176);
            this.textBoxDataReceived.TabIndex = 4;
            this.textBoxDataReceived.TextChanged += new System.EventHandler(this.textBoxDataReceived_TextChanged);
            // 
            // textBoxDAQ
            // 
            this.textBoxDAQ.Location = new System.Drawing.Point(388, 233);
            this.textBoxDAQ.Multiline = true;
            this.textBoxDAQ.Name = "textBoxDAQ";
            this.textBoxDAQ.Size = new System.Drawing.Size(246, 190);
            this.textBoxDAQ.TabIndex = 5;
            this.textBoxDAQ.TextChanged += new System.EventHandler(this.textBoxDAQ_TextChanged);
            // 
            // Form1
            // 
            this.AccessibleName = "";
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(952, 479);
            this.Controls.Add(this.textBoxDAQ);
            this.Controls.Add(this.textBoxDataReceived);
            this.Controls.Add(this.textBoxResponse);
            this.Controls.Add(this.textBoxMessage);
            this.Controls.Add(this.buttonStart);
            this.Controls.Add(this.OpenSerialLine);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button OpenSerialLine;
        private System.Windows.Forms.Button buttonStart;
        private System.Windows.Forms.TextBox textBoxMessage;
        private System.Windows.Forms.TextBox textBoxResponse;
        private System.Windows.Forms.TextBox textBoxDataReceived;
        private System.Windows.Forms.TextBox textBoxDAQ;
    }
}

