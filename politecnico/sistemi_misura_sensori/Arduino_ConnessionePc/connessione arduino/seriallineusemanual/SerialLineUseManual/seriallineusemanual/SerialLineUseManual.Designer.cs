﻿namespace SerialLineUseManual
{
    partial class SerialLineUseManual
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
            this.buttonOpenClose = new System.Windows.Forms.Button();
            this.buttonSend = new System.Windows.Forms.Button();
            this.textBoxMessage = new System.Windows.Forms.TextBox();
            this.textBoxDataReceived = new System.Windows.Forms.TextBox();
            this.buttonCal = new System.Windows.Forms.Button();
            this.textBox_temp = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // buttonOpenClose
            // 
            this.buttonOpenClose.Location = new System.Drawing.Point(27, 34);
            this.buttonOpenClose.Name = "buttonOpenClose";
            this.buttonOpenClose.Size = new System.Drawing.Size(119, 39);
            this.buttonOpenClose.TabIndex = 0;
            this.buttonOpenClose.Text = "Open";
            this.buttonOpenClose.UseVisualStyleBackColor = true;
            this.buttonOpenClose.Click += new System.EventHandler(this.buttonOpenClose_Click);
            // 
            // buttonSend
            // 
            this.buttonSend.Location = new System.Drawing.Point(201, 32);
            this.buttonSend.Name = "buttonSend";
            this.buttonSend.Size = new System.Drawing.Size(113, 40);
            this.buttonSend.TabIndex = 1;
            this.buttonSend.Text = "Doameasure";
            this.buttonSend.UseVisualStyleBackColor = true;
            this.buttonSend.Click += new System.EventHandler(this.buttonSend_Click);
            // 
            // textBoxMessage
            // 
            this.textBoxMessage.Location = new System.Drawing.Point(34, 141);
            this.textBoxMessage.Multiline = true;
            this.textBoxMessage.Name = "textBoxMessage";
            this.textBoxMessage.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textBoxMessage.Size = new System.Drawing.Size(586, 53);
            this.textBoxMessage.TabIndex = 2;
            this.textBoxMessage.TextChanged += new System.EventHandler(this.textBoxMessage_TextChanged);
            // 
            // textBoxDataReceived
            // 
            this.textBoxDataReceived.Location = new System.Drawing.Point(34, 226);
            this.textBoxDataReceived.Multiline = true;
            this.textBoxDataReceived.Name = "textBoxDataReceived";
            this.textBoxDataReceived.ReadOnly = true;
            this.textBoxDataReceived.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textBoxDataReceived.Size = new System.Drawing.Size(586, 292);
            this.textBoxDataReceived.TabIndex = 3;
            this.textBoxDataReceived.TextChanged += new System.EventHandler(this.textBoxDataReceived_TextChanged);
            // 
            // buttonCal
            // 
            this.buttonCal.Location = new System.Drawing.Point(357, 34);
            this.buttonCal.Name = "buttonCal";
            this.buttonCal.Size = new System.Drawing.Size(138, 39);
            this.buttonCal.TabIndex = 4;
            this.buttonCal.Text = "buttonCal";
            this.buttonCal.UseVisualStyleBackColor = true;
            this.buttonCal.Click += new System.EventHandler(this.buttonCal_Click);
            // 
            // textBox_temp
            // 
            this.textBox_temp.Location = new System.Drawing.Point(34, 113);
            this.textBox_temp.Name = "textBox_temp";
            this.textBox_temp.Size = new System.Drawing.Size(586, 22);
            this.textBox_temp.TabIndex = 5;
            this.textBox_temp.TextChanged += new System.EventHandler(this.textBox_temp_TextChanged);
            // 
            // SerialLineUseManual
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(667, 542);
            this.Controls.Add(this.textBox_temp);
            this.Controls.Add(this.buttonCal);
            this.Controls.Add(this.textBoxDataReceived);
            this.Controls.Add(this.textBoxMessage);
            this.Controls.Add(this.buttonSend);
            this.Controls.Add(this.buttonOpenClose);
            this.Name = "SerialLineUseManual";
            this.Text = "FormSerialLineUseManual";
            this.Load += new System.EventHandler(this.SerialLineUseManual_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonOpenClose;
        private System.Windows.Forms.Button buttonSend;
        private System.Windows.Forms.TextBox textBoxMessage;
        private System.Windows.Forms.TextBox textBoxDataReceived;
        private System.Windows.Forms.Button buttonCal;
        private System.Windows.Forms.TextBox textBox_temp;
    }
}

