#!/bin/bash

# Color codes for output readability
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Welcome message 
echo "\n${GREEN}Welcome to Frost Scan!${RESET}"
echo "${GREEN}-------------------------------------------${RESET}"
echo "${GREEN}Please execute this program with root privileges.${RESET}"
echo "${GREEN}Consider setting file permissions by running:${RESET}"
echo "${YELLOW}chmod 755 frost-recon.sh${RESET}"
echo "${GREEN}-------------------------------------------${RESET}"
echo
echo "${GREEN}This script performs network reconnaissance by scanning an specified IPv4 target address for live active hosts on its subnet and then generates a detailed report using Nmap & Netcat tools."
echo
echo "Script Capabilities:"
echo "[+] Dynamic subnet detection based on the target IP address."
echo "[+] Identification of live hosts within the detected subnet using ping scans."
echo "[+] Comprehensive port scanning of detected hosts to identify open ports."
echo "[+] Detection of common services running on open ports, including HTTP, HTTPS, SSH, FTP, and more."
echo "[+] Extraction of service versions for identified services to aid in vulnerability assessment."
echo "[+] Saving scan results to a structured text file for easy review and reporting."
echo
echo "-------------------------------------------${RESET}\n"

# Detect the user operating system
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

# Checks for Nmap installation
if command -v nmap >/dev/null 2>&1; then
    echo "${GREEN}Nmap is installed correctly.${RESET}"
else
    echo "${RED}Nmap is not installed.${RESET}"
    echo "Install it using the appropriate command for your package manager."
    exit 1
fi

# Checks for Netcat installation
if command -v nc >/dev/null 2>&1; then
    echo "${GREEN}Netcat is installed correctly.${RESET}"
else
    echo "${RED}Netcat is not installed.${RESET}"
    echo "Install it using the appropriate command for your package manager."
    exit 1
fi

# Define commmon ports for scanning
common_ports="20,21,22,23,25,53,80,123,161,443,445,1433,1434,1521,3306,3389,5060,5432,8000,8080,8443"
banner_timeout=5 # Timeout for banner grabbing

# Prompt user for target IP address
echo "\nEnter a target IP address:"
read target_ip

# Detect network range dynamically
interface=$(ip route get "$target_ip" | grep -oP 'dev \K\S+')
network_range=$(ip -o -4 addr show "$interface" | awk '/inet/ {print $4}')

if [ -z "$network_range" ]; then
    echo "${RED}Failed to determine network range. Please check the IP address.${RESET}"
    exit 1
fi
echo "Detected network range: $network_range"

# Function to grab banners from services
banner_grab() {
    local ip=$1
    local port=$2
    local banner=""
    local version=""

    # Remove protocol suffix if present
    port="${port%%/*}"

    # Perform banner grabbing using Netcat tool 
    # Compares the port to each common HTTP/HTTPS ports
    if [ "$port" = "80" ] || [ "$port" = "443" ] || [ "$port" = "8080" ] || [ "$port" = "8000" ]; then
	    # If the port is for HTTP(S) services
	    # Then sends an HTTP GET request to fulfill the banner
        banner=$(echo "GET / HTTP/1.1\r\nHost: $ip\r\n\r\n" | nc -w $banner_timeout "$ip" "$port" 2>/dev/null)
    else
	# For other services ports, perform a simple TCP connection to fulfill the banner
        banner=$(echo "" | nc -w $banner_timeout "$ip" "$port" 2>/dev/null)
 
    fi
     
    # Extract the service version from the retrieved banner
    # Check for common protocols to determine the service version
    if echo "$banner" | grep -q "SSH"; then
        version="$(echo "$banner" | grep -o 'SSH[^ ]*' | head -n1)"
    elif echo "$banner" | grep -q "HTTP"; then
        version="$(echo "$banner" | grep -o 'HTTP[^ ]*' | head -n1)"
    elif echo "$banner" | grep -q "FTP"; then
        version="$(echo "$banner" | grep -o 'FTP[^ ]*' | head -n1)"
    elif echo "$banner" | grep -q "SMTP"; then
        version="$(echo "$banner" | grep -o 'SMTP[^ ]*' | head -n1)"
    elif echo "$banner" | grep -q "nginx"; then
        version="nginx $(echo "$banner" | grep -o 'nginx[^ ]*' | head -n1)"
    elif echo "$banner" | grep -q "Apache"; then
        version="Apache $(echo "$banner" | grep -o 'Apache[^ ]*' | head -n1)"
    else
        
    # If no specific service was detected, prints the first 20 characters of the banner data
    version=$(echo "$banner" | grep -Eo '^[^ ]+ [^ ]+' | head -n1)
          if [ -z "$version" ]; then
            version=$(echo "$banner" | cut -c1-20)
        fi
    fi

    # Default to "Unknown service" if no version is detected
    if [ -z "$version" ]; then
        version="Unknown service"
    fi

    echo "$version" # Return the detected version

}

echo "[$network_range] subnet..." # Indicate the start of the subnet scan

# Ping scan to find live hosts
echo "Started to perform a ping scan. Searching for live hosts in the network..."
nmap_output=$(nmap -sn "$network_range") # Execute a ping scan to find live host(s)
live_hosts=$(echo "$nmap_output" | grep "Nmap scan report" | awk '{print $5}') # Extract live host(s) IP addresses

# Stops the script if no live host(s) were found
if [ -z "$live_hosts" ]; then
    echo "No live hosts found in the network range $network_range. Exiting..."
    exit 1
fi

# Save live host(s) to a file
network_name=$(echo "$network_range" | cut -d'/' -f1)
echo "Saving live host(s) IP(s) in a .txt file: $network_name.txt" 
echo "$live_hosts" > "$network_name.txt"

# Prints how many live host(s) are saved
nums_ips=$(wc -l < "$network_name.txt") 
echo "There are $nums_ips active live host(s) on $network_range subnet."

temp_file="${network_name}_temp.txt" # Temporary file for storing results

# Scan each live host(s) for open ports and services 
while IFS= read -r ip; do
	echo "\n[$ip]" >> "$temp_file" # Append the IP(s) to the temp file
	echo "\n[$ip]" # Prints the IP(s)

    # Runs nmap scan with service detection and O.S. fingerprinting
    scan_result=$(nmap -sS -sV -O -p "$common_ports" "$ip") # Execute nmap limited range scan discovering services and host operating system
    os_info=$(echo "$scan_result" | grep "OS details" | cut -d ':' -f2 | xargs) # Extract OS info
    open_ports=$(echo "$scan_result" | grep "open" | awk '{print $1}' | tr '\n' ', ' | sed 's/,$//; s#/tcp##g; s#/udp##g; s/,/, /g') # Lists open ports

    # Prints results for common open ports
    if [ -n "$open_ports" ]; then
	echo "O.S: ${os_info:-Unknown}" | tee -a "$temp_file" # Prints OS info 
	echo "[Open TCP Ports]" | tee -a "$temp_file" # Prints header for open ports
        echo "[$open_ports]" | tee -a "$temp_file" # Prints list of open ports
        echo
        printf "\n%-7s		%-15s	%-30s\n" "PORT" "SERVICE" "VERSION" | tee -a "$temp_file" # Prints headers for the detailed report

	# Parse nmap results for service details 
        echo "$scan_result" | grep "open" | while read -r line; do
            port=$(echo "$line" | awk '{print $1}' | sed 's#/.*##') # Extract port number
            service_name=$(echo "$line" | awk '{print $3}' | sed 's/^\s*//; s/\s*$//') # Extract service name
            service_version=$(banner_grab "$ip" "$port" | sed 's/^\s*//; s/\s*$//') # Get service version using the already declared function: banner_grab

            printf "%-7s	 	%-15s	%-30s\n" "$port" "$service_name" "$service_version" | tee -a "$temp_file" # Prints details of each service
        done
    else 
        echo "No open common ports on $ip. Proceeding to full range scan."
        
        # Perform full range port scan using Nmap 
	scan_result=$(nmap -p- -sS --min-rate 5000 -n -Pn "$ip") 
	os_info=$(echo "$scan_result" | grep "OS details" | cut -d ':' -f2 | xargs)
	open_ports=$(echo "$scan_result" | grep "open" | awk '{print $1}' | tr '\n' ', ' | sed 's/,$//; s#/tcp##g; s#/udp##g; s/,/, /g')
    
	# Prints results of the full range scan
	if [ -n "$open_ports" ]; then
		echo "O.S: ${os_info:-Unknown}" | tee -a "$temp_file" # Prints OS info
		echo "[Open TCP Ports]" | tee -a "$temp_file" # Prints header for open ports
        	echo "[$open_ports]" | tee -a "$temp_file" # Prints lists of open ports
        	echo
            printf "\n%-7s		%-15s		%-30s\n" "PORT" "SERVICE" "VERSION" | tee -a "$temp_file" # Prints headers for the detailed report

	    # Parse Nmap results for service details
            echo "$scan_result" | grep "open" | while read -r line; do
                port=$(echo "$line" | awk '{print $1}' | sed 's#/.*##') # Extract port number
                service_name=$(echo "$line" | awk '{print $3}' | sed 's/^\s*//; s/\s*$//') # Extract service name
                service_version=$(banner_grab "$ip" "$port" | sed 's/^\s*//; s/\s*$//') # Get service version using the already declared function banner_grab

                printf "%-7s		%-15s	%-30s\n" "$port" "$service_name" "$service_version" | tee -a "$temp_file" # Prints details of each service
            done
        else
            echo "No open ports found in the full range scan for $ip."
            echo "No open ports found in the full range scan for $ip." >> "$temp_file"
        fi
    fi

    echo >> "$temp_file"
    echo                   

done < "$network_name.txt"
# Move temp file to final output
mv "$temp_file" "$network_name.txt"

echo "Scan completed. Results saved in $network_name.txt"

