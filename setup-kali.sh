#!/bin/bash

# Create directory structure
mkdir -p {kali-persistent,shared,configs,msf-data,burp,john,hashcat,novnc}

# Set proper permissions
chmod 755 shared
chmod 700 kali-persistent

# Function to install all Kali tools
install_all_tools() {
    echo "Starting installation of all Kali tools..."
    
    # Update system
    apt update && apt upgrade -y
    
    # Install full Kali Linux metapackage
    apt install -y kali-linux-everything
    
    # Additional useful packages
    apt install -y \
        kali-desktop-xfce \
        kali-tools-gpu \
        flameshot \
        terminator \
        tilix \
        byobu \
        gobuster \
        nikto \
        nuclei \
        feroxbuster \
        bloodhound \
        powershell-empire \
        crackmapexec \
        impacket-scripts \
        seclists \
        wordlists
    
    # Install useful Python tools
    pip3 install \
        pwntools \
        ropper \
        angr \
        frida-tools \
        objection \
        mitmproxy \
        autopwn \
        pwncat-cs
    
    # Clean up
    apt autoremove -y && apt clean
}

# Export function for docker exec
export -f install_all_tools

echo "Starting Kali Docker setup..."
docker-compose up -d kali-full

echo "Waiting for container to start..."
sleep 10

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

echo "Setup complete!"
echo "Access your Kali container with: docker exec -it kali-full-system zsh"
echo "Shared folder location: ./shared"