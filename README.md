# serielleSimulation
**Simulation der seriellen Kommunikation mit VirtualBox**   
Quelle: https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/serialports.html  

>Um Software für die Kommunikation über die serielle Schnittstelle (RS-232/RS-485) zu entwickeln, ohne eine Laborumgebung mit echter Hardware zu haben, kann auch VirtualBox genutzt werden.

## VM´s erstellen und per "serieller Pipe" verbinden
* Zuerst habe ich auf meinem Windows11 Notebook (Hostsystem) in VirtualBox zwei Server-VM (Ubuntu 22.04) mit den Hostnamen **serverMaster** und **serverSlave** erstellt.
* In VirtualBox konfiguriere ich zuerst für `serverMaster` die Serielle Schnittstelle (Port 1, Serielle schnittstelle aktivieren, Portnummer COM1, Portmodus Host-Pipe, **"Mit pipe/Socket verbinden" NICHT ankreuzen!**, Pfad/Adresse: `\\.\pipe\test01`
* Dann kann diese VM, der `serverMaster` gestartet werden.
* Anschließend wird die zweite VM `serverSlave` genauso konfiguriert. Gleicher Port, gleiche Portnummer, gleicher Portmodus und gleiche Pfad/Adresse. **Hier wird jetzt aber "Mit Pipe/Socket verbinden" angekreuzt!**
* und anschließend kann `serverSlave` gestartet werden.
Wenn zuerst die Slave-VM gestartet wird, hängt sich die VM beim booten auf.  

![Sreenshot VirtualBox](https://github.com/richtertoralf/serielleSimulation/blob/4e8d87adc7af7e19e2961d2c1feb2366e08df7ba/Screenshot%202024-01-01%20152350.png)

### Testen
```
tori@serverSlave:~$ sudo dmesg | grep ttyS
[    2.525188] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
```
```
tori@serverMaster:~$ sudo dmesg | grep ttyS
[    2.307869] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
```
Wir haben erfolgreich die serielle Schnittstelle `ttyS1` auf beiden VM´s erzeugt. 
## Schnittstelle konfigurieren
bestehende Konfiguration ermitteln:
```
sudo stty -F /dev/ttyS0
```
Um die Einstellungen für die serielle Schnittstelle `/dev/ttyS0` auf **19200 bps, no parity, 8 Datenbits und 1 Stoppbit** zu setzen, kannst du das Befehlsprogramm stty verwenden. Hier ist ein Beispiel:
```
sudo stty -F /dev/ttyS0 19200 -parodd cs8 -cstopb
```
Wichtig! Das muss auf beiden Seiten der Verbindung gemacht werden!  
Diese Einstellung ist nicht persistent und muss nach jedem Neustart der Computer wieder angepasst werden.

## Daten übertragen
### serverSlave
Auf der VM `serverSlave`starte ich ein extra Terminal mit:  
```
sudo screen /dev/ttyS0`
```
Das Terminal kannst du so schließen:
`[ctrl]+[a]  [k]`

### serverMaster
Auf der VM `serverMaster` kann ich jetzt als user root Daten in die Schnittstelle `ttyS0`schreiben, welche dann über die "virtuelle serielle Schnitstelle" zum `serverSlave" übertragen werden.  
```
tori@serverMaster:~$ sudo -i
root@serverMaster:~# echo -e "Hallo \r" > /dev/ttyS0
```
oder zufällige Zahlen jede Sekunde:
```
while true; do echo -e "$((1 + RANDOM % 1000))\r" > /dev/ttyS0; sleep 1; done
```
allen anderen Benutzern das Schreiben in die serielle Schnittstelle auf dem master zulassen:
```
root@serverMaster:~# chmod 666 /dev/ttyS0
```
![Screenshot Terminal](https://github.com/richtertoralf/serielleSimulation/blob/b8e84affc56795c1d477f543f048b255f092b553/Screenshot%202024-01-01%20150633.png)

## Musterdaten
In einer serialData.csv auf dem `serverMaster` kannst du dir jetzt Beipieldaten speichern. Zum Beispiel so etwas:
```
8
102000000
8
8
202003
8
8
8
302000000
40200000000001
8
8
302000000
40200000000011
8
302000000
40200000000111
8
302000000
40200000001111
8
```
Mit diesem Einzeiler kannst du die Daten zeilenweise auslesen und über die serielle Schnittstelle zum `serverSlave` senden:
```
while IFS= read -r line; do echo -e "$line\r" > /dev/ttyS0; sleep 1; done < serialData.csv
``` 
## Bash-Skripte
Mit dem Skript `send_serial_data.sh` kannst du vom `serverMaster` Daten aus der Datei `serialData.csv` senden und mit dem Skript `serial_listener.sh` die Daten auf dem `serverSlave` empfangen.  
```
#!/bin/bash

# send_serial_data.sh

# Serial interface
SERIAL_PORT="/dev/ttyS0"

# Set up serial port
stty -F "$SERIAL_PORT" 19200 -parodd cs8 -cstopb

# Send data to serial port
while IFS= read -r line; do
  echo -e "$line\r" > "$SERIAL_PORT"
  sleep 1
done < serialData.csv
```
```
#!/bin/bash

# serial_listener.sh

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
```
## Python-Skripte
Wenn es späer noch komplexer werden soll, dann lieber gleich zu Python wechseln ;-)  
```
sudo apt install python3-pip
pip install pyserial
```
```
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
```
