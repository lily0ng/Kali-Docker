# Multi-OS Security Lab Setup Guide

## Overview
This enhanced Kali-Docker setup provides a comprehensive multi-OS security testing environment with service discovery, load balancing, and monitoring capabilities.

## Docker Compose Files

### 1. docker-compose.yml (Original)
- Basic Kali Linux setup
- PostgreSQL database
- SSH access
- VNC desktop

### 2. docker-compose.enhanced.yml (Full Stack)
- All original services
- Multiple OS containers (Kali, Parrot, Ubuntu, Alpine)
- Advanced monitoring (Grafana, Prometheus, Node Exporter)
- SIEM stack (Wazuh, Elasticsearch, Kibana)
- Analysis tools (Jupyter, Zeek, Cuckoo)
- Security services (WAF, OpenVAS)

### 3. docker-compose.profiles.yml (Profile-Based)
- Organized services by profiles:
  - **basic**: Core Kali + PostgreSQL + SSH
  - **full**: All services
  - **monitoring**: Grafana, Prometheus, Node Exporter, Redis
  - **analysis**: Jupyter, Zeek, Cuckoo
  - **security**: WAF, OpenVAS
  - **siem**: Wazuh, Elasticsearch, Kibana

### 4. docker-compose.discovery.yml (Service Discovery)
- Consul for service discovery
- Nginx load balancer
- Traefik modern load balancer
- Fabio load balancer
- Istio service mesh

## Quick Start

### Basic Setup
```bash
# Start basic services
docker-compose -f docker-compose.profiles.yml --profile basic up -d

# Access methods:
# SSH: ssh -i ssh-keys/id_rsa -p 2222 root@localhost
# Direct shell: docker exec -it kali-full-system zsh
# VNC: docker-compose -f docker-compose.profiles.yml --profile full up -d kali-vnc
```

### Full Lab Setup
```bash
# Start all services
docker-compose -f docker-compose.enhanced.yml up -d

# Or using profiles
docker-compose -f docker-compose.profiles.yml --profile full up -d
```

### Service Discovery
```bash
# Start service discovery stack
docker-compose -f docker-compose.discovery.yml up -d

# Access Consul UI: http://localhost:8500
# Access Traefik Dashboard: http://localhost:8081
# Access Nginx Load Balancer: http://localhost:8080
```

## Multi-OS Containers

### Kali Linux
- **Container**: kali-full-system
- **Access**: SSH (2222), Direct shell, VNC (6080)
- **Features**: Full Kali toolset, privileged access, host networking

### Parrot OS
- **Container**: parrot-security
- **Access**: Docker exec
- **Features**: Parrot security tools, MATE desktop environment

### Ubuntu Security
- **Container**: ubuntu-security
- **Access**: Docker exec
- **Features**: Ubuntu 22.04 with security tools installed

### Alpine Security
- **Container**: alpine-security
- **Access**: Docker exec
- **Features**: Lightweight Alpine with essential security tools

## Service Ports

### Core Services
- **SSH**: 2222
- **VNC**: 6080
- **PostgreSQL**: 5432

### Monitoring
- **Grafana**: 3000 (admin/admin123)
- **Prometheus**: 9090
- **Node Exporter**: 9100
- **Redis**: 6379

### Analysis Tools
- **Jupyter**: 8888
- **Cuckoo**: 2042 (API), 8080 (Web UI)
- **Zeek**: Host network mode

### Security Services
- **WAF**: 80, 443
- **OpenVAS**: 9392

### SIEM Stack
- **Wazuh Manager**: 55000
- **Elasticsearch**: 9200
- **Kibana**: 5601

### Service Discovery
- **Consul UI**: 8500
- **Consul DNS**: 8600
- **Traefik Dashboard**: 8081
- **Nginx LB**: 8080
- **Fabio**: 9998 (HTTP), 9999 (HTTPS)

## Network Architecture

### kali-network (172.20.0.0/24)
- Main security lab network
- All containers communicate here
- Isolated from host network (except kali-full)

### discovery-network (172.21.0.0/24)
- Service discovery and load balancing
- Consul, Traefik, Nginx, Fabio
- Connects to kali-network for service access

## Persistent Data

### Named Volumes
- `kali-home-volume`: Kali home directory
- `parrot-home-volume`: Parrot home directory
- `ubuntu-home-volume`: Ubuntu home directory
- `alpine-home-volume`: Alpine home directory
- `kali-postgres-data`: PostgreSQL data
- `kali-grafana-data`: Grafana configuration
- `kali-prometheus-data`: Prometheus data
- `consul-data-volume`: Consul data
- And many more...

### Bind Mounts
- `./shared`: Shared files between containers
- `./configs`: Configuration files
- `./data`: General data storage
- `./ssh-keys`: SSH keys for access

## Usage Examples

### Start Specific Profiles
```bash
# Basic security testing
docker-compose -f docker-compose.profiles.yml --profile basic up -d

# Add monitoring
docker-compose -f docker-compose.profiles.yml --profile monitoring up -d

# Add analysis tools
docker-compose -f docker-compose.profiles.yml --profile analysis up -d

# Full security lab
docker-compose -f docker-compose.profiles.yml --profile full up -d
```

### Service Discovery Integration
```bash
# Start service discovery
docker-compose -f docker-compose.discovery.yml up -d

# Start security lab with discovery
docker-compose -f docker-compose.enhanced.yml up -d
docker-compose -f docker-compose.discovery.yml up -d

# Access services through load balancers
curl http://localhost:8080/health
curl http://localhost/health  # Traefik
```

### Container Management
```bash
# View running containers
docker ps

# View logs
docker-compose -f docker-compose.enhanced.yml logs -f kali-full

# Access specific containers
docker exec -it kali-full-system zsh
docker exec -it parrot-security bash
docker exec -it ubuntu-security bash
docker exec -it alpine-security ash

# Stop specific services
docker-compose -f docker-compose.profiles.yml --profile monitoring down
```

## Configuration Files

### Service Discovery
- `./nginx/conf.d/`: Nginx load balancer configuration
- `./traefik/traefik.yml`: Traefik configuration
- `./consul-template/`: Consul templates for dynamic config

### Monitoring
- `./prometheus/prometheus.yml`: Prometheus configuration
- `./grafana/provisioning/`: Grafana dashboard provisioning

### Security
- `./waf/config/`: WAF configuration
- `./wazuh/rules/`: Wazuh custom rules

## Troubleshooting

### Common Issues
1. **Port conflicts**: Check if ports are already in use
2. **Resource limits**: Adjust CPU/memory limits in docker-compose files
3. **Network issues**: Ensure proper network configuration
4. **Permission issues**: Check Docker daemon permissions

### Health Checks
```bash
# Check container health
docker ps --format "table {{.Names}}\t{{.Status}}"

# Check specific service health
docker inspect kali-full-system | grep Health -A 10
```

### Logs
```bash
# View service logs
docker-compose -f docker-compose.enhanced.yml logs -f [service_name]

# View all logs
docker-compose -f docker-compose.enhanced.yml logs -f
```

## Security Considerations

1. **Network Isolation**: Containers are isolated in dedicated networks
2. **Resource Limits**: CPU and memory limits prevent resource exhaustion
3. **Access Control**: SSH key-based authentication only
4. **Monitoring**: All services are monitored with health checks
5. **Data Persistence**: Important data is stored in named volumes

## Next Steps

1. Customize configurations for your specific needs
2. Add custom tools and scripts
3. Configure backup strategies
4. Set up automated monitoring alerts
5. Integrate with external security tools
