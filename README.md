# BasicFPGA
Basic VHDL designs for FPGA

All designs tested on Altera MAX10.
Code and schmatics created in Quartus Prime

## UART
Simple example of UART design.
UART core handles both TX and RX.
UART parameters: 8bits data, 1 stop and start bit, no parity and no flow control.
rx_done and tx_ready are outputs created for signaling higher level modules about current state of RX/TX. rx_done will be set 1 when rx_data_buffer contains valid data that was just recived, and tx_ready is set to 1 if no data transmision is ongoing.
Desing has connected rx_done to tx_enable, and rx_data_buffer to tx_data_buffer for loopback purpose.
