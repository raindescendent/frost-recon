
# Frost Scan - Script de Reconocimiento de Red 🛡️

### **Autor**: [Santiago Gimenez]  
### **A.K.A.**: [descendent]  

[README Version en Inglés](#english-version)

[README Version en Español](#)

---

## Descripción general

**Frost Scan** un script en Bash simple pero potente, realiza reconocimiento de red utilizando **nmap**. Este script escanea una dirección IPv4 introducida por el user, buscando host(s) activos y sus respectivos puertos abiertos, resultando en un reporte final basico de cada uno.

Este proyecto fue creado en 3 días siendo parte de mi proceso de aprendizaje sobre **scripting en Bash**, **nmap**, y conceptos básicos de **redes**.

## Características ✨

- **Descubrimiento de Red**: Detecta host(s) activos en una red determinada mediante **escaneos de ping**.
- **Detección de SO**: Detecta automáticamente si estás usando Linux o macOS, guiando a los usuarios para instalar `nmap` si es necesario.
- **Escaneo de Puertos**:
  - **Escaneo de Puertos estandar**: Escanea los puertos de servicios estandar (SSH, HTTP, FTP, etc.).
  - **Escaneo de Rango Completo de Puertos**: Si no se encuentran abiertos los puertos standard, el script realiza un escaneo de la totalidad de puertos.
- **Resultados**: Guarda los host(s) activos y sus respectivos puertos abiertos en un archivo de texto formateado como un informe básico.

## ¿Cómo Funciona? 🔍

El script sigue estos pasos básicos:

1. **Configuración del entorno**: Detecta tu sistema operativo y verifica si `nmap` está instalado.
2. **Subred**: Toma la IP proporcionada por el usuario y calcula el rango de la subred.
3. **Descubriendo host(s) con ping**: Encuentra host(s) activos dentro de la red.
4. **Escaneo de puertos**: Primero escanea los puertos standard en los host(s) activos. Si no se encuentran abiertos, se inicia un escaneo completo de la totalidad de puertos.
5. **Registro de resultados**: Guarda las direcciones IP(s) de cada host adicionando sus respectivos puertos abiertos en un archivo de texto.

## Motivación 💡

Este proyecto marca un evento importante sobre mi aprendizaje. En el transcurso de 3 días, logre profundizar mi conocimiento en:
- **Scripting en Bash**,
- **Escaneo de redes** y fundamentos de ciberseguridad orientados a pentesting,
- Y diversos testeos con **nmap** como herramienta de reconocimiento de red.

Este proyecto, es clave para:
- Entender cómo automatizar el reconocimiento ofensivo de red,
- Aprender sobre escaneo de puertos y servicios,
- Desarrollar un script adaptable a diferentes sistemas operativos.

## Requisitos 🛠️

- **Bash** (Pre-instalado en la mayoría de sistemas Linux/macOS)
- **nmap** (Si no está instalado, el script brinda instrucciones para instalarlo)

## Uso 🖥️

1. Clonar el repositorio:

    \`\`\`bash
    git clone https://github.com/raindescendent/frost-recon.git
    cd frost-recon
    \`\`\`

2. Hacer el script ejecutable:

    \`\`\`bash
    chmod 755 frost-recon.sh
    \`\`\`

3. Ejecutar el script con privilegios de root (esto es importante para el escaneo de red):

    \`\`\`bash
    sudo sh ./frost-recon.sh
    \`\`\`

4. Ingresar la dirección IPv4 objetivo.

5. Revisar los resultados en el archivo de texto generado después de completar los escaneos.

## Resultado 📄

Aquí hay un ejemplo de cómo el script registra en un archivo los hosts descubiertos y los puertos abiertos:


\`\`\`
192.168.1.10: Opened Ports [22,80,443]
192.168.1.15: No common ports are opened
192.168.1.15: Opened Full Range Ports [8080,8443]
\`\`\`

## Lo Aprendido 📝

- **Automatización**: Tareas de reconocimiento ofensivo de red.
- **Nmap**.
- **Scripting en Bash**.

### Mejoras Futuras:
- Añadir funcionalidad para **IPv6**.
- Añadir más características como **Detección de servicios** y **Reporte del sistema operativo de host**.

## Conectate Conmigo 💬

- Con gusto estoy dispuesto recibir críticas constructivas sobre el proyecto.

- [LinkedIn](https://www.linkedin.com/in/santigimenez-dev) – ¡Hablemos sobre ciberseguridad y pentesting!

---

---

<a id="english-version"></a>

# Frost Scan - Network Reconnaissance Script 🛡️

### **Author**: [Santiago Gimenez]  
### **A.K.A.**: [descendent]  

[Spanish README](#)

[English README](#english-version)

---

## Overview

Welcome to **Frost Scan**, a simple yet powerful Bash script designed to perform network reconnaissance using **nmap**. This script scans a specified target IPv4 address searching for live host(s) and their respective open ports, providing essential network information in an organized and automated way.

This project was completed in just **2-3 days** as part of my journey to learn **shell scripting**, **nmap**, and basic **networking concepts**.

## Features ✨

- **OS Detection**: Automatically identifies if you're running Linux or macOS, guiding users through the installation of `nmap` if necessary.
- **Network Discovery**: Detects live host(s) on a given network using **ping scans**.
- **Port Scanning**:
  - **Common Ports Scan**: Scans standard service ports (SSH, HTTP, FTP, etc.).
  - **Full Range Port Scan**: If standard ports aren't found open, the script performs a full-range port scan to uncover hidden services.
- **Results Output**: Saves live hosts and open ports into a formatted text file as a basic report.

## How It Works 🔍

The script follows these basic steps:

1. **Environment Setup**: It detects your operating system and checks if `nmap` is installed.
2. **Network Range Determination**: Takes the user-provided target IP and calculates the subnet range.
3. **Ping Scan**: Finds live hosts within the network.
4. **Port Scanning**: First scans standard ports on live hosts. If no open ports are found, it switches to a full port scan.
5. **Result Logging**: Saves the results of the open ports into a text file for easy access.

## Motivation 💡

This project marks a important key in my learning journey. Over the course of just 3 days, I was able to expand my knowledge in:
- **Shell scripting** in Bash,
- **Network scanning** and security pentest fundamentals,
- And the capabilities of **nmap** as a network reconnaissance tool.

By diving into this project, I was able to:
- Understand how to automate network offensive recon,
- Learn about port scanning,
- Develop a script that is adaptable to different operating systems.

## Prerequisites 🛠️

- **Bash** (Pre-installed on most Linux/macOS systems)
- **nmap** (If not installed, the script provides instructions to install it)

## Usage 🖥️

1. Clone the repository:

    \`\`\`bash
    git clone https://github.com/raindescendent/frost-recon.git
    cd frost-scan
    \`\`\`

2. Make the script executable:

    \`\`\`bash
    chmod 755 frost-recon.sh
    \`\`\`

3. Run the script with root privileges (this is important for network scanning):

    \`\`\`bash
    sudo sh ./frost-recon.sh
    \`\`\`

4. Input your target IPv4 address when prompted.

5. Review the results in the generated text file after the scan completes.

## Example Output 📄

Here's an example of how the script logs into a file the discovered hosts and open ports:

\`\`\`
192.168.1.10: Opened Ports [22,80,443]
192.168.1.15: No common ports are opened
192.168.1.15: Opened Full Range Ports [8080,8443]
\`\`\`

## Learned 📝

- **Automation**: Network offensive recon tasks.
- **Nmap**.
- **Bash Scripting**.

### Future Improvements:
- Add **IPv6** support.
- Add more features like **service detection** or **OS fingerprinting**.

## Connect with Me 💬

- I will be glad to receive your constructive critics about the project.

- [LinkedIn](https://www.linkedin.com/in/santigimenez-dev) – Let’s connect and talk about cybersecurity and pentesting!

---
