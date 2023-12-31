# serielleSimulation
Simulation der seriellen Kommunikation mit VirtualBox  
Quelle: https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/serialports.html  

>Um Software für die Kommunikation über die serielle Schnittstelle (RS-232/RS-485) zu entwickeln, ohne eine Laborumgebung mit echter Hardware zu haben, kann auch VirtualBox genutzt werden.

* Zuerst habe ich auf meinem Windows11 Notebook (Hostsystem) in VirtualBox zwei Server-VM (Ubuntu 22.04) mit den Hostnamen ServerMaster und ServerSlave erstellt.
* In VirtualBox konfiguriere ich zuerst für die Master-VM die Serielle Schnittstelle (Port 1, serielle schnittstelle aktivieren, Portnummer COM1, Portmodus Host-Pipe, **"Mit pipe/Socket verbinden NICHT ankreuzen!**, Pfad/Adresse: \\.\pipe\test01
* Dann kann ich diese VM, die Master-VM gestartet werden.
* Anschließend wird die zweite VM (Slave) genauso konfiguriert. Gleicher Port, gleiche Portnummer, gleicher Portmodus und gleiche Pfad/Adresse. **Hier wird jetzt aber "Pipe/Socket verbinden angekreuzt!**
* und die Slave-VM gestartet.
