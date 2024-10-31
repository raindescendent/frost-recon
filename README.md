<a id="spanish-version"></a>
# Frost Scan - Script de Reconocimiento de Red 🛡️

### **Autor**: [Santiago Gimenez]  
### **A.K.A.**: [descendent]  

[README English Version](#english-version)

---

## Descripción general

**Frost Scan** un script en Bash simple pero potente, realiza reconocimiento de red automatizado utilizando las herramientas **Nmap** & **Netcat**. Este script escanea una dirección IPv4 introducida por el usuario, determina dinámicamente la subred, ejecutando una búsqueda de host(s) activos y sus respectivos puertos abiertos, resultando en un reporte final detallado de cada puerto abierto, servicio y versión.

## Características ✨

- **Descubrimiento de Red**: Detecta host(s) activos determinando la subred de la dirección IPv4 brindada mediante **escaneos de ping**.
- **Detección de SO**: Detecta automáticamente si el usuario del script usa Linux o macOS, guiándolos para instalar las herramientas `Nmap` y `Netcat` si es necesario.
- **Escaneo de Puertos**:
- **Escaneo de Puertos estándar**: Escanea los puertos de servicios estándar más reconocidos (SSH, HTTP, FTP, etc.).
- **Escaneo de Rango Completo de Puertos**: Si no se encuentran abiertos ninguno de los puertos estándar, el script realiza un escaneo del rango total de puertos existentes.
- **Resultados**: Guarda los host(s) activos **reportando el S.O., puertos abiertos y el detalle del servicio en ejecución y su versión.**

## ¿Cómo Funciona? 🔍


1. Modificar **permisos** del script y ejecutarlo con **privilegios de root**
<img src="https://imgur.com/X8VtgiY.jpeg" alt="Setting script permissions" width="640px" /> 

2. Ingresar la direccion IPv4 del objetivo

3. Determina la **subred enumerando los host(s) activos** dentro 
<img src="https://imgur.com/uP3hPy5.jpeg" alt="Program example discovers subnet and live host(s)" width="640px" /> 

4. Reporta en terminal las direcciones IPv4 detectadas con sus respectivos servicios activos y puertos TCP abiertos 
<img src="https://imgur.com/17Zjirx.jpeg" alt="Terminal output example showing host IP address, open TCP ports and active services" width="640px" /> 

5. Guarda la informacion detallada de cada host en un archivo de texto
<img src="https://imgur.com/QQlMEzE.jpeg" alt="Showing hosts detailed saved on a text file" width="640px" /> 
<img src="https://imgur.com/ydnz5CD.jpeg" alt="Showing hosts detailed saved on a text file" width="640px" /> 


## Claves del proyecto y motivación 💡

Este proyecto fue realizado con el objetivo de seguir expandiendo mis sólidas bases en la ejecución de pruebas de vulnerabilidad. Logré profundizar mi conocimiento en:

- **Scripting en Bash**,
- **Escaneo de redes** y fundamentos de ciberseguridad orientados a pentesting,
- **Reconocimiento** de puertos, servicios y del S.O. detrás de la dirección IP objetivo, 
- **Automatización** de procesos usando **Nmap** y **Netcat** como herramientas de escaneo.


## Requisitos 🛠️

- **Bash** (Pre-instalado en la mayoría de sistemas Linux/macOS)
- **Nmap** (Si no está instalado, el script brinda instrucciones para instalarlo)
- **Netcat** (Si no está instalado, el script brinda instrucciones para instalarlo)

## Uso 🖥️

1. Clonar el repositorio:

    ```bash
    git clone https://github.com/raindescendent/frost-recon.git
    cd frost-recon
    ```

2. Hacer el script ejecutable:

    ```bash
    chmod 755 frost-recon.sh
    ```

3. Ejecutar el script con privilegios de root (esto es importante para el escaneo de red):

    ```bash
    sudo sh ./frost-recon.sh
    ```

4. Ingresar la dirección IPv4 objetivo.

5. Revisar los resultados en el archivo del reporte generado después de completar los escaneos.


### Mejoras Futuras:
- Añadir funcionalidad para **IPv6**.


## Conectate Conmigo 💬

- Con gusto estoy dispuesto recibir críticas constructivas sobre el proyecto.

- [LinkedIn](https://www.linkedin.com/in/santigimenez-dev) – ¡Hablemos sobre ciberseguridad y pentesting!


---

---


<a id="english-version"></a>
# Frost Scan - Network Reconnaissance Script 🛡️

### **Author**: [Santiago Gimenez]  
### **A.K.A.**: [descendent]  

[README Spanish Version](#spanish-version)

---

## Overview

**Frost Scan** is a simple yet powerful Bash script that performs automated network reconnaissance using the **Nmap** and **Netcat** tools. This script scans an IPv4 address provided by the user, dynamically determines the subnet, and performs a search for active host(s) and their respective open ports, resulting in a detailed final report of each open port, service, and version.


## Features ✨

- **Network Discovery**: Detects active host(s) by determining the subnet of the provided IPv4 address through **ping scans**.
- **OS Detection**: Automatically detects if the user is running Linux or macOS, guiding them to install the `Nmap` and `Netcat` tools if necessary.
- **Port Scanning**:
- **Standard Port Scanning**: Scans for the most recognized standard service ports (SSH, HTTP, FTP, etc.).
- **Full Range Port Scanning**: If none of the standard ports are found open, the script performs a full range scan of existing ports.
- **Results**: Saves active host(s) **reporting the OS, open ports, and details of the running service and its version.**

## How Does It Work? 🔍


1. **Modify the script permissions** and run it with **root privileges**.  
   <img src="https://imgur.com/X8VtgiY.jpeg" alt="Setting script permissions" width="640px" />

2. **Enter the target's IPv4 address**.

3. **Determine the subnet and start to enumerate the active host(s)**.  
   <img src="https://imgur.com/uP3hPy5.jpeg" alt="Program example discovers subnet and live hosts" width="640px" />

4. **Report the detected IPv4 addresses in the terminal** along with their respective active services and open TCP ports.  
   <img src="https://imgur.com/17Zjirx.jpeg" alt="Terminal output example showing host IP address, open TCP ports and active services" width="640px" />

5. **Save detailed information about each host in a text file**.  
   <img src="https://imgur.com/QQlMEzE.jpeg" alt="Showing hosts detailed saved on a text file" width="640px" />  
   <img src="https://imgur.com/ydnz5CD.jpeg" alt="Showing hosts detailed saved on a text file" width="640px" />


## Project Keys and Motivation 💡

This project was created with the goal of further expanding my solid foundations in penetration testing. I was able to deepen my knowledge in:

- **Bash Scripting**,
- **Network Scanning** and cybersecurity fundamentals oriented towards pentesting,
- **Reconnaissance** of ports, services, banner grabbing and O.S. fingerprinting, 
- **Automation** using **Nmap** and **Netcat** as scanning tools.

## Requirements 🛠️

- **Bash** (Pre-installed on most Linux/macOS systems)
- **Nmap** (If not installed, the script provides instructions for installation)
- **Netcat** (If not installed, the script provides instructions for installation)

## Usage 🖥️

1. Clone the repository:

    ```bash
    git clone https://github.com/raindescendent/frost-recon.git
    cd frost-recon
    ```

2. Make the script executable:

    ```bash
    chmod 755 frost-recon.sh
    ```

3. Run the script with root privileges (this is important for network scanning):

    ```bash
    sudo sh ./frost-recon.sh
    ```

4. Enter the target IPv4 address.

5. Review the results in the report file generated after completing the scans.


### Future Improvements:
- Add functionality for **IPv6**.

## Connect with Me 💬

- I am open to receiving constructive critics about the project.

- [LinkedIn](https://www.linkedin.com/in/santigimenez-dev) – Let’s talk about cybersecurity and pentesting!


---
