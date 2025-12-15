#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Kali-Docker Setup ===${NC}"

# Create directory structure
echo -e "${YELLOW}[*] Creating directories...${NC}"
mkdir -p {kali-persistent,shared,configs,msf-data,burp,john,hashcat,novnc,postgres-data,init-db,ssh-keys}

# Set proper permissions
echo -e "${YELLOW}[*] Setting permissions...${NC}"
chmod 755 shared
chmod 700 kali-persistent

# Generate SSH keys if they don't exist
if [ ! -f "ssh-keys/id_rsa" ]; then
    echo -e "${YELLOW}[*] Generating SSH keys...${NC}"
    ssh-keygen -t rsa -b 4096 -f ssh-keys/id_rsa -N ""
    chmod 600 ssh-keys/id_rsa*
    cp ssh-keys/id_rsa.pub kali-persistent/.ssh/authorized_keys 2>/dev/null || mkdir -p kali-persistent/.ssh && cp ssh-keys/id_rsa.pub kali-persistent/.ssh/authorized_keys
    chmod 700 kali-persistent/.ssh
    chmod 600 kali-persistent/.ssh/authorized_keys
fi

# Function to install all Kali tools
install_all_tools() {
    echo -e "${GREEN}[*] Starting installation of all Kali tools...${NC}"
    
    # System update and base tools
    echo -e "${YELLOW}[*] Updating system and installing base tools...${NC}"
    apt update && apt full-upgrade -y
    apt install -y \
        kali-linux-everything \
        kali-desktop-xfce \
        kali-tools-all \
        terminator \
        tilix \
        byobu \
        tmux \
        zsh \
        git \
        curl \
        wget \
        jq \
        htop \
        net-tools \
        dnsutils \
        iputils-ping \
        netcat \
        socat \
        ncat

    # Web Application Testing
    echo -e "${YELLOW}[*] Installing web application testing tools...${NC}"
    apt install -y \
        burpsuite \
        zaproxy \
        sqlmap \
        wpscan \
        wfuzz \
        dirb \
        dirbuster \
        gobuster \
        ffuf \
        nikto \
        whatweb \
        wafw00f \
        sublist3r \
        amass \
        subfinder \
        assetfinder \
        httprobe \
        httpx \
        nuclei \
        naabu \
        gau \
        waybackurls \
        gf \
        qsreplace \
        dalfox \
        kxss \
        dnsx \
        subzy \
        httpx-toolkit \
        feroxbuster

    # Network Tools
    echo -e "${YELLOW}[*] Installing network tools...${NC}"
    apt install -y \
        nmap \
        masscan \
        wireshark \
        tshark \
        tcpdump \
        netdiscover \
        arp-scan \
        dnsenum \
        dnsrecon \
        ike-scan \
        onesixtyone \
        snmpcheck \
        sslscan \
        sslyze \
        testssl.sh \
        crackmapexec \
        impacket-scripts \
        responder \
        bettercap \
        mitmproxy \
        chisel \
        proxychains4 \
        sshuttle \
        dns2tcp \
        iodine

    # Password Attacks
    echo -e "${YELLOW}[*] Installing password attack tools...${NC}"
    apt install -y \
        hydra \
        john \
        hashcat \
        hashid \
        hash-identifier \
        fcrackzip \
        pdfcrack \
        patator \
        crowbar \
        ncrack \
        medusa \
        thc-pptp-bruter \
        wordlists

    # Wireless Tools
    echo -e "${YELLOW}[*] Installing wireless tools...${NC}"
    apt install -y \
        aircrack-ng \
        reaver \
        bully \
        wifite \
        wifiphisher \
        mdk4 \
        hcxtools \
        hcxdumptool \
        kismet

    # Exploitation Tools
    echo -e "${YELLOW}[*] Installing exploitation frameworks...${NC}"
    apt install -y \
        metasploit-framework \
        exploitdb \
        searchsploit \
        msfpc \
        armitage \
        beef-xss \
        setoolkit \
        social-engineer-toolkit \
        powershell-empire \
        veil \
        shellter \
        veil-framework \
        backdoor-factory

    # Post-Exploitation
    echo -e "${YELLOW}[*] Installing post-exploitation tools...${NC}"
    apt install -y \
        bloodhound \
        powersploit \
        mimikatz \
        pypykatz \
        evil-winrm \
        chisel \
        pwncat-cs \
        kerbrute \
        cobalt-strike \
        silenthound \
        ldapdomaindump \
        adidnsdump \
        certipy \
        dementor

    # Reverse Engineering
    echo -e "${YELLOW}[*] Installing reverse engineering tools...${NC}"
    apt install -y \
        ghidra \
        radare2 \
        cutter \
        gdb \
        gdb-peda \
        gdb-peda-python \
        gdb-multiarch \
        pwndbg \
        pwntools \
        ropper \
        angr \
        frida \
        frida-tools \
        objection \
        apktool \
        jadx \
        dex2jar \
        smali \
        baksmali \
        jd-gui \
        ghidra \
        cutter \
        binwalk \
        foremost \
        exiftool \
        steghide \
        stegsnow \
        stegsnow \
        steghide

    # Python Tools
    echo -e "${YELLOW}[*] Installing Python tools...${NC}"
    pip3 install --upgrade pip
    pip3 install \
        pwntools \
        ropper \
        angr \
        frida-tools \
        objection \
        mitmproxy \
        autopwn \
        pwncat-cs \
        pwntools \
        ropgadget \
        ROPGadget \
        pwn \
        pwntools \
        ropper \
        angr \
        frida-tools \
        objection \
        mitmproxy \
        autopwn \
        pwncat-cs \
        pwntools \
        ropgadget \
        ROPGadget \
        pwn

    # Golang Tools
    echo -e "${YELLOW}[*] Installing Go tools...${NC}"
    export GOPATH=~/go
    export PATH=$PATH:$GOPATH/bin
    
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    go install -v github.com/OWASP/Amass/v3/...@master
    go install -v github.com/tomnomnom/assetfinder@latest
    go install -v github.com/tomnomnom/waybackurls@latest
    go install -v github.com/tomnomnom/httprobe@latest
    go install -v github.com/tomnomnom/meg@latest
    go install -v github.com/tomnomnom/gf@latest
    go install -v github.com/ffuf/ffuf@latest
    go install -v github.com/lc/gau/v2/cmd/gau@latest
    go install -v github.com/hahwul/dalfox/v2@latest
    go install -v github.com/jaeles-project/gospider@latest
    go install -v github.com/hakluke/hakrawler@latest
    go install -v github.com/jaeles-project/jaeles@latest
    go install -v github.com/jaeles-project/jaeles-plugins@latest
    go install -v github.com/hahwul/psmagnet@latest
    go install -v github.com/hahwul/dalfox/v2@latest
    go install -v github.com/hahwul/psmagnet@latest
    go install -v github.com/hahwul/pspy@latest
    go install -v github.com/hahwul/pspy64@latest

    # Custom Tools
    echo -e "${YELLOW}[*] Installing custom tools...${NC}"
    cd /opt
    
    # Install SecLists
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git
    ln -s /opt/SecLists /usr/share/wordlists/SecLists
    
    # Install LinPEAS/WinPEAS
    mkdir -p /opt/peas
    wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O /opt/peas/linpeas.sh
    wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx64.exe -O /opt/peas/winPEASx64.exe
    wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx86.exe -O /opt/peas/winPEASx86.exe
    chmod +x /opt/peas/*
    
    # Install pspy
    wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy64 -O /usr/local/bin/pspy64
    wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy32 -O /usr/local/bin/pspy32
    chmod +x /usr/local/bin/pspy*
    
    # Install chisel
    wget https://github.com/jpillora/chisel/releases/download/v1.7.7/chisel_1.7.7_linux_amd64.gz -O /tmp/chisel.gz
    gzip -d /tmp/chisel.gz
    mv /tmp/chisel /usr/local/bin/
    chmod +x /usr/local/bin/chisel

    # Clean up
    echo -e "${YELLOW}[*] Cleaning up...${NC}"
    apt autoremove -y && apt clean
    rm -rf /var/lib/apt/lists/*
    
    echo -e "${GREEN}[+] All tools installed successfully!${NC}"
}

# Export function for docker exec
export -f install_all_tools

# Create init script for Metasploit DB
echo -e "${YELLOW}[*] Creating Metasploit database configuration...${NC}"
cat > init-db/01-metasploit.sh << 'EOL'
#!/bin/bash
set -e

# Wait for Postgres to be ready
until PGPASSWORD=msfpassword psql -h kali-postgres -U msf -d msf -c '\q' 2>/dev/null; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

# Configure Metasploit to use external Postgres
cat > /usr/share/metasploit-framework/config/database.yml << 'DB_CONFIG'
production:
  adapter: postgresql
  database: msf
  username: msf
  password: msfpassword
  host: kali-postgres
  port: 5432
  pool: 5
  timeout: 5
DB_CONFIG

echo "Metasploit database configuration complete!"
EOL

chmod +x init-db/01-metasploit.sh

# Start the services
echo -e "${GREEN}[+] Starting Docker services...${NC}
docker-compose up -d kali-full postgres kali-ssh

# Wait for services to be healthy
echo -e "${YELLOW}[*] Waiting for services to start (this may take a minute)...${NC}
"
# Wait for kali-full to be healthy
MAX_RETRIES=30
RETRY_COUNT=0
while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if docker ps --filter "name=kali-full" --filter "health=healthy" | grep -q "kali-full"; then
        echo -e "${GREEN}[+] kali-full is up and healthy!${NC}"
        break
    fi
    echo -n "."
    sleep 5
    RETRY_COUNT=$((RETRY_COUNT+1))
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo -e "\n${YELLOW}[!] Warning: kali-full did not become healthy within the expected time${NC}"
    echo "Continuing with setup, but some services may not be fully initialized..."
fi

echo "Installing all tools (This will take 1-2 hours depending on your internet speed)..."
docker exec -it kali-full-system bash -c "$(declare -f install_all_tools); install_all_tools"

echo "Setting up initial configurations..."
docker exec -it kali-full-system bash -c "
    # Configure ZSH with Oh-My-Zsh
    apt install -y zsh git curl
    sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended
    chsh -s \$(which zsh)
    
    # Configure tmux
    echo 'set -g mouse on' > ~/.tmux.conf
    
    # Configure metasploit
    msfdb init
    
    # Create aliases
    echo 'alias ll=\"ls -la\"' >> ~/.zshrc
    echo 'alias update=\"apt update && apt upgrade\"' >> ~/.zshrc
    echo 'alias msfconsole=\"msfconsole -q\"' >> ~/.zshrc
"

echo -e "\n${GREEN}=== Setup Complete! ===${NC}"
echo -e "\n${YELLOW}[*] Access Methods:"
echo "----------------------------------------"
echo -e "${GREEN}1. SSH Access:${NC}"
echo "   Command: ssh -i ssh-keys/id_rsa -p 2222 root@localhost"
echo "   Note: Use the SSH key in ssh-keys/ for passwordless login"

echo -e "\n${GREEN}2. Direct Container Shell:${NC}"
echo "   Command: docker exec -it kali-full-system zsh"

echo -e "\n${GREEN}3. Web Desktop (VNC):${NC}"
echo "   Command: docker-compose up -d kali-vnc"
"   Then open: http://localhost:6080"

echo -e "\n${YELLOW}[*] Service Information:"
echo "----------------------------------------"
echo -e "${GREEN}PostgreSQL:${NC}"
echo "  Host: localhost"
echo "  Port: 5432"
echo "  User: msf"
echo "  Password: msfpassword"
echo "  Database: msf"

echo -e "\n${GREEN}File Locations:${NC}"
echo "  Shared folder: ./shared"
echo "  SSH keys: ./ssh-keys/"
echo "  Persistent data: ./kali-persistent/"

echo -e "\n${YELLOW}[*] Next Steps:"
echo "----------------------------------------"
echo "1. To install additional tools, run:"
echo "   docker exec -it kali-full-system apt update && apt install -y <package>"

echo -e "\n2. To start all services:"
echo "   docker-compose up -d"

echo -e "\n${GREEN}Your Kali environment is ready!${NC}${NC}\n"