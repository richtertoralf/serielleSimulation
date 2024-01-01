# serielleSimulation
**Simulation der seriellen Kommunikation mit VirtualBox**   
Quelle: https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/serialports.html  

>Um Software für die Kommunikation über die serielle Schnittstelle (RS-232/RS-485) zu entwickeln, ohne eine Laborumgebung mit echter Hardware zu haben, kann auch VirtualBox genutzt werden.

* Zuerst habe ich auf meinem Windows11 Notebook (Hostsystem) in VirtualBox zwei Server-VM (Ubuntu 22.04) mit den Hostnamen **serverMaster** und **serverSlave** erstellt.
* In VirtualBox konfiguriere ich zuerst für `serverMaster` die Serielle Schnittstelle (Port 1, Serielle schnittstelle aktivieren, Portnummer COM1, Portmodus Host-Pipe, **"Mit pipe/Socket verbinden" NICHT ankreuzen!**, Pfad/Adresse: `\\.\pipe\test01`
* Dann kann diese VM, der `serverMaster` gestartet werden.
* Anschließend wird die zweite VM `serverSlave` genauso konfiguriert. Gleicher Port, gleiche Portnummer, gleicher Portmodus und gleiche Pfad/Adresse. **Hier wird jetzt aber "Mit Pipe/Socket verbinden" angekreuzt!**
* und anschließend kann `serverSlave` gestartet werden.
Wenn zuerst die Slave-VM gestartet wird, hängt sich die VM beim booten auf.
