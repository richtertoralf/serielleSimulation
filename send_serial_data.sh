#!/bin/bash

# Serial interface
SERIAL_PORT="/dev/ttyS0"

# Set up serial port
stty -F "$SERIAL_PORT" 19200 -parodd cs8 -cstopb

# Send data to serial port
while IFS= read -r line; do
  echo -e "$line\r" > "$SERIAL_PORT"
  sleep 1
done < serialData.csv
