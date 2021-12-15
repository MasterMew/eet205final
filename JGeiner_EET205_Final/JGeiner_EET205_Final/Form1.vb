Public Class Form1
    Public uC_data As String
    Public thermal As Integer
    Public light As String

    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        If (SerialPort1.IsOpen) Then
            SerialPort1.Close()
        End If
        Control.CheckForIllegalCrossThreadCalls = False

        Try
            SerialPort1.BaudRate = 9600
            SerialPort1.Parity = IO.Ports.Parity.None
            SerialPort1.DataBits = 8
            SerialPort1.StopBits = 1
            SerialPort1.Handshake = IO.Ports.Handshake.None
            SerialPort1.WriteTimeout = 500
            SerialPort1.ReadTimeout = 500
            AddHandler SerialPort1.DataReceived, AddressOf DataReceivedHandler
            SerialPort1.Open()
        Catch ex As Exception
            MessageBox.Show("Serial port failed to open: " & ErrorToString(), "Serial Port Error")
        End Try
    End Sub

    Private Sub DataReceivedHandler(Sender As Object, e As System.IO.Ports.SerialDataReceivedEventArgs)
        Try

            Do
                uC_data = ChrW(SerialPort1.ReadChar())
            Loop Until SerialPort1.BytesToRead = 0

        Catch ex As Exception
            MessageBox.Show("Coms fail! Received: " & uC_data)
        End Try

        If IsNumeric(uC_data) = True Then
            thermal = uC_data
        End If
        If IsNumeric(uC_data) = False Then
            light = uC_data
            If light = "A" Then
                LightStatus.Text = "Lights On"
            ElseIf light = "B" Then
                LightStatus.Text = "Lights Off"
            End If
        End If

    End Sub

    Private Sub OpenButton_Click(sender As Object, e As EventArgs) Handles OpenButton.Click
        SerialPort1.Write("O")
    End Sub

    Private Sub CloseButton_Click(sender As Object, e As EventArgs) Handles CloseButton.Click
        SerialPort1.Write("C")
    End Sub

    Private Sub EButton_Click(sender As Object, e As EventArgs) Handles EButton.Click
        SerialPort1.Write("E")
    End Sub
End Class
