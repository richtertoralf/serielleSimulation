#!/usr/bin/env python3

# serial_listener.py

import serial

# Serial interface
SERIAL_PORT = "/dev/ttyS0"

# Set up serial port
ser = serial.Serial(SERIAL_PORT, baudrate=19200, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE, bytesize=serial.EIGHTBITS)

# Infinite loop to listen for serial data
while True:
    # Read one line from the serial port
    serial_data = ser.readline().decode("utf-8").strip()

    # Display received data in the terminal
    print(f"Received data: {serial_data}")
