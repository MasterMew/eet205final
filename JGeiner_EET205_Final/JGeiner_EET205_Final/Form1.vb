Public Class Form1
    Public uC_data As String

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

        If uC_data = "A" Then
            LightStatus.Text = "Lights On"
        ElseIf uC_data = "B" Then
            LightStatus.Text = "Lights Off"
        ElseIf uC_data = "a" Then
            MallTemp.Value = 33
            TempBox.Text = "Heat On"
        ElseIf uC_data = "b" Then
            MallTemp.Value = 38
        ElseIf uC_data = "c" Then
            MallTemp.Value = 43
            TempBox.Text = "Not Running"
        ElseIf uC_data = "d" Then
            MallTemp.Value = 48
            TempBox.Text = "Not Running"
        ElseIf uC_data = "e" Then
            MallTemp.Value = 53
        ElseIf uC_data = "f" Then
            MallTemp.Value = 58
            TempBox.Text = "Heat On"

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

    Private Sub BatButton_Click(sender As Object, e As EventArgs) Handles BatButton.Click
        SerialPort1.Write("B")
    End Sub
End Class
