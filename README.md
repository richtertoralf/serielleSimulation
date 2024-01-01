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
## Daten übertragen
Auf der VM `serverSlave`starte ich ein extra Terminal mit:  
`sudo screen /dev/ttyS0`  
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
