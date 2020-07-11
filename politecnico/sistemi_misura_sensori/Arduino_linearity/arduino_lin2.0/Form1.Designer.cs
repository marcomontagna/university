namespace arduino_lin
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.OpenSerialLine = new System.Windows.Forms.Button();
            this.textBoxResponse = new System.Windows.Forms.TextBox();
            this.ButtonStart = new System.Windows.Forms.Button();
            this.textBoxMessage = new System.Windows.Forms.TextBox();
            this.textBoxDAQ = new System.Windows.Forms.TextBox();
            this.textBoxDataReceived = new System.Windows.Forms.TextBox();
            this.outputFile1 = new System.Windows.Forms.TextBox();
            this.buttonReadTheFile = new System.Windows.Forms.Button();
            this.outputFile2 = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // OpenSerialLine
            // 
            this.OpenSerialLine.Location = new System.Drawing.Point(52, 36);
            this.OpenSerialLine.Margin = new System.Windows.Forms.Padding(4);
            this.OpenSerialLine.Name = "OpenSerialLine";
            this.OpenSerialLine.Size = new System.Drawing.Size(203, 63);
            this.OpenSerialLine.TabIndex = 0;
            this.OpenSerialLine.Text = "OPENSERIALLINE";
            this.OpenSerialLine.UseVisualStyleBackColor = true;
            this.OpenSerialLine.Click += new System.EventHandler(this.OpenSerialLine_Click);
            // 
            // textBoxResponse
            // 
            this.textBoxResponse.Location = new System.Drawing.Point(548, 36);
            this.textBoxResponse.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxResponse.Multiline = true;
            this.textBoxResponse.Name = "textBoxResponse";
            this.textBoxResponse.Size = new System.Drawing.Size(141, 150);
            this.textBoxResponse.TabIndex = 1;
            this.textBoxResponse.TextChanged += new System.EventHandler(this.textBoxResponse_TextChanged);
            // 
            // ButtonStart
            // 
            this.ButtonStart.Location = new System.Drawing.Point(52, 124);
            this.ButtonStart.Margin = new System.Windows.Forms.Padding(4);
            this.ButtonStart.Name = "ButtonStart";
            this.ButtonStart.Size = new System.Drawing.Size(203, 133);
            this.ButtonStart.TabIndex = 2;
            this.ButtonStart.Text = "START";
            this.ButtonStart.UseVisualStyleBackColor = true;
            this.ButtonStart.Click += new System.EventHandler(this.ButtonStart_Click);
            // 
            // textBoxMessage
            // 
            this.textBoxMessage.Location = new System.Drawing.Point(263, 194);
            this.textBoxMessage.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxMessage.Multiline = true;
            this.textBoxMessage.Name = "textBoxMessage";
            this.textBoxMessage.Size = new System.Drawing.Size(426, 63);
            this.textBoxMessage.TabIndex = 3;
            this.textBoxMessage.TextChanged += new System.EventHandler(this.textBoxMessage_TextChanged);
            // 
            // textBoxDAQ
            // 
            this.textBoxDAQ.Location = new System.Drawing.Point(403, 36);
            this.textBoxDAQ.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxDAQ.Multiline = true;
            this.textBoxDAQ.Name = "textBoxDAQ";
            this.textBoxDAQ.Size = new System.Drawing.Size(137, 150);
            this.textBoxDAQ.TabIndex = 4;
            this.textBoxDAQ.TextChanged += new System.EventHandler(this.textBoxDAQ_TextChanged);
            // 
            // textBoxDataReceived
            // 
            this.textBoxDataReceived.Location = new System.Drawing.Point(263, 36);
            this.textBoxDataReceived.Margin = new System.Windows.Forms.Padding(4);
            this.textBoxDataReceived.Multiline = true;
            this.textBoxDataReceived.Name = "textBoxDataReceived";
            this.textBoxDataReceived.Size = new System.Drawing.Size(132, 150);
            this.textBoxDataReceived.TabIndex = 5;
            this.textBoxDataReceived.TextChanged += new System.EventHandler(this.textBoxDataReceived_TextChanged);
            // 
            // outputFile1
            // 
            this.outputFile1.Location = new System.Drawing.Point(263, 273);
            this.outputFile1.Multiline = true;
            this.outputFile1.Name = "outputFile1";
            this.outputFile1.Size = new System.Drawing.Size(187, 264);
            this.outputFile1.TabIndex = 6;
            this.outputFile1.TextChanged += new System.EventHandler(this.outputFile1_TextChanged);
            // 
            // buttonReadTheFile
            // 
            this.buttonReadTheFile.Location = new System.Drawing.Point(52, 271);
            this.buttonReadTheFile.Name = "buttonReadTheFile";
            this.buttonReadTheFile.Size = new System.Drawing.Size(203, 89);
            this.buttonReadTheFile.TabIndex = 7;
            this.buttonReadTheFile.Text = "ButtonReadFiles";
            this.buttonReadTheFile.UseVisualStyleBackColor = true;
            this.buttonReadTheFile.Click += new System.EventHandler(this.buttonReadTheFile_Click);
            // 
            // outputFile2
            // 
            this.outputFile2.Location = new System.Drawing.Point(473, 273);
            this.outputFile2.Multiline = true;
            this.outputFile2.Name = "outputFile2";
            this.outputFile2.Size = new System.Drawing.Size(216, 265);
            this.outputFile2.TabIndex = 8;
            this.outputFile2.TextChanged += new System.EventHandler(this.outputFile2_TextChanged);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(711, 561);
            this.Controls.Add(this.outputFile2);
            this.Controls.Add(this.buttonReadTheFile);
            this.Controls.Add(this.outputFile1);
            this.Controls.Add(this.textBoxDataReceived);
            this.Controls.Add(this.textBoxDAQ);
            this.Controls.Add(this.textBoxMessage);
            this.Controls.Add(this.ButtonStart);
            this.Controls.Add(this.textBoxResponse);
            this.Controls.Add(this.OpenSerialLine);
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button OpenSerialLine;
        private System.Windows.Forms.TextBox textBoxResponse;
        private System.Windows.Forms.Button ButtonStart;
        private System.Windows.Forms.TextBox textBoxMessage;
        private System.Windows.Forms.TextBox textBoxDAQ;
        private System.Windows.Forms.TextBox textBoxDataReceived;
        private System.Windows.Forms.TextBox outputFile1;
        private System.Windows.Forms.Button buttonReadTheFile;
        private System.Windows.Forms.TextBox outputFile2;
    }
}

