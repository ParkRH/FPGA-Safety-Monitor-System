#include <stdio.h>
#include <stdlib.h>
#include "xparameters.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xuartlite_l.h"

#define UART_BASEADDR XPAR_AXI_UARTLITE_0_BASEADDR
#define GPIO_BASEADDR XPAR_AXI_GPIO_0_BASEADDR
#define BUFFER_SIZE 16

int main()
{
    char rx_buffer[BUFFER_SIZE];
    int rx_index = 0;
    char received_char;
    
    xil_printf("\r\n=== v2.0: HW Accelerated Safety Monitor ===\r\n");
    while(1)
    {
        if (!XUartLite_IsReceiveEmpty(UART_BASEADDR))
        {
            received_char = XUartLite_RecvByte(UART_BASEADDR);
            if (received_char == '\r' || received_char == '\n')
            {
                rx_buffer[rx_index] = '\0';
                
                if (rx_index > 0 && rx_buffer[0] == 'W' && rx_buffer[1] == ',')
                {

                    int rpm_value = atoi(rx_buffer + 2);
                    Xil_Out32(GPIO_BASEADDR, rpm_value);
                    xil_printf("RPM Updated: %d (Monitor Active)\r\n", rpm_value);
                }              
                rx_index = 0;
            }
            else
            {
                if (rx_index < BUFFER_SIZE - 1)
                {
                    rx_buffer[rx_index] = received_char;
                    rx_index++;
                }
            }
        }
    }
    return 0;
}