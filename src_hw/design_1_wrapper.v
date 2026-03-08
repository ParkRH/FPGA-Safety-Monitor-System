//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
//Date        : Thu Nov 27 23:13:38 2025
//Host        : LAPTOP-3ET8MKGC running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (an,
    btn_reset,
    clk_100MHz,
    seg,
    usb_uart_rxd,
    usb_uart_txd);
  output [3:0]an;
  input btn_reset;
  input clk_100MHz;
  output [6:0]seg;
  input usb_uart_rxd;
  output usb_uart_txd;

  wire [3:0]an;
  wire btn_reset;
  wire clk_100MHz;
  wire [6:0]seg;
  wire usb_uart_rxd;
  wire usb_uart_txd;

  design_1 design_1_i
       (.an(an),
        .btn_reset(btn_reset),
        .clk_100MHz(clk_100MHz),
        .seg(seg),
        .usb_uart_rxd(usb_uart_rxd),
        .usb_uart_txd(usb_uart_txd));
endmodule
