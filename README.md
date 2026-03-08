#  FPGA 기반 PC 제어형 안전 모니터링 시스템
> **MicroBlaze SoC 기반 통신 제어 및 Custom IP를 활용한 하드웨어 가속(HW Offloading) 프로젝트**

![Verilog](https://img.shields.io/badge/Verilog-000000?style=for-the-badge&logo=Verilog&logoColor=white)
![C](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)
![C#](https://img.shields.io/badge/C%23-239120?style=for-the-badge&logo=c-sharp&logoColor=white)
![Xilinx](https://img.shields.io/badge/Xilinx_Vivado-E31837?style=for-the-badge&logo=Xilinx&logoColor=white)

##  1. 프로젝트 개요
PC(GUI)에서 입력된 명령을 UART 통신으로 수신하여, FPGA가 실시간으로 데이터를 분석하고 안전 등급(SAFE / WARN / ERR)을 판정해 디스플레이하는 산업용 제어 시스템입니다.
초기 소프트웨어(CPU) 중심의 설계가 갖는 병목 현상을 분석하고, **판단 로직을 하드웨어(Verilog Custom IP)로 분리하는 HW 가속화(Offloading)** 를 통해 실시간성을 극대화한 것이 핵심입니다.

* **Target Board:** Digilent Basys 3 (Xilinx Artix-7)
* **Development Tools:** Vivado 2024.2, Vitis 2024.2, Visual Studio (WinForms)

---

## 2. 시스템 아키텍처 (SoC Block Design)
MicroBlaze 소프트 코어 프로세서를 중심으로, AXI4-Lite 버스를 통해 통신 및 제어 모듈을 통합한 SoC(System on Chip) 구조입니다.

![System Architecture](./src_hw/design_1.PNG)
* **MicroBlaze:** 시스템 메인 컨트롤러 및 데이터 라우팅
* **AXI UARTLite:** PC(C# GUI)와의 RS-232 직렬 통신 (Baud: 9600)
* **Custom IP (Safety Monitor):** 안전 등급 판정 및 7-Segment 다이나믹 구동(Multiplexing)을 담당하는 Verilog 로직

---

##  3. 핵심 성과: HW/SW Co-design 및 최적화
단순 반복 연산을 처리하던 CPU의 부하를 제거하기 위해, 판단 로직을 하드웨어로 이식(Offloading)하여 성능을 개선했습니다.

###  [v1.0] Software-Centric 설계 (Baseline)
* **구조:** PC 데이터 수신 ➔ **MicroBlaze(CPU)가 직접 연산 및 판정** ➔ AXI GPIO로 출력
* **한계:** 긴급 상황(위험 감지) 시, CPU의 상태나 인터럽트 부하에 따라 경고 표시가 지연될 가능성 존재 (실시간성 저하)

###  [v2.0] Hardware Acceleration (최적화 적용)
* **구조:** PC 데이터 수신 ➔ MicroBlaze는 데이터 전달만 수행 ➔ **Custom IP(HW)에서 즉시 판정 및 출력**
* **개선 결과:**
  * CPU 내의 `if-else` 판정 로직을 완전히 제거하여 **CPU 의존성 탈피**
  * Custom IP 내부에서 단 **1 Clock Cycle** 만에 상태(SAFE/WARN/ERR) 판정 완료
  * 전체 하드웨어 LUT 리소스를 단 0.2%(+4개)만 추가하여 압도적인 **실시간성(Real-time) 확보**

---

## 📂 4. 리포지토리 구조
이 리포지토리는 기능별로 분리된 3개의 핵심 소스코드 폴더로 구성되어 있습니다.

```text
📦 FPGA-Safety-Monitor-System
 ┣ 📂 src_hw/       # 하드웨어 로직 및 설정 파일
 ┃ ┣ 📜 seven_seg.v           # [핵심] 1 Clock 판정 및 7-Segment 제어 Custom IP
 ┃ ┣ 📜 design_1_wrapper.v    # Top Module
 ┃ ┣ 📜 basys3.xdc            # 보드 핀맵 제약 조건(Constraints)
 ┃ ┗ 📜 block_design.png      # SoC 아키텍처 다이어그램
 ┣ 📂 src_fw/       # MicroBlaze 펌웨어 소스
 ┃ ┗ 📜 main.c                # UART 통신 수신 및 HW 모듈로 데이터 전송 (예외처리 적용)
 ┗ 📂 src_gui/      # PC 제어 응용 프로그램
   ┗ 📜 Form1.cs              # C# WinForms 기반 시리얼 통신 프로토콜 (UI 스레드 안정성 확보)
