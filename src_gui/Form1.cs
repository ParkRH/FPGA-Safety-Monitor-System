using System;
using System.Windows.Forms;
using System.IO.Ports; //

namespace FpgaGuiController // 
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        // 1. 프로그램 켜질 때: COM 포트 목록 찾기
        private void Form1_Load(object sender, EventArgs e)
        {
            string[] ports = SerialPort.GetPortNames(); // PC의 모든 포트 찾기
            cboPort.Items.AddRange(ports);              // 콤보박스에 넣기
            if (ports.Length > 0) cboPort.SelectedIndex = 0; // 첫 번째꺼 선택

            serialPort1.BaudRate = 9600; // FPGA(MicroBlaze)와 속도 맞추기

            // 데이터 수신 이벤트 연결 (FPGA가 말하면 듣기 위해)
            serialPort1.DataReceived += new SerialDataReceivedEventHandler(DataReceivedHandler);
        }

        // 2. [연결] 버튼 눌렀을 때
        private void btnConnect_Click(object sender, EventArgs e)
        {
            try
            {
                if (!serialPort1.IsOpen) // 닫혀있으면 -> 연다
                {
                    serialPort1.PortName = cboPort.Text; // 선택된 포트로
                    serialPort1.Open();
                    btnConnect.Text = "해제"; // 버튼 글자 바꾸기
                    Log("포트가 열렸습니다: " + cboPort.Text);
                }
                else // 열려있으면 -> 닫는다
                {
                    serialPort1.Close();
                    btnConnect.Text = "연결";
                    Log("포트가 닫혔습니다.");
                }
            }
            catch (Exception ex)
            {
                Log("에러: " + ex.Message);
            }
        }

        // 3. [전송] 버튼 눌렀을 때
        private void btnSend_Click(object sender, EventArgs e)
        {
            if (serialPort1.IsOpen)
            {
                
                string msg = "W," + txtValue.Text + "\n";

                serialPort1.Write(msg); 
                Log("보냄: " + msg.Trim());
            }
            else
            {
                Log("먼저 포트를 연결해주세요");
            }
        }

        // 4. FPGA에서 응답이 왔을 때 (수신)
        private void DataReceivedHandler(object sender, SerialDataReceivedEventArgs e)
        {
            try
            {
                string data = serialPort1.ReadExisting(); // 데이터 읽기

                // UI 스레드 충돌 방지 (필수!)
                this.Invoke(new Action(() => {
                    Log("받음: " + data);
                }));
            }
            catch { }
        }

        // (편의 기능) 로그창에 글씨 쓰기
        private void Log(string msg)
        {
            txtLog.AppendText(msg + "\r\n");
            txtLog.ScrollToCaret(); // 맨 아래로 스크롤
        }

        private void txtLog_TextChanged(object sender, EventArgs e)
        {

        }
    }

}
