# BasicFPGA
Basic VHDL designs for FPGA

All designs tested on Altera MAX10.
Code and schematics created in Quartus Prime

## UART
Simple example of UART design.
UART core handles both TX and RX.
UART parameters: 8bits data, 1 stop and start bit, no parity and no flow control.
rx_done and tx_ready are outputs created for signaling higher level modules about current state of RX/TX. rx_done will be set 1 when rx_data_buffer contains valid data that was just received, and tx_ready is set to 1 if no data transmission is ongoing.
Design has connected rx_done to tx_enable, and rx_data_buffer to tx_data_buffer for loopback purpose.

## VGA
Example of VGA driver (800x600) with some random (chosen by dice roll on desk) pattern to display

## FIFO-UART
Simple FIFO based on registers (as is small: 8 bits width, 3 words depth). UART module is used to demonstrate FIFO output. When FIFO will get full will toggle UART to transmit one word.
Signal 'empty' is not used in example as FIFO is only read when 'full' will signal that FIFO reached its capacity.
fifo_tb.vhdl is testbench for FIFO module.
