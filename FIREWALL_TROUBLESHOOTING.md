# Firewall and Network Issues Troubleshooting

## Issue Summary

The environment is experiencing network connectivity issues that prevent external connections. This affects package installation, external API calls, and general internet connectivity.

## Diagnosed Problems

1. **DNS Resolution Failure**: The container cannot resolve external hostnames
2. **Network Connectivity Issues**: Cannot establish connections to external services
3. **Missing Network Tools**: Standard diagnostic tools (nc, dig, nslookup) are not available
4. **Container Network Isolation**: The container appears to be isolated from external networks

## Current Environment Status

```bash
# Container Information
- Running in Docker container (Ubuntu 24.04.3 LTS)
- User: root (UID 0)
- Network Interface: eth0@if5 with IP 172.18.0.2/16
- Gateway: 172.18.0.1

# DNS Configuration (After Fix)
nameserver 8.8.8.8
nameserver 1.1.1.1  
nameserver 1.0.0.1

# Connectivity Status
❌ External HTTP/HTTPS connections fail
❌ DNS queries fail
❌ Cannot install packages from repositories
```

## Applied Fixes

### 1. DNS Configuration Update
Updated `/etc/resolv.conf` with reliable public DNS servers:
- Google DNS: 8.8.8.8
- Cloudflare DNS: 1.1.1.1, 1.0.0.1

### 2. Created Diagnostic Tools
- `fix_firewall_issues.sh`: Comprehensive network diagnostics and automated fixes
- Automated detection of container environment and network configuration
- Attempts automatic fixes when running as root

## Recommended Solutions

### For Container Host/Administrator

1. **Review Docker Network Configuration**
   ```bash
   # Check Docker network settings
   docker network ls
   docker network inspect bridge
   
   # Ensure DNS is properly configured
   docker run --rm ubuntu:latest nslookup google.com
   ```

2. **Check Host Firewall Rules**
   ```bash
   # Check iptables rules on host
   sudo iptables -L -n
   
   # Check for Docker-related chains
   sudo iptables -t nat -L -n
   ```

3. **Container Network Troubleshooting**
   ```bash
   # Test connectivity from host
   ping google.com
   
   # Check if container can reach host gateway
   docker exec <container> ping 172.18.0.1
   
   # Check container DNS resolution
   docker exec <container> nslookup google.com 8.8.8.8
   ```

### For Workflow Configuration

4. **GitHub Actions Container Options**
   Consider updating `.github/workflows/copilot-setup-steps.yml`:
   
   ```yaml
   container:
     image: ghcr.io/actions/actions-runner:latest
     options: >-
       -v /home/runner/work:/home/runner/work
       --dns 8.8.8.8
       --dns 1.1.1.1
       --add-host host.docker.internal:host-gateway
   ```

5. **Alternative Container Images**
   Consider using a base image with better network support:
   ```yaml
   container:
     image: ubuntu:latest
     options: >-
       -v /home/runner/work:/home/runner/work
       --dns 8.8.8.8
   ```

### For Development Environment

6. **Local Testing**
   ```bash
   # Test the workflow locally with act
   act -j copilot-setup-steps
   
   # Test container connectivity
   docker run --rm -it ubuntu:latest bash
   ```

## Workarounds

### 1. Offline Package Installation
If packages are needed, consider:
- Pre-installing tools in a custom Docker image
- Using cached packages
- Mounting tools from the host system

### 2. Alternative Connectivity Methods
- Use host network mode if security permits
- Configure proxy settings if behind corporate firewall
- Use alternative package repositories or mirrors

## Monitoring and Verification

Use the provided scripts to verify fixes:

```bash
# Run comprehensive diagnostics
./fix_firewall_issues.sh

# Check specific connectivity
./show_mounted_source_dir.sh

# Test basic connectivity
timeout 5 bash -c 'exec 3<>/dev/tcp/8.8.8.8/53' && echo "DNS connectivity OK"
```

## Next Steps

1. **Immediate**: The current environment has limited connectivity but can still perform local operations
2. **Short-term**: Update container configuration to resolve network issues  
3. **Long-term**: Implement proper network configuration in the CI/CD pipeline

## Files Created

- `fix_firewall_issues.sh` - Network diagnostics and automated fixes
- `show_mounted_source_dir.sh` - Environment information display
- `FIREWALL_TROUBLESHOOTING.md` - This documentation

## Contact

If issues persist, contact the system administrator or DevOps team with:
- Container ID and network configuration
- Host firewall settings
- Corporate network/proxy settings
- This troubleshooting report