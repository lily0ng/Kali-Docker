# Make setup script executable
chmod +x setup-kali.sh

# Start the full Kali system
docker-compose up -d

# Access the container
docker exec -it kali-full-system zsh

# Or with bash
docker exec -it kali-full-system bash

# Stop the system
docker-compose down

# Stop and remove volumes
docker-compose down -v

# View logs
docker-compose logs -f

# Update tools inside container
docker exec kali-full-system apt update && apt upgrade -y


Feature Summary

Full Network Access - host network mode for scanning/tools

GUI Support - X11 forwarding for graphical tools

Persistent Storage - All configs and files saved

All Kali Tools - Complete kali-linux-everything package

GPU Support - Access to host GPU for hashcat/John

Sound Support - PulseAudio for multimedia

Database - Optional PostgreSQL for Metasploit

VNC Access - Web interface alternative

Tool Configs - Pre-configured directories for tools

Shared Folder - Easy file transfer between host and container