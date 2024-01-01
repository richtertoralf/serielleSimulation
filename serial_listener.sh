#!/bin/bash

# Serial interface
SERIAL_PORT="/dev/ttyS0"

# Set up serial port
stty -F "$SERIAL_PORT" 19200 -parodd cs8 -cstopb

# Infinite loop to listen for serial data
while true; do
    # Read one line from the serial port
    read -r SERIAL_DATA < "$SERIAL_PORT"

    # Display received data in the terminal
    echo "Received data: $SERIAL_DATA"
done
