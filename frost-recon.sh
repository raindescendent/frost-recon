#!/bin/bash

GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Welcome message & script description initializing them and providing user instructions
echo "${GREEN}Welcome to Frost Scan!${RESET}"
echo "-------------------------------------------"
echo "Please execute this program with root privileges."
echo "Consider setting file permissions by running:\n"
echo "${YELLOW}chmod 755 frost-recon.sh${RESET}"
echo "-------------------------------------------"
echo "${GREEN}This script performs network reconnaissance by scanning a specified target IPv4 address for live hosts and open ports using nmap.${RESET}"

# O.S. detection to improve the precision of user instructions based on their enviroment
os_type=$(uname -s)
case "$os_type" in
    Linux)
        echo "${GREEN}Linux detected.${RESET}"
        ;;
    Darwin)
        echo "${GREEN}macOS detected.${RESET}"
        ;;
    *)
        echo "${RED}Unsupported OS detected: $os_type.${RESET}"
        exit 1
        ;;
esac

# Checking if nmap is installed this tool is essential to perform the network scans
# Also discover the user-package manager to clarify the command needed depending on the user s.o. to install it  
if command -v nmap >/dev/null 2>&1; then
    echo "${GREEN}Nmap is installed correctly.${RESET}"
else
    echo "${RED}Nmap is not installed.${RESET}"
    echo "Install it using the following command based on your package manager:"
    
    if command -v apt >/dev/null 2>&1; then
        echo "${YELLOW}For Debian-based systems: sudo apt install nmap${RESET}"
    elif command -v yum >/dev/null 2>&1; then
        echo "${YELLOW}For Red Hat-based systems: sudo yum install nmap${RESET}"
    elif command -v dnf >/dev/null 2>&1; then
        echo "${YELLOW}For Fedora systems: sudo dnf install nmap${RESET}"
    elif command -v brew >/dev/null 2>&1; then
        echo "${YELLOW}For macOS: brew install nmap${RESET}"
    else
        echo "${RED}Unsupported package manager. Please install nmap manually.${RESET}"
    fi
    
    exit 1
fi

echo

# Defining a list of standard ports 
# The 'common_ports' variable stores standard service ports for quicker reconnaissance
common_ports="20,21,22,23,25,53,80,123,161,443,445,1433,1434,1521,3306,3389,5060,5432,8000,8080,8443"

echo "Enter a target IP address:"
read target_ip

# Determines the network subnet of the target IP 
# Also checks the format of user entered IP
interface=$(ip route get "$target_ip" | grep -oP 'dev \K\S+')
network_range=$(ip -o -4 addr show "$interface" | awk '/inet/ {print $4}')

if [ -z "$network_range" ]; then
    echo "Failed to determine network range. Please check the IP address."
    exit 1
fi

echo "[$network_range] subnet..."

# Ping scan init to discover live host(s) within the specified network range using nmap
echo "Started to perform a ping scan. Searching for live host(s) in the network..."
nmap_output=$(nmap -sn $network_range)

live_hosts=$(echo "$nmap_output" | grep "Nmap scan report" | awk '{print $5}')

# Check if any live hosts were found
if [ -z "$live_hosts" ]; then
    echo "No live hosts found in the network range $network_range. Exiting..."
    exit 1
fi

# Saving host(s) IP's into a file also creates a temp file for data manipulation 
network_name=$(echo "$network_range" | cut -d'/' -f1)
echo "Saving live host(s) IP(s) in a .txt file: $network_name.txt" 
echo "$live_hosts" > "$network_name.txt"

nums_ips=$(wc -l < "$network_name.txt") 
echo "There are $nums_ips active live host(s) on $network_range subnet." # Print on terminal the host(s) total count.

temp_file="${network_name}_temp.txt"

# Loop through discovered live host(s) to perform an initial scan on common ports. If no open ports are found, a full-range port scan is performed
while IFS= read -r ip; do
    echo "[$ip]: Scanning common ports"

    scan_result=$(nmap -sS -p "$common_ports" "$ip") # Base standard port scan

    open_ports=""

# Check if the grep command finds any open ports in the initial-scan results     
    echo "$scan_result" | grep -q "open"
    if [ $? -eq 0 ]; then

# Extracts and format the opened ports to the already declared variable 'open_ports'
        open_ports=$(echo "$scan_result" | grep "open" | awk '{print $1}' | tr '\n' ',' | sed 's/,$//')
        echo "[$ip]: Opened Ports [$open_ports]"
        echo "[$ip]: Opened Ports [$open_ports]" >> "$temp_file"
    else
# If the initial-scan result wasn't sucessful (no opened common ports) the code performs a full-range port scan
        echo "[$ip]: No common ports are opened"
	echo "[$ip]: Proceeding to full range port scan"

        scan_result=$(nmap -sS -PN -n --min-rate 5000 -p- "$ip") # Full-range port scan

# Extract and format the opened ports discovered on the full-range scan to the already declared variable 'open_ports'
        open_ports=$(echo "$scan_result" | grep "open" | awk '{print $1}' | tr '\n' ',' | sed 's/,$//')

        if [ -n "$open_ports" ]; then
            echo "[$ip]: Opened Full Range Ports [$open_ports]"
            echo "[$ip]:	Opened Full Range Ports [$open_ports]" >> "$temp_file"
        else
            echo "[$ip]: No open ports found in the full range scan."
            echo "[$ip]:	No open ports found in the full range scan." >> "$temp_file"
        fi
    fi

    echo  

done < "$network_name.txt" # End of while loop finishing the IP host(s) read

mv "$temp_file" "$network_name.txt" # Updating scan information

echo "Scan completed. Results saved in $network_name.txt"

